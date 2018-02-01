//
//  MyCheckInDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/31.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/// 签到页面的弹窗
class MyCheckInDialog: BasicDialog {

    var normalUserLabel = UILabel()
    
    var vipUserLabel = UILabel()
    
    /// 会员签到的提示
    var vipTipsLabel = UILabel()
    
    /// 签到的图片
    var  checkInImg = UIImageView()
    
    /// 签到按钮
    var checkInButton = UIButton.init(type: UIButtonType.custom)
    
    override func createView() {
        if Constants.User.vip == 100000 && Constants.User.vipDay > 0 {
            createBackgroundImage(imageName: "VIP签到背景")
        }else if Constants.User.vip == 110000 && Constants.User.vipDay > 0 {
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
            make.top.equalTo(backgroundImage).offset(backgroundImage.bounds.height * 0.15)
            make.centerX.equalTo(backgroundImage)
        }
        
        vipUserLabel.textColor = UIColor.white
        vipUserLabel.font = UIFont.systemFont(ofSize: 24)
        vipUserLabel.sizeToFit()
        addSubview(vipUserLabel)
        
        vipUserLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage).offset(backgroundImage.bounds.height * 0.12)
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
        
        updateCheckImg()
        checkInImg.sizeToFit()
        addSubview(checkInImg)
        
        checkInImg.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(backgroundImage).offset(backgroundImage.bounds.height * 0.35)
        }
        
        checkInButton.setBackgroundImage(UIImage.init(named: "马上签到按钮"), for: UIControlState.normal)
        checkInButton.setBackgroundImage(UIImage.init(named: "签到按钮不可点击"), for: UIControlState.disabled)
        checkInButton.sizeToFit()
        addSubview(checkInButton)
        
        checkInButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.bottom.equalTo(backgroundImage).offset(-10)
        }
        
        checkInButton.addTarget(self, action: #selector(UserCheckIn), for: UIControlEvents.touchUpInside)
        
        updateDayNumber()
        addDialogToWindow()
        updateCheckInButtonStatus()
    }
    
    func updateCheckInButtonStatus() {
        if Constants.User.todayChecked {
            checkInButton.isEnabled = false
        }else{
            checkInButton.isEnabled = true
        }
    }
    
    func updateDayNumber() {
        if Constants.User.vip == 100000 {
            vipUserLabel.text = "VIP签到第 \(Constants.User.checkDays) 天"
        }else if Constants.User.vip == 110000 {
            vipUserLabel.text = "SVIP签到第 \(Constants.User.checkDays) 天"
        }
        normalUserLabel.text = "签到第 \(Constants.User.checkDays) 天"
        
        normalUserLabel.sizeToFit()
        vipUserLabel.sizeToFit()
    }
    
    func updateCheckImg() {
        if Constants.User.checkDays <= 0 {
            checkInImg.image = UIImage.init(named: "未签到")
        }else if Constants.User.checkDays == 1 {
            checkInImg.image = UIImage.init(named: "签到1")
        }else if Constants.User.checkDays == 2 {
            checkInImg.image = UIImage.init(named: "签到2")
        }else if Constants.User.checkDays == 3 {
            checkInImg.image = UIImage.init(named: "签到3")
        }else if Constants.User.checkDays == 4 {
            checkInImg.image = UIImage.init(named: "签到4")
        }else if Constants.User.checkDays == 5 {
            checkInImg.image = UIImage.init(named: "签到5")
        }else if Constants.User.checkDays == 6 {
            checkInImg.image = UIImage.init(named: "签到6")
        }else if Constants.User.checkDays >= 7 {
            checkInImg.image = UIImage.init(named: "签到7")
        }
    }
    
    override func createCloseBtn() {
        let closeBtn = UIButton.init(type: UIButtonType.custom)
        closeBtn.setBackgroundImage(UIImage.init(named: "关闭"), for: UIControlState.normal)
        closeBtn.sizeToFit()
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundImage).offset(-closeBtn.bounds.width)
            make.top.equalTo(backgroundImage).offset(closeBtn.bounds.height)
        }
        closeBtn.addTarget(self, action: #selector(hide), for: UIControlEvents.touchUpInside)
    }
    
    @objc func UserCheckIn() -> () {
        Alamofire.request(Constants.Network.User.USER_CHECKIN, method: .post, parameters: NetWorkUtils.createBaseParams()).responseJSON { [weak self] (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(response.result.value!)
                Constants.User.checkDays = json["data"]["checkedDays"].intValue
                Constants.User.todayChecked = true
                
                self?.updateCheckImg()
                self?.updateCheckInButtonStatus()
                self?.updateDayNumber()
            }
        }
    }
    
}
