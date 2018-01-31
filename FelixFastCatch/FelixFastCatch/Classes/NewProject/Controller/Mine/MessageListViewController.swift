//
//  MessageListViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/31.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// 消息记录
class MessageListViewController: BaseActionBarViewController,UITableViewDelegate, UITableViewDataSource {

    /// 消息列表
    var messageTabList = UITableView()
    
    /// 消息列表的数据
    var messageDataSource = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actionTitleLabel.text = "我的消息"
        
        messageTabList.rowHeight = 90
        messageTabList.frame = CGRect(x: 0, y: headView.bounds.height + 5, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - headView.bounds.height - 5)
        messageTabList.delegate = self
        messageTabList.dataSource = self
        messageTabList.backgroundColor = UIColor.white
        messageTabList.separatorInset = UIEdgeInsets.init(top: 0, left: UIScreen.main.bounds.width * 0.05, bottom: 0, right: UIScreen.main.bounds.width * 0.05)
        messageTabList.tableFooterView = UIView.init(frame: CGRect.zero)
        messageTabList.register(MessageTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(messageTabList)
        
        getNotificationList()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTableViewCell
        
        cell.title.text = messageDataSource[indexPath.row]["title"].stringValue
        cell.info.text = messageDataSource[indexPath.row]["body"].stringValue
        
        cell.time.text = messageDataSource[indexPath.row]["startTime"].stringValue
        
        cell.title.sizeToFit()
        cell.info.sizeToFit()
        cell.time.sizeToFit()
        
        return cell
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
                        self.messageDataSource = self.messageDataSource + resultArray
                    }
                    self.messageTabList.reloadData()
                }
        }
    }

}
