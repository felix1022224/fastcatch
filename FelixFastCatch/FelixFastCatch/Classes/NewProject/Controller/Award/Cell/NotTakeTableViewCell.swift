//
//  NotTakeTableViewCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/30.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class NotTakeTableViewCell: UITableViewCell {

    /// 竞品图
    var sceneryImage = UIImageView()
    
    /// 竞品名称
    var sceneryName = UILabel()
    
    /// 竞品可兑换积分
    var sceneryCount = UILabel()
    
    /// 竞品剩余提取天数
    var sceneryTime = UILabel()
    
    /// 选择按钮
    var selectedButton = UIButton()
    
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
        sceneryName.frame = CGRect.init(x: 15 + sceneryImage.bounds.width + 15, y: itemHeight * 0.1 + 5, width: UIScreen.main.bounds.width * 0.45, height: sceneryName.bounds.height * 2)
        addSubview(sceneryName)
        
        sceneryTime.font = UIFont.systemFont(ofSize: 12)
        sceneryTime.text = "申请提取剩余时间: 28天"
        sceneryTime.textColor = UIColor.gray
        sceneryTime.sizeToFit()
        sceneryTime.frame.origin = CGPoint.init(x: 30 + sceneryImage.bounds.width, y: itemHeight * 0.9 - sceneryTime.bounds.height - 10)
        addSubview(sceneryTime)
        
        sceneryCount.font = UIFont.systemFont(ofSize: 12)
        sceneryCount.text = "可兑换积分:100 积分"
        sceneryCount.textColor = UIColor.gray
        sceneryCount.sizeToFit()
        sceneryCount.frame.origin = CGPoint.init(x: sceneryTime.frame.origin.x, y: itemHeight * 0.9 - sceneryTime.bounds.height - 10 - 5 - sceneryCount.bounds.height)
        addSubview(sceneryCount)
    
        selectedButton.setBackgroundImage(UIImage.init(named: "奖品未选择"), for: UIControlState.normal)
        selectedButton.setBackgroundImage(UIImage.init(named: "奖品已选择"), for: UIControlState.selected)
        selectedButton.sizeToFit()
        selectedButton.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width * 0.9 - 10 - selectedButton.bounds.width, y: itemHeight/2 - selectedButton.bounds.height/2)
        addSubview(selectedButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
