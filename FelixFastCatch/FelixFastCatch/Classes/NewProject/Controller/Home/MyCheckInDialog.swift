//
//  MyCheckInDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/31.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

/// 签到页面的弹窗
class MyCheckInDialog: BasicDialog {

    var normalUserLabel = UILabel()
    
    var vipUserLabel = UILabel()
    
    /// 会员签到的提示
    var vipTipsLabel = UILabel()
    
    override func createView() {
        if Constants.User.vip == 100000 {
            createBackgroundImage(imageName: "VIP签到背景")
        }else if Constants.User.vip == 110000 {
            createBackgroundImage(imageName: "SVIP普通签到背景")
        }else{
            createBackgroundImage(imageName: "普通签到背景")
        }
        
        createCloseBtn()
        
        normalUserLabel.textColor = UIColor.white
        normalUserLabel.text = "签到第 \(Constants.User.checkDays) 天"
        normalUserLabel.font = UIFont.systemFont(ofSize: 24)
        normalUserLabel.sizeToFit()
        addSubview(normalUserLabel)
        
        normalUserLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage).offset(backgroundImage.bounds.height * 0.1)
            make.centerX.equalTo(backgroundImage)
        }
        
        vipUserLabel.textColor = UIColor.white
        vipUserLabel.text = "VIP签到第 \(Constants.User.checkDays) 天"
        vipUserLabel.font = UIFont.systemFont(ofSize: 24)
        vipUserLabel.sizeToFit()
        addSubview(vipUserLabel)
        
        vipUserLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage).offset(backgroundImage.bounds.height * 0.08)
            make.centerX.equalTo(backgroundImage)
        }
        
        vipTipsLabel.text = "签到 2 倍奖励"
        vipTipsLabel.font = UIFont.systemFont(ofSize: 12)
        vipTipsLabel.textColor = UIColor.white
        vipTipsLabel.sizeToFit()
        addSubview(vipTipsLabel)
        
        vipTipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(vipUserLabel).offset(vipUserLabel.bounds.height)
            make.centerX.equalTo(backgroundImage)
        }
        
        if Constants.User.vipDay > 0 {
            vipTipsLabel.isHidden = true
            vipUserLabel.isHidden = true
            
            normalUserLabel.isHidden = false
        }else{
            vipTipsLabel.isHidden = false
            vipUserLabel.isHidden = false
            
            normalUserLabel.isHidden = true
        }
        
        addDialogToWindow()
    }
    
    override func createCloseBtn() {
        let closeBtn = UIButton.init(type: UIButtonType.custom)
        closeBtn.setBackgroundImage(UIImage.init(named: "关闭"), for: UIControlState.normal)
        closeBtn.sizeToFit()
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundImage).offset(-(10 + closeBtn.bounds.width))
            make.top.equalTo(backgroundImage).offset((10 + closeBtn.bounds.height))
        }
        closeBtn.addTarget(self, action: #selector(hide), for: UIControlEvents.touchUpInside)
    }
    
}
