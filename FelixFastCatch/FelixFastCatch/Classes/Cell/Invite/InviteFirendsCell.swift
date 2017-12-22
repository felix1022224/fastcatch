//
//  InviteFirendsCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/9/3.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class InviteFirendsCell: UITableViewCell {

    // 内容背景
    fileprivate var contentGroup:UIImageView!
    
    // 产品背景图
    fileprivate var userFaceBackgroundImage:UIImageView!
    
    // 产品图
    var userFaceImage:UIImageView!
    
    // 产品名称
    var userName:MainCustomerLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = UITableViewCellSelectionStyle.none
        
        setupUIWidget()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension InviteFirendsCell{
    
    // 装载布局
    func setupUIWidget() -> () {
        contentGroup = UIImageView()
        contentGroup.image = UIImage(named: "内容块")
        contentGroup.sizeToFit()
        addSubview(contentGroup)
        
        // 产品背景图
        userFaceBackgroundImage = UIImageView()
        userFaceBackgroundImage.image = UIImage(named: "好友头像")
        userFaceBackgroundImage.sizeToFit()
        addSubview(userFaceBackgroundImage)
        
        userFaceBackgroundImage.snp.makeConstraints { (make) in
            make.top.equalTo(contentGroup).offset(contentGroup.bounds.height / 2 - userFaceBackgroundImage.bounds.height / 2)
            make.left.equalTo(contentGroup).offset(contentGroup.bounds.height / 2 - userFaceBackgroundImage.bounds.height / 2)
        }
        
        // 产品图
        userFaceImage = UIImageView()
        userFaceImage.backgroundColor = UIColor.white
        userFaceImage.layer.cornerRadius = userFaceBackgroundImage.bounds.width * 0.85 / 2
        userFaceImage.layer.masksToBounds = true
        addSubview(userFaceImage)
        
        userFaceImage.snp.makeConstraints { (make) in
            make.width.equalTo(userFaceBackgroundImage.bounds.width * 0.85)
            make.height.equalTo(userFaceBackgroundImage.bounds.height * 0.85)
            make.center.equalTo(userFaceBackgroundImage)
        }
        
        // 产品名标题
        userName = MainCustomerLabel()
        userName.numberOfLines = 1
        userName.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        userName.outLineWidth = 1
        userName.outTextColor = UIColor.white
        userName.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        addSubview(userName)
        
        userName.snp.makeConstraints { (make) in
            make.left.equalTo(userFaceBackgroundImage).offset(userFaceBackgroundImage.bounds.width + 10)
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(contentGroup)
        }
        
    }
}
