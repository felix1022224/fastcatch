//
//  FCMyGiftHasBeenMailedTabViewDelegate.swift
//  FastCatch
//
//  Created by 卢凡 on 2017/7/21.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

class FCMyGiftHasBeenMailedTabViewDelegate: NSObject {

    /// 数据
    var dataSource = [JSON]()
    
}

extension FCMyGiftHasBeenMailedTabViewDelegate:UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? FCMyGiftHasBeenMailedCell
        
        cell?.setupItemUI(itemData: dataSource[indexPath.row])
        
        let itemData = dataSource[indexPath.row]
        
        cell?.hasBeenMailedView.timeLabel.text = "申请时间: 2017.7.8 12:30"
        
        cell?.hasBeenMailedView.statusLabel.text = "邮寄状态: 已寄出"
        
        cell?.hasBeenMailedView.mailedTimeLabel.text = "邮寄时间: 2017.8.9 10:00"
        
        cell?.hasBeenMailedView.mailedCodeLabel.text = "邮寄单号:" + itemData["oid"].stringValue
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let hasBeenMailedView = HasBeenMailedView()
        hasBeenMailedView.setupUIWidget(item: dataSource[indexPath.row])
        return hasBeenMailedView.getHeight()
    }
    
}
