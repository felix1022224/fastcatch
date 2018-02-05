//
//  MainTabsViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/16.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/// 首页的tabs
class MainTabsViewController: UITabBarController, UITabBarControllerDelegate {

    var tabItemControllers = [UIViewController]()
    
    let homeViewController = HomeTabViewController()
    
    static var tabHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 设置背景色
        self.view.backgroundColor = UIColor.white
        
        self.tabBar.backgroundColor = UIColor.white
        
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor.white
        
        self.delegate = self
        
        setUpOneChildViewController(viewController: PayWebViewController(), image: UIImage(named: "充值_tab_icon")!, selectedImage: UIImage(named: "充值选中_tab_icon")!, title: "")
        setUpOneChildViewController(viewController: AwardViewController(), image: UIImage(named: "奖品_tab_icon")!, selectedImage: UIImage(named: "奖品选中_tab_icon")!, title: "")
        setUpOneChildViewController(viewController: homeViewController, image: UIImage(named: "首页_tab_icon")!, selectedImage: UIImage(named: "首页选中_tab_icon")!, title: "")
        setUpOneChildViewController(viewController: PointsMallViewController(), image: UIImage(named: "商城_tab_icon")!, selectedImage: UIImage(named: "商城选中_tab_icon")!, title: "")
        setUpOneChildViewController(viewController: MineViewController(), image: UIImage(named: "我的_tab_icon")!, selectedImage: UIImage(named: "我的选中_tab_icon")!, title: "")
        
        self.selectedIndex = 2
        
        getOpenAdv()
    }
    
    override func viewWillLayoutSubviews() {
        var frame = self.tabBar.frame
        frame.size.height = frame.size.height + 5
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        self.tabBar.frame = frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /// 隐藏自带的navigationBar
        self.navigationController?.isNavigationBarHidden = true
        
        self.selectedViewController?.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MainTabsViewController.tabHeight = self.tabBar.frame.height
    }
    
    func setUpOneChildViewController(viewController: UIViewController, image: UIImage, selectedImage: UIImage, title: NSString) {

        // 让图片显示图片原始颜色  “UIImage” 后+ “.imageWithRenderingMode(.AlwaysOriginal)”
        viewController.tabBarItem = UITabBarItem.init(title: nil, image: image.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(.alwaysOriginal))
        
        viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        tabItemControllers.append(viewController)
        
        self.addChildViewController(viewController)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabItemControllers[2] {
            homeViewController.isHide = false
            return true
        }else{
            if Constants.User.USER_ID == "" {
                LoginViewController.showLoginVC()
                return false
            }
        }
        homeViewController.isHide = true
        return true
    }

}

// MARK: - 获取开屏页广告
extension MainTabsViewController {
    
    func getOpenAdv() -> () {
        Alamofire.request(Constants.Network.Machine.GET_OPEN_ADV).responseJSON { (dataResponse) in
            if NetWorkUtils.checkReponse(response: dataResponse) {
                let json = JSON(data: dataResponse.data!)
                if json["data"].arrayValue.count > 0 {
                    SplashView.updateSplashData(imgUrl: json["data"].arrayValue[0]["advertiseBigImg"].stringValue, actUrl: json["data"].arrayValue[0]["scheme"].stringValue, shareTitle: json["data"].arrayValue[0]["shareTitle"].stringValue, shareInfo: json["data"].arrayValue[0]["shareSubtitle"].stringValue, shareImage: json["data"].arrayValue[0]["shareImg"].stringValue, urlType: json["data"].arrayValue[0]["redirectType"].intValue, title:json["data"].arrayValue[0]["name"].stringValue )
                }else{
                    UserDefaults.standard.removeObject(forKey: SplashView.IMG_URL)
                    UserDefaults.standard.removeObject(forKey: SplashView.ACT_URL)
                }
            }
        }
    }
    
}
