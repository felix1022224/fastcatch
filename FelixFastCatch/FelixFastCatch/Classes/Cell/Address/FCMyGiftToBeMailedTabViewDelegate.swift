//
//  FCMyGiftToBeMailedTabViewDelegate.swift
//  FastCatch
//
//  Created by 卢凡 on 2017/7/21.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class FCMyGiftToBeMailedTabViewDelegate: NSObject {

    var dataSource = [JSON]()
    
    /// 选择列表
    var selectList = [Int:Bool]()
    
}

extension FCMyGiftToBeMailedTabViewDelegate : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? FCMyGiftCell
        
        cell?.productImage.kf.setImage(with: URL(string: dataSource[indexPath.row]["img"].stringValue))
        cell?.productTitleLabel.text = dataSource[indexPath.row]["title"].stringValue
        
        cell?.selectBtn.tag = indexPath.row
        
        if selectList[indexPath.row] ?? true {
           cell?.selectBtn.isSelected = true
        }else {
           cell?.selectBtn.isSelected = false
        }
        
        cell?.selectBtn.addTarget(self, action: #selector(selectClick(sender:)), for: .touchUpInside)
        
        return cell!
    }
    
    @objc func selectClick(sender:UIButton){
        if sender.isSelected {
            sender.isSelected = false
            selectList[sender.tag] = false
        }else {
            sender.isSelected = true
            selectList[sender.tag] = true
        }
    }
}
