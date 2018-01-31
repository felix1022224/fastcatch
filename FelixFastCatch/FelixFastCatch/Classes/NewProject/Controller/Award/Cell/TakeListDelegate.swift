//
//  TakeListDelegate.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/30.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

class TakeListDelegate:NSObject,  UITableViewDelegate, UITableViewDataSource {
    
    var dataSources = [JSON]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TakeTableViewCell
        
        let itemData = dataSources[indexPath.row]
        
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy.MM.dd hh:ss"
        
        cell.timeLabel.text = "申请时间: " + dfmatter.string(from: Date(timeIntervalSince1970: TimeInterval(itemData["createTime"].int64Value/1000)))
        
        if itemData["awards"][0]["type"].intValue == 0 {
            cell.mailedInfoLabel.text = "发货详情:\(itemData["sid"].stringValue)"
            
            if itemData["status"].intValue == 1 {
                cell.statusLabel.text = "已发货"
                cell.statusLabel.textColor = UIColor.green
            }else{
                cell.statusLabel.textColor = UIColor.black
                cell.statusLabel.text = "配货中"
            }
        }else{
            cell.timeLabel.text = "提取时间: " + dfmatter.string(from: Date(timeIntervalSince1970: TimeInterval(itemData["updateTime"].int64Value/1000)))
            
            cell.mailedInfoLabel.text = "发货详情:" + itemData["sid"].stringValue
            
            if itemData["status"].intValue == 1 {
                cell.statusLabel.text = "已发货"
                cell.statusLabel.textColor = UIColor.green
            }else{
                cell.statusLabel.text = "配货中"
                cell.statusLabel.textColor = UIColor.black
            }
        }
        
        cell.timeLabel.sizeToFit()
        cell.mailedInfoLabel.sizeToFit()
        
        cell.imgDataSource = itemData["awards"].arrayValue
        
        cell.productNumber.text = "共\(cell.imgDataSource.count)件商品"
        
        cell.collectionView.reloadData()
        
        return cell
    }
    
    
    

}
