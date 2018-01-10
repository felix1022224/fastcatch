
//
//  HasBeenConvertedTableViewCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/10.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class HasBeenConvertedTableViewCell: UITableViewCell {

    // 内容背景
    fileprivate var contentGroup:UIImageView!
    
    // 产品背景图
    fileprivate var productBackgroundImage:UIImageView!
    
    // 产品图
    var productImage:UIImageView!
    
    // 产品名称
    var productTitleLabel:MainCustomerLabel!
    
    /// 时间
    var timeLabel:MainCustomerLabel!
    
    /// 积分变动的label
    var pointsLabel:MainCustomerLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = UITableViewCellSelectionStyle.none
        
        contentGroup = UIImageView()
        contentGroup.frame.size = CGSize(width: (UIScreen.main.bounds.width * 0.9), height: ((UIScreen.main.bounds.width * 0.9))*0.35)
        contentGroup.image = UIImage(named: "已兑换背景")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        addSubview(contentGroup)
        
        // 产品背景图
        productBackgroundImage = UIImageView()
        productBackgroundImage.image = UIImage(named: "邮寄产品框")
        productBackgroundImage.sizeToFit()
        addSubview(productBackgroundImage)
        
        productBackgroundImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentGroup).offset(-2.5)
            make.left.equalTo(contentGroup).offset(productBackgroundImage.bounds.width / 2.5)
        }
        
        // 产品图
        productImage = UIImageView()
        productImage.backgroundColor = UIColor.white
        productImage.layer.cornerRadius = 3
        productImage.layer.masksToBounds = true
        addSubview(productImage)
        
        productImage.snp.makeConstraints { (make) in
            make.width.equalTo(productBackgroundImage.bounds.width * 0.9)
            make.height.equalTo(productBackgroundImage.bounds.height * 0.9)
            make.center.equalTo(productBackgroundImage)
        }
        
        ///积分
        pointsLabel = MainCustomerLabel()
        pointsLabel.numberOfLines = 1
        pointsLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 16)
        pointsLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        pointsLabel.outTextColor = UIColor.white
        pointsLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        addSubview(pointsLabel)
        
        pointsLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentGroup).offset(-15)
            make.centerY.equalTo(contentGroup)
        }
        
        // 产品名标题
        productTitleLabel = MainCustomerLabel()
        productTitleLabel.numberOfLines = 1
        productTitleLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 13)
        productTitleLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        productTitleLabel.outTextColor = UIColor.white
        productTitleLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        addSubview(productTitleLabel)
        
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productBackgroundImage).offset(productBackgroundImage.bounds.width + 10)
            make.right.equalTo(pointsLabel).offset(-(pointsLabel.bounds.width + 10))
            make.top.equalTo(productImage).offset(5)
        }
        
        // 时间
        timeLabel = MainCustomerLabel()
        timeLabel.text = ""
        timeLabel.numberOfLines = 1
        timeLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 11)
        timeLabel.outLineWidth = 2
        timeLabel.outTextColor = UIColor.white
        timeLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        timeLabel.sizeToFit()
        addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productTitleLabel)
            make.right.equalTo(productTitleLabel)
            make.bottom.equalTo(productImage).offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
