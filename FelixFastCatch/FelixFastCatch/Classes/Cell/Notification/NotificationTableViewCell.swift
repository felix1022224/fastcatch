//
//  NotificationTableViewCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/19.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    /// 标题
    var titleLabel : MainCustomerLabel = MainCustomerLabel()
    
    /// 时间
    var timeLabel: MainCustomerLabel = MainCustomerLabel()
    
    /// 详情
    var infoLabel : MainCustomerLabel = MainCustomerLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = UITableViewCellSelectionStyle.none
        
        /// 背景图
        let backgroundImage = UIImageView(image: UIImage(named: "消息列表item背景"))
        backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.98, height: UIScreen.main.bounds.width * 0.98 * 0.35)
        addSubview(backgroundImage)
        
        let labelWidth = (backgroundImage.bounds.width - 30)
        
        
        /// 标题
        titleLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 18)
        titleLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        titleLabel.outTextColor = UIColor.white
        titleLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        titleLabel.text = "标题"
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 24, y: 20, width: labelWidth * 0.55, height: titleLabel.bounds.height)
        addSubview(titleLabel)
        
        /// 时间
        timeLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 16)
        timeLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        timeLabel.outTextColor = UIColor.white
        timeLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        timeLabel.text = "2008-8-17 3:45"
        timeLabel.textAlignment = .right
        timeLabel.sizeToFit()
        timeLabel.frame = CGRect(x: labelWidth - labelWidth * 0.45 + 10, y: 20, width: labelWidth * 0.45, height: timeLabel.bounds.height)
        timeLabel.center.y = titleLabel.center.y
        addSubview(timeLabel)
        
        ///详情
        infoLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        infoLabel.outLineWidth = 0
        infoLabel.outTextColor = UIColor.gray
        infoLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        infoLabel.text = "详情"
        infoLabel.textAlignment = .left
        infoLabel.numberOfLines = 3
        infoLabel.sizeToFit()
        addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel).offset(timeLabel.bounds.height + 5)
            make.width.equalTo(labelWidth - 20)
            make.centerX.equalTo(backgroundImage)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
