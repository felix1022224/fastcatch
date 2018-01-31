//
//  NotTakeList.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/30.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// 没有提取的list
extension AwardViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notTakeDataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NotTakeTableViewCell
        
        cell.sceneryImage.kf.setImage(with: URL.init(string: notTakeDataSources[indexPath.row]["img"].stringValue))
        cell.sceneryName.text = notTakeDataSources[indexPath.row]["title"].stringValue
        cell.sceneryTime.text = "申请提取剩余时间: \(notTakeDataSources[indexPath.row]["remainingTime"].stringValue)"
        cell.sceneryCount.text = "可兑换积分: " + notTakeDataSources[indexPath.row]["conversionIntegral"].stringValue + "积分"
        
        cell.sceneryTime.sizeToFit()
        cell.sceneryCount.sizeToFit()
        
        cell.selectedButton.isSelected = self.notTakeSelectedStatus[indexPath.row]!
        
        cell.selectedButton.tag = indexPath.row
        cell.selectedButton.addTarget(self, action: #selector(selectedClick(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    @objc func selectedClick(sender:UIButton){
        if sender.isSelected {
            sender.isSelected = false
            self.notTakeSelectedStatus[sender.tag] = false
        }else{
            sender.isSelected = true
            self.notTakeSelectedStatus[sender.tag] = true
        }
        var temp = 0
        for isSelected in notTakeSelectedStatus {
            if isSelected.value {
                temp += 1
            }
        }
        selectedNumber.text = "已选择\(temp)个"
        selectedNumber.sizeToFit()
    }
    
    func createNotTakeList() {
        notTakeList.rowHeight = centerGroupView.bounds.width * 0.35
        notTakeList.separatorInset = UIEdgeInsets.init(top: 0, left: centerGroupView.bounds.width * 0.05, bottom: 0, right: centerGroupView.bounds.width * 0.05)
        notTakeList.delegate = self
        notTakeList.dataSource = self
        notTakeList.register(NotTakeTableViewCell.self, forCellReuseIdentifier: "cellId")
        notTakeList.frame.size = CGSize.init(width: centerGroupView.bounds.width, height: centerGroupView.bounds.height - 43 - 50 + 5)
        notTakeList.frame.origin = CGPoint.init(x: 0, y: 43)
        notTakeList.tableFooterView = UIView.init(frame: CGRect.zero)
        centerGroupView.addSubview(notTakeList)
        
        getNotTakeListDataSource()
    }
    
    /// 获取未提取列表的数据
    func getNotTakeListDataSource() {
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "10000"
        params["page"] = "0"
        
        Alamofire.request(Constants.Network.Gift.GET_TOBE_MAILED_GIFT_LIST, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(response.result.value!)
                self.notTakeDataSources += json["data"]["content"].arrayValue
                self.notTakeList.reloadData()
                
                self.notTakeSelectedStatus.removeAll()
                for i in 0..<self.notTakeDataSources.count {
                    self.notTakeSelectedStatus[i] = false
                }
                
                self.freePostageNumber = json["data"]["freePostNum"].intValue
                self.postageCashNumber = json["data"]["postDiamonds"].intValue
                
                self.userAwardNumberLabel.text = Constants.User.USER_NICK_NAME + "，未提取奖品\(self.notTakeSelectedStatus.count)个"
                self.userAwardNumberLabel.sizeToFit()
            }
        }
    }
    
}
