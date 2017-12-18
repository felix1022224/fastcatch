//
//  NotificationListWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/14.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class NotificationListWidget: NSObject {

}
/// 消息列表 tabview 控件
extension NotificationViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    /// 创建消息列表
    func createNotificationList() {
        
    }
    
}
