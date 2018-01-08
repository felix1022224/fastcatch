//
//  NotificationListWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/14.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class NotificationListWidget: NSObject {

}
/// 消息列表 tabview 控件
extension NotificationViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NotificationTableViewCell
        
        cell?.titleLabel.text = notificationDataSource[indexPath.row]["title"].stringValue
        cell?.infoLabel.text = notificationDataSource[indexPath.row]["body"].stringValue
        
        cell?.timeLabel.text = notificationDataSource[indexPath.row]["startTime"].stringValue
        
        return cell!
    }
    
    /// 创建消息列表
    func createNotificationList() {
        ///设置每一行的行高
        notificationListTabView.rowHeight = UIScreen.main.bounds.width * 0.98 * 0.35 + 5
        
        let insetTop = UIScreen.main.bounds.width * 0.45 * 0.25 + 5 + UIApplication.shared.statusBarFrame.height
        
        notificationListTabView.frame = CGRect(x: UIScreen.main.bounds.width * 0.02, y: insetTop, width: UIScreen.main.bounds.width * 0.98, height: UIScreen.main.bounds.height - insetTop)
        notificationListTabView.delegate = self
        notificationListTabView.dataSource = self
        notificationListTabView.backgroundColor = UIColor.clear
        notificationListTabView.separatorColor = UIColor.clear
        notificationListTabView.register(NotificationTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(notificationListTabView)
        
        getNotificationList()
    }
    
    func getNotificationList() {
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "10000"
        params["page"] = "0"
        
        ToastUtils.showLoadingToast(msg: "请稍后……")
        
        Alamofire.request(Constants.Network.User.GET_USER_NOTIFICATION_LIST, method: HTTPMethod.post, parameters: params)
            .responseJSON { (dataResponse) in
                ToastUtils.hide()
                if NetWorkUtils.checkReponse(response: dataResponse) {
                    let resultJson = JSON(data: dataResponse.data!)
                    if let resultArray = resultJson["data"]["content"].array {
                        self.notificationDataSource = self.notificationDataSource + resultArray
                    }
                    self.notificationListTabView.reloadData()
                }
        }
    }
    
}
