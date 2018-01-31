//
//  ChangeListDelegate.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/30.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChangeListDelegate: NSObject , UITableViewDelegate, UITableViewDataSource{
    
    var dataSources = [JSON]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ChangeTableViewCell
        
        cell.sceneryImage.kf.setImage(with: URL.init(string: dataSources[indexPath.row]["awardImg"].stringValue))
        cell.sceneryName.text = dataSources[indexPath.row]["awardTitle"].stringValue
        cell.sceneryTime.text = dataSources[indexPath.row]["createTime"].stringValue
        cell.sceneryCount.text = "+\(dataSources[indexPath.row]["integral"].stringValue)积分"
        
        cell.sceneryTime.sizeToFit()
        cell.sceneryCount.sizeToFit()
        
        return cell
    }
    

    
    
}
