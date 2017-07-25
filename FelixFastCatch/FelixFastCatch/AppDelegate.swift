//
//  AppDelegate.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/24.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?

    // qq 登录
    var tencentAuth: TencentOAuth!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 延迟一秒钟
        sleep(1)
        
        TencentShared.registeApp("101417288", appKey: "2cf4d8fd277a91f2ecd788611fa39755")
        WeChatShared.registeApp("wxb119161278966b95", appSecret: "2d54a9c60554787ea2a2d9c4f67eebb1")
        
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
        
        window = UIWindow()
        let vc = MainViewController()
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlKey: String = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String
        
        if urlKey == "com.tencent.mqq" {
            // QQ 的回调
            return  TencentShared.handle(url)
        } else if urlKey == "com.tencent.xin" {
            // 微信 的回调
            return WeChatShared.handle(url)
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


}





