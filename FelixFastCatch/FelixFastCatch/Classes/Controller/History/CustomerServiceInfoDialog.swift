//
//  CustomerServiceInfoDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class CustomerServiceInfoDialog: BaseDialog {

    override func createView() {
        
        createBackgroundImage(imageName: "联系客服背景")
        
        backgroundImage.frame.size = CGSize(width: 290, height: 210)
        backgroundImage.center = self.center
        
        // 关闭按钮
        closeBtn = UIButton(type: .custom)
        let closeImage = UIImage(named: "icon_close")
        closeBtn.setBackgroundImage(closeImage, for: .normal)
        closeBtn.frame = CGRect(x: self.bounds.width/2 + backgroundImage.bounds.width/2 - 18, y: self.bounds.height/2 - backgroundImage.bounds.height/2, width:27, height: 27)
        addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        let titleImage = UIImageView(image: UIImage(named: "联系客服顶部"))
        titleImage.sizeToFit()
        addSubview(titleImage)
        
        titleImage.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage).offset(-titleImage.bounds.height/2)
            make.centerX.equalTo(backgroundImage)
        }
        
        let qqInfo = MainCustomerLabel()
        qqInfo.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(16))
        qqInfo.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        qqInfo.outTextColor = UIColor.white
        qqInfo.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        qqInfo.text = "官方qq群:652498141"
        qqInfo.sizeToFit()
        addSubview(qqInfo)
        
        qqInfo.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(backgroundImage).offset(60)
        }
        
        let copyBtn = UIButton(type: .custom)
        copyBtn.setBackgroundImage(UIImage(named: "复制"), for: .normal)
        copyBtn.sizeToFit()
        addSubview(copyBtn)
        
        copyBtn.addTarget(self, action: #selector(copyQQNumber), for: .touchUpInside)
        
        copyBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(qqInfo)
            make.top.equalTo(qqInfo).offset(qqInfo.bounds.height + 20)
        }
        
        let servicePhoneLabel = MainCustomerLabel()
        servicePhoneLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        servicePhoneLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        servicePhoneLabel.outTextColor = UIColor.white
        servicePhoneLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        servicePhoneLabel.text = "客服热线:010-52596069转803\n(周一到周日9：00-18：00)"
        servicePhoneLabel.numberOfLines = 2
        servicePhoneLabel.sizeToFit()
        addSubview(servicePhoneLabel)
        
        servicePhoneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(qqInfo).offset(copyBtn.bounds.height + 20)
            make.left.equalTo(qqInfo)
        }
        
        let phoneBtn = UIButton(type: UIButtonType.custom)
        phoneBtn.setBackgroundImage(UIImage(named: "拨号"), for: .normal)
        phoneBtn.sizeToFit()
        addSubview(phoneBtn)
        
        phoneBtn.snp.makeConstraints { (make) in
            make.right.equalTo(copyBtn)
            make.centerY.equalTo(servicePhoneLabel)
        }
        
        phoneBtn.addTarget(self, action: #selector(callService), for: .touchUpInside)
        
        servicePhoneLabel.isHidden = true
        phoneBtn.isHidden = true
        
        addDialogToWindow()
    }

    @objc func callService(){
        let urlString = "tel://010-52596069"
        if let url = URL(string: urlString) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func copyQQNumber(){
        UIPasteboard.general.string = "652498141"
        ToastUtils.showSuccessToast(msg: "已复制到剪切板")
    }
    
    
}
