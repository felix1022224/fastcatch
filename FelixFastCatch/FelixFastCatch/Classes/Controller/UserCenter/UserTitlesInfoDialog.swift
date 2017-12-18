//
//  UserTitlesInfoDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserTitlesInfoDialog: BaseDialog {

    /// 成就详情的list
    lazy var titlesInfoTabView = UITableView()
    
    lazy var dataSources = [JSON]()
    
    override func createView() {
        createBackgroundImage(imageName: "成就详情背景")
        
        backgroundImage.frame.size = CGSize(width: 310, height: 400)
        backgroundImage.center = self.center
        
        createCloseBtn()
        
        let itemImage = UIImageView(image: UIImage(named: "成就详情底"))
        itemImage.sizeToFit()
        
        titlesInfoTabView.frame.size = CGSize(width: itemImage.bounds.width, height: backgroundImage.bounds.height - 80 - 10)
        titlesInfoTabView.backgroundColor = UIColor.clear
        titlesInfoTabView.separatorColor = UIColor.clear
        titlesInfoTabView.delegate = self
        titlesInfoTabView.dataSource = self
        titlesInfoTabView.register(TitlesInfoCell.self, forCellReuseIdentifier: "cellId")
        addSubview(titlesInfoTabView)
        
        titlesInfoTabView.frame = CGRect(x: (UIScreen.main.bounds.width/2 - titlesInfoTabView.bounds.width/2), y: (UIScreen.main.bounds.height - titlesInfoTabView.bounds.height)/2 + 10, width: titlesInfoTabView.bounds.width, height: titlesInfoTabView.bounds.height)
        
        addDialogToWindow()
    }
    
    func show2(list:[JSON]) -> () {
        if list.count <= 0 {
            return
        }
        show()
        dataSources.removeAll()
        dataSources = list
        titlesInfoTabView.reloadData()
    }
}

extension UserTitlesInfoDialog: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? TitlesInfoCell
        
        let item = dataSources[indexPath.row]
        
        cell?.title.text = item["name"].stringValue
        cell?.info.text = item["description"].stringValue
        cell?.itemImage.kf.setImage(with: URL(string: item["achievementImg"].stringValue))
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemImage = UIImageView(image: UIImage(named: "成就详情底"))
        return itemImage.bounds.height + 10
    }
    
}




