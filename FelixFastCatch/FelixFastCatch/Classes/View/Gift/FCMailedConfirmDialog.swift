//
//  FCMailedConfirmDialog.swift
//  FastCatch
//
//  Created by 卢凡 on 2017/7/22.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class FCMailedConfirmDialog: BaseDialog {

    // 购买人信息
    private var userInfo:MainCustomerLabel!
    
    // 手机号
    private var phoneNumber:MainCustomerLabel!
    
    // 地址
    private var address:MainCustomerLabel!
    
    override func createView() {
        createBackgroundImage(imageName: "信息确认背景")
        createCloseBtn()
   
        // 返回按钮
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "返回"), for: .normal)
        backBtn.sizeToFit()
        addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(backgroundImage).offset(30)
            make.left.equalTo(backgroundImage).offset(-backBtn.bounds.width/2)
        }
        
        backBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        // 购买人
        userInfo = MainCustomerLabel()
        userInfo.outLineWidth = 2
        userInfo.outTextColor = UIColor.white
        userInfo.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        userInfo.font = UIFont.systemFont(ofSize: CGFloat(10))
        userInfo.text = "收货人 : 小粗腿"
        userInfo.numberOfLines = 1
        userInfo.sizeToFit()
        addSubview(userInfo)
        
        userInfo.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage).offset(65)
            make.left.equalTo(backgroundImage).offset(20)
            make.right.equalTo(backgroundImage).offset(-20)
        }
        
        // 手机号
        phoneNumber = MainCustomerLabel()
        phoneNumber.outLineWidth = 2
        phoneNumber.outTextColor = UIColor.white
        phoneNumber.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        phoneNumber.font = UIFont.systemFont(ofSize: CGFloat(10))
        phoneNumber.text = "手机号 : 12345678901"
        phoneNumber.numberOfLines = 1
        phoneNumber.sizeToFit()
        addSubview(phoneNumber)
        
        phoneNumber.snp.makeConstraints { (make) in
            make.top.equalTo(userInfo).offset(userInfo.bounds.height + 10)
            make.left.equalTo(userInfo)
            make.right.equalTo(userInfo)
        }
        
        // 地址
        address = MainCustomerLabel()
        address.outLineWidth = 2
        address.outTextColor = UIColor.white
        address.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        address.font = UIFont.systemFont(ofSize: CGFloat(10))
        address.text = "地址 : 北京市海淀区神经病街道大二货小区10号楼1单元1776号室"
        address.numberOfLines = 2
        let paraph = NSMutableParagraphStyle()
        //行间距
        paraph.lineSpacing = 5
        paraph.alignment = .left
        //样式属性集合
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 10),
                          NSParagraphStyleAttributeName: paraph]
        address.attributedText = NSAttributedString(string: address.text!, attributes: attributes)
        address.sizeToFit()
        addSubview(address)
        
        address.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumber).offset(phoneNumber.bounds.height + 10)
            make.left.equalTo(phoneNumber)
            make.right.equalTo(phoneNumber)
        }
        
        
        addDialogToWindow()
        
    }
    
}
