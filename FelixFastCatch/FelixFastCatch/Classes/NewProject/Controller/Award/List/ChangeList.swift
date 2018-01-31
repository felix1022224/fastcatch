//
//  ChangeList.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/30.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// 已兑换列表
extension AwardViewController{
    
    func createChangeList() {
        self.changeListDelegate = ChangeListDelegate()
        
        changeList.rowHeight = UIScreen.main.bounds.width * 0.9 * 0.35
        changeList.frame = notTakeList.bounds
        changeList.separatorInset = UIEdgeInsets.init(top: 0, left: centerGroupView.bounds.width * 0.05, bottom: 0, right: centerGroupView.bounds.width * 0.05)
        changeList.delegate = changeListDelegate
        changeList.dataSource = changeListDelegate
        changeList.register(ChangeTableViewCell.self, forCellReuseIdentifier: "cellId")
        changeList.frame.origin = CGPoint.init(x: 0, y: 43)
        changeList.tableFooterView = UIView.init(frame: CGRect.zero)
        changeList.frame.size = CGSize.init(width: centerGroupView.bounds.width, height: centerGroupView.bounds.height - 43)
        centerGroupView.addSubview(changeList)
        
        getChangeListData()
    }
    
    func getChangeListData() {
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "10000"
        params["page"] = "0"
        params["type"] = "2"
        
        Alamofire.request(Constants.Network.Gift.GET_CONVERTED_LIST, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(response.result.value!)
                self.changeListDelegate.dataSources.removeAll()
                
                self.changeListDelegate.dataSources += json["data"]["content"].array!
                self.changeList.reloadData()
            }
        }
    }
    
}
