//
//  AppDelegate.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/24.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation
import SVProgressHUD
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate{

    var window: UIWindow?

    // qq 登录
    var tencentAuth: TencentOAuth!

    var locationManager:CLLocationManager!
    
    let vc = HomeViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /// 友盟统计
        UMAnalyticsConfig.sharedInstance().appKey = "59ba3e84c62dca5d7c00004e"
        UMAnalyticsConfig.sharedInstance().channelId = "iOSDefault";
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
        
        TencentShared.registeApp("101417288", appKey: "2cf4d8fd277a91f2ecd788611fa39755")
        WeChatShared.registeApp("wxb119161278966b95", appSecret: "2d54a9c60554787ea2a2d9c4f67eebb1")
        
        ///bugly
        Bugly.start(withAppId: "38f8b7d158")
        
        /// 取得用户授权 显示通知（上方提示条/声音/badgeNumber）
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert, .carPlay]) { (success, error) in
                print("授权" + (success ? "成功" : "失败"))
            }
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        /// loading 的样式
        SVProgressHUD.setDefaultStyle(.light)
        
        /// 友盟推送
        UMessage.start(withAppkey: "59ba3e84c62dca5d7c00004e", launchOptions: launchOptions, httpsEnable: true)
        UMessage.registerForRemoteNotifications()
        UMessage.setLogEnabled(true)
        
        window = UIWindow()
//        let vc = MainViewController()
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        LocalDataUtils.initUserInfo()
        
        vc.loadDialogToWindow()
        
        locationManager = CLLocationManager()
        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //最佳定位
        //更新距离
        locationManager.distanceFilter = 5
        //发出授权请求
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()){
            //允许使用定位服务的话，开始定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
        
        return true
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("notification:\(error)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UMessage.registerDeviceToken(deviceToken)
        let device = NSData(data: deviceToken)
        let deviceId = device.description.replacingOccurrences(of:"<", with:"").replacingOccurrences(of:">", with:"").replacingOccurrences(of:" ", with:"")
        print("deviceToken:\(deviceId)")
    }
    
    func setupPush() -> () {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: UNAuthorizationOptions(rawValue : UNAuthorizationOptions.alert.rawValue | UNAuthorizationOptions.badge.rawValue | UNAuthorizationOptions.sound.rawValue)){ (granted: Bool, error:Error?) in
                if granted {
                    print("success")
                }
            }
            UIApplication.shared.registerForRemoteNotifications()
        }else if #available(iOS 8.0, *) {
            // 请求授权
            let type = UIUserNotificationType.alert.rawValue | UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue
            let set = UIUserNotificationSettings(types: UIUserNotificationType(rawValue: type), categories: nil)
            UIApplication.shared.registerUserNotificationSettings(set)
            // 需要通过设备UDID, 和app bundle id, 发送请求, 获取deviceToken
            UIApplication.shared.registerForRemoteNotifications()
        }else {
            let type = UIRemoteNotificationType(rawValue: UIRemoteNotificationType.alert.rawValue | UIRemoteNotificationType.sound.rawValue | UIRemoteNotificationType.badge.rawValue)
            UIApplication.shared.registerForRemoteNotifications(matching: type)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        let currLocation : CLLocation = locations.last!  // 持续更新
        // 获取经纬度
        Constants.Tools.LNG = currLocation.coordinate.longitude.description
        Constants.Tools.LAT = currLocation.coordinate.latitude.description
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:\(error)")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        var urlKey: String = "";
        if #available(iOS 9.0, *) {
            urlKey = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String
        } else {
            // Fallback on earlier versions
        }
        
        if urlKey == "com.tencent.mqq" {
            // QQ 的回调
            return  TencentShared.handle(url)
        } else if urlKey == "com.tencent.xin" {
            // 微信 的回调
            return WeChatShared.handle(url)
        }
        
        //跳转支付宝钱包进行支付，处理支付结果
        AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (resultDict) in
            print("result:\(String(describing: resultDict))")
            if let Alipayjson = resultDict as NSDictionary?{
                let resultStatus = Alipayjson.value(forKey: "resultStatus") as! String
                if resultStatus == "9000"{
                    print("OK")
                    ToastUtils.showSuccessToast(msg: "支付成功")
                }else if resultStatus == "8000" {
                    print("正在处理中")
                }else if resultStatus == "4000" {
                    print("订单支付失败");
                    ToastUtils.showErrorToast(msg: "支付失败")
                }else if resultStatus == "6001" {
                    print("用户中途取消")
                    ToastUtils.showErrorToast(msg: "支付取消")
                }else if resultStatus == "6002" {
                    print("网络连接出错")
                    ToastUtils.showErrorToast(msg: "网络出错")
                }
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //iOS10以下使用这个方法接收通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        UMessage.setAutoAlert(false)
        UMessage.didReceiveRemoteNotification(userInfo)
        
        if UIApplication.shared.applicationState == UIApplicationState.active {
            let json = JSON(userInfo["aps"] ?? "")
            let alertView = UIAlertController(title: json["alert"]["title"].stringValue, message: json["alert"]["body"].stringValue, preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
            UIViewController.currentViewController()?.present(alertView, animated: true, completion: nil)
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void){
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.superclass()!))! {
            //应用处于前台时的远程推送接受
            //关闭友盟自带的弹出框
            UMessage.setAutoAlert(false)
            //必须加这句代码
            UMessage.didReceiveRemoteNotification(userInfo)
            
            
            
        }else{
            //应用处于前台时的本地推送接受
        }
        //当应用处于前台时提示设置，需要哪个可以设置哪一个
        completionHandler([.sound,.alert,.badge])
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void){
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.superclass()!))! {
            //应用处于前台时的远程推送接受
            //必须加这句代码
            UMessage.setAutoAlert(false)
            UMessage.didReceiveRemoteNotification(userInfo)
        }else{
            //应用处于前台时的本地推送接受
        }
    }
    
    var allowRotation = 0
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if allowRotation == 1 {
            if !UIApplication.shared.statusBarOrientation.isPortrait {
                return UIInterfaceOrientationMask.portrait
            }else{
                return UIInterfaceOrientationMask.landscapeRight
            }
        }else{
            return UIInterfaceOrientationMask.portrait
        }
    }
    
}

extension UIViewController {
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}






