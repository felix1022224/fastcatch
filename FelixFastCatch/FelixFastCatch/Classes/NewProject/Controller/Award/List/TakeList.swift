//
//  TakeList.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/30.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// 已提取的list
extension AwardViewController{
    
    func createTakeList() {
        self.takeListDelegate = TakeListDelegate()
        
        takeList.rowHeight = UIScreen.main.bounds.width * 0.9 * 0.5
        takeList.frame = notTakeList.bounds
        takeList.separatorInset = UIEdgeInsets.init(top: 0, left: centerGroupView.bounds.width * 0.05, bottom: 0, right: centerGroupView.bounds.width * 0.05)
        takeList.delegate = takeListDelegate
        takeList.dataSource = takeListDelegate
        takeList.register(TakeTableViewCell.self, forCellReuseIdentifier: "cellId")
        takeList.frame.origin = CGPoint.init(x: 0, y: 43)
        takeList.tableFooterView = UIView.init(frame: CGRect.zero)
        takeList.frame.size = CGSize.init(width: centerGroupView.bounds.width, height: centerGroupView.bounds.height - 43)
        centerGroupView.addSubview(takeList)
        
        getTakeList()
    }
    
    /// 获取已邮寄列表
    func getTakeList() {
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "10000"
        params["page"] = "0"
        
        Alamofire.request(Constants.Network.Gift.GET_MAILED_GIFT_LIST, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(response.result.value!)
                self.takeListDelegate.dataSources.removeAll()
                self.takeListDelegate.dataSources += json["data"]["content"].arrayValue
                self.takeList.reloadData()
            }
        }
    }
    
}
