//
//  AchievementHeaderCollectionReusableView.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/2/1.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AchievementHeaderCollectionReusableView: UICollectionReusableView {
    
    var dataSources = [JSON]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    
    func createGroupView() {
        for i in 0..<dataSources.count {
            addSubview(getItemAchievementView(index: i, data: dataSources[i]))
        }
        
        let titleGroupView = UIView()
        titleGroupView.frame = CGRect(x: 0, y: 100 * dataSources.count, width: Int(self.bounds.width), height: 40)
        addSubview(titleGroupView)
        
        let productInfoTitle = UILabel()
        productInfoTitle.text = "其他成就"
        productInfoTitle.font = UIFont.systemFont(ofSize: 14)
        productInfoTitle.sizeToFit()
        productInfoTitle.frame.origin = CGPoint(x: titleGroupView.bounds.width/2 - productInfoTitle.bounds.width/2, y: titleGroupView.bounds.height/2 - productInfoTitle.bounds.height/2)
        titleGroupView.addSubview(productInfoTitle)
        
        let leftLine = UIView()
        leftLine.backgroundColor = UIColor.init(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1.0)
        leftLine.frame = CGRect(x: 5, y: titleGroupView.bounds.height/2 - 0.5, width: titleGroupView.bounds.width / 3, height: 1)
        titleGroupView.addSubview(leftLine)
        
        let rightLine = UIView()
        rightLine.backgroundColor = UIColor.init(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1.0)
        rightLine.frame = CGRect(x: titleGroupView.bounds.width - leftLine.bounds.width - 5, y: titleGroupView.bounds.height/2 - 0.5, width: titleGroupView.bounds.width / 3, height: 1)
        titleGroupView.addSubview(rightLine)
    }
    
    func getItemAchievementView(index:Int, data:JSON) -> UIView {
        let itemView = UIView()
        itemView.frame.size = CGSize.init(width: self.bounds.width * 0.9, height: 100)
        itemView.frame.origin = CGPoint.init(x: self.bounds.width * 0.05, y: CGFloat(100 * index))
        
        let achievementimage = UIImageView.init()
        achievementimage.frame.size = CGSize.init(width: 70, height: 70)
        achievementimage.frame.origin = CGPoint.init(x: 15, y: 15)
        achievementimage.kf.setImage(with: URL.init(string: data["achievementImg"].stringValue))
        itemView.addSubview(achievementimage)
        
        let name = UILabel.init()
        name.font = UIFont.systemFont(ofSize: 14)
        name.text = data["name"].stringValue
        name.sizeToFit()
        name.frame.origin = CGPoint.init(x: 100, y: 15)
        itemView.addSubview(name)
        
        let info = UILabel.init()
        info.font = UIFont.systemFont(ofSize: 12)
        info.textColor = UIColor.gray
        info.text = data["description"].stringValue
        info.numberOfLines = 2
        info.sizeToFit()
        itemView.addSubview(info)
        
        info.snp.makeConstraints { (make) in
            make.left.equalTo(name)
            make.bottom.equalTo(achievementimage)
        }
        
        let arrowIcon = UIImageView.init(image: UIImage.init(named: "成就进入"))
        arrowIcon.sizeToFit()
        itemView.addSubview(arrowIcon)
        arrowIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(itemView)
            make.right.equalTo(itemView).offset(-15)
        }
        
        if index != dataSources.count - 1 {
            let lineView = UIView.init()
            lineView.backgroundColor = UIColor.init(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1.0)
            lineView.frame.size = CGSize.init(width:itemView.bounds.width * 0.9, height: 0.5)
            lineView.frame.origin = CGPoint.init(x: itemView.bounds.width * 0.05, y: 99.5)
            itemView.addSubview(lineView)
        }
        
        itemView.tag = index
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showAchievementDialog(tap:)))
        itemView.isUserInteractionEnabled = true
        itemView.addGestureRecognizer(tap)
        
        return itemView
    }
    
    @objc func showAchievementDialog(tap:UITapGestureRecognizer){
        let infoDialog = AchievementDialog.init(frame: UIScreen.main.bounds)
        infoDialog.dataSource = dataSources[(tap.view?.tag)!]["achievements"].arrayValue
        infoDialog.createView()
        infoDialog.show()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
