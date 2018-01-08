//
//  UserCenterViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/12.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

/// 用户中心
class UserCenterViewController: UIViewController {

    /******** UI ********/
    
    /// 背景图
    lazy var backgroundImage = UIImageView()
    
    /// 顶部集合的view
    lazy var topGroupView = UIView()
    
    // 返回按钮
    lazy var backBtn = UIButton(type: UIButtonType.custom)
    
    /// 用户的头像
    lazy var userFaceImage:UIImageView = UIImageView()
    
    /// 用户的昵称
    lazy var userNickNameLabel = MainCustomerLabel()
    
    /// 用户的性别
    lazy var userSexLabel = MainCustomerLabel()
    
    /// 用户的生日
    lazy var userBirthdayLabel = MainCustomerLabel()
    
    // 退出登录
    var logoutBtn:UIButton = UIButton(type: UIButtonType.custom)
    
    // 编辑资料
    var changeInfoBtn:UIButton = UIButton(type: UIButtonType.custom)
    
    /// 编辑用户资料
    var editUserInfoDialog:EditUserInfoDialog!
    
    /// 底部集合的view
    lazy var bottomGroupView = UIView()
    
    /// 称号的集合的背景
    lazy var titlesGroupView = UIImageView()
    
    /// 称号集合的list
    lazy var titlesList = UICollectionView()
    
    /// 称号列表
    var titlesDataSource = [JSON]()
    
    /// 用户成就详情
    var userTitlesInfoDialog:UserTitlesInfoDialog!
    
    /// vip标签
    var vipImage = UIImageView()
    
    /// vip展示元素集合
    var vipGroupView = UIView()
    
    /// vip剩余日期label
    var vipLabel = MainCustomerLabel()
    
    /// vip开通或续费的按钮
    var vipOpenedButton = UIButton(type: UIButtonType.custom)
    
    /******** UI ********/
    
    /// 用户消息
    var userNotificationIcon = UIButton(type: UIButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editUserInfoDialog = EditUserInfoDialog(frame: UIScreen.main.bounds)
        
        userTitlesInfoDialog = UserTitlesInfoDialog(frame: UIScreen.main.bounds)
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 关掉当前页面
    @objc func closeView() -> () {
        self.navigationController?.popViewController(animated: true)
    }

}
