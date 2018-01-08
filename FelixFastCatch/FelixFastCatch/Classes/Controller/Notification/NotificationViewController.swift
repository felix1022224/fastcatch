//
//  NotificationViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

/// 消息列表页面
class NotificationViewController: UIViewController {

    /// 消息列表
    var notificationListTabView:UITableView = UITableView()
    
    var notificationDataSource:[JSON] = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    
    
}
