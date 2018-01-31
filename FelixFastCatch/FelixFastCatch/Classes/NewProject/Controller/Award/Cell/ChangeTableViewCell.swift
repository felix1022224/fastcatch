//
//  ChangeTableViewCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/30.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class ChangeTableViewCell: UITableViewCell {

    /// 竞品图
    var sceneryImage = UIImageView()
    
    /// 竞品名称
    var sceneryName = UILabel()
    
    /// 兑换积分
    var sceneryCount = UILabel()
    
    /// 提取时间
    var sceneryTime = UILabel()
    
    let itemHeight = UIScreen.main.bounds.width * 0.9 * 0.35
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        sceneryImage.frame.size = CGSize.init(width: itemHeight * 0.8, height: itemHeight * 0.8)
        sceneryImage.layer.cornerRadius = 10
        sceneryImage.layer.masksToBounds = true
        
        sceneryImage.layer.borderColor = UIColor.gray.cgColor
        sceneryImage.layer.borderWidth = 0.5
        sceneryImage.frame.origin = CGPoint.init(x: 15, y: itemHeight * 0.1)
        addSubview(sceneryImage)
        
        sceneryName.font = UIFont.systemFont(ofSize: 16)
        sceneryName.text = "景品名称景品名称景品名称景品名称景品名称景品名称景品名称景品名称景品名称景品名称景品名称景品名称景品名称"
        sceneryName.numberOfLines = 2
        sceneryName.sizeToFit()
        sceneryName.frame = CGRect.init(x: 15 + sceneryImage.bounds.width + 15, y: itemHeight * 0.1 + 5, width: UIScreen.main.bounds.width * 0.5, height: sceneryName.bounds.height * 2)
        addSubview(sceneryName)
        
        sceneryTime.font = UIFont.systemFont(ofSize: 12)
        sceneryTime.text = "2017.11.11 12:30"
        sceneryTime.textColor = UIColor.gray
        sceneryTime.sizeToFit()
        sceneryTime.frame.origin = CGPoint.init(x: 30 + sceneryImage.bounds.width, y: itemHeight * 0.9 - sceneryTime.bounds.height - 10)
        addSubview(sceneryTime)
        
        sceneryCount.font = UIFont.systemFont(ofSize: 12)
        sceneryCount.text = "可兑换积分:100 积分"
        sceneryCount.textColor = UIColor.red
        sceneryCount.sizeToFit()
        sceneryCount.frame.origin = CGPoint.init(x: sceneryTime.frame.origin.x, y: itemHeight * 0.9 - sceneryTime.bounds.height - 10 - 5 - sceneryCount.bounds.height)
        addSubview(sceneryCount)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
