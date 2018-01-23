//
//  MainTabsViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/16.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

/// 首页的tabs
class MainTabsViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /// 设置背景色
        self.view.backgroundColor = UIColor.white
        
        self.tabBar.backgroundColor = UIColor.white
        
        setUpOneChildViewController(viewController: PayViewController(), image: UIImage(named: "充值_tab_icon")!, selectedImage: UIImage(named: "充值选中_tab_icon")!, title: "")
        setUpOneChildViewController(viewController: MailingListViewController(), image: UIImage(named: "奖品_tab_icon")!, selectedImage: UIImage(named: "奖品选中_tab_icon")!, title: "")
        setUpOneChildViewController(viewController: HomeTabViewController(), image: UIImage(named: "首页_tab_icon")!, selectedImage: UIImage(named: "首页选中_tab_icon")!, title: "")
        setUpOneChildViewController(viewController: PointsMallViewController(), image: UIImage(named: "商城_tab_icon")!, selectedImage: UIImage(named: "商城选中_tab_icon")!, title: "")
        setUpOneChildViewController(viewController: UserCenterViewController(), image: UIImage(named: "我的_tab_icon")!, selectedImage: UIImage(named: "我的选中_tab_icon")!, title: "")
        
        self.selectedIndex = 2
        
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
    
    func setUpOneChildViewController(viewController: UIViewController, image: UIImage, selectedImage: UIImage, title: NSString) {
//        let navVC = UINavigationController.init(rootViewController: viewController)
//
        // 让图片显示图片原始颜色  “UIImage” 后+ “.imageWithRenderingMode(.AlwaysOriginal)”
        viewController.tabBarItem = UITabBarItem.init(title: nil, image: image.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(.alwaysOriginal))
        
        viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        self.addChildViewController(viewController)
    }

}
