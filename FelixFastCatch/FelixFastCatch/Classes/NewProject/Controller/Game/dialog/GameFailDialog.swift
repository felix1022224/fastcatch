//
//  GameFailDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/24.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class GameFailDialog: BasicDialog {

    /// 取消的回调
    var cancelCallback:(()->())!
    
    /// 再玩一次的回调
    var againCallback:(()->())!
    
    var timeLabel = UILabel()
    
    /// 是不是0元抓
    var isZeroCatch = false
    
    var eneryNumber = 0
    
    override func createView() {
        createBackgroundImage(imageName: "失败弹框")
        
        createCloseBtn()
        
        let title = UILabel()
        title.text = "就差一点点哦~"
        title.textColor = UIColor.init(red: 0/255.0, green: 136/255.0, blue: 196/255.0, alpha: 1.0)
        title.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        title.sizeToFit()
        addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.centerY.equalTo(backgroundImage).offset(10)
        }
        
        let descLabel = UILabel()
        if isZeroCatch {
            descLabel.text = "不要灰心哦~"
        }else{
            descLabel.text = "再玩\(eneryNumber)局直接带走~"
        }
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.gray
        descLabel.sizeToFit()
        addSubview(descLabel)
        
        descLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(title).offset(title.bounds.height + 15)
        }
        
        let descLabel2 = UILabel()
        if isZeroCatch {
            descLabel2.text = "再玩一次嘛~"
        }else{
            descLabel2.text = "不要放弃嘛~"
        }
        descLabel2.font = UIFont.systemFont(ofSize: 14)
        descLabel2.textColor = UIColor.gray
        descLabel2.sizeToFit()
        addSubview(descLabel2)
        
        descLabel2.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(descLabel).offset(descLabel.bounds.height + 5)
        }
        
        let cancelButton = UIButton.init(type: UIButtonType.custom)
        if isZeroCatch {
            cancelButton.setBackgroundImage(UIImage.init(named: "游戏界面无力再战"), for: UIControlState.normal)
        }else{
            cancelButton.setBackgroundImage(UIImage.init(named: "就此放弃"), for: UIControlState.normal)
        }
        cancelButton.sizeToFit()
        addSubview(cancelButton)
        
        cancelButton.addTarget(self, action: #selector(cancel), for: UIControlEvents.touchUpInside)
        
        let againButton = UIButton.init(type: UIButtonType.custom)
        againButton.setBackgroundImage(UIImage.init(named: "游戏界面再玩一次"), for: UIControlState.normal)
        againButton.sizeToFit()
        addSubview(againButton)
        
        againButton.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundImage).offset(-6)
            make.bottom.equalTo(backgroundImage).offset(-15)
        }
        
        againButton.addTarget(self, action: #selector(again), for: UIControlEvents.touchUpInside)
        
        timeLabel.text = "(15S)"
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.white
        timeLabel.sizeToFit()
        addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(againButton)
            make.right.equalTo(againButton).offset(-againButton.bounds.width * 0.15)
        }
        
        if isZeroCatch {
            againButton.isHidden = true
            cancelButton.snp.makeConstraints({ (make) in
                make.centerX.equalTo(backgroundImage)
                make.bottom.equalTo(backgroundImage).offset(-15)
            })
            timeLabel.isHidden = true
        }else{
            againButton.isHidden = false
            isCounting = true
            timeLabel.isHidden = false
            cancelButton.snp.makeConstraints { (make) in
                make.left.equalTo(backgroundImage).offset(6)
                make.bottom.equalTo(backgroundImage).offset(-15)
            }
        }
        
        addDialogToWindow()
    }
    
    /// 游戏倒计时
    fileprivate var countdownTimer: Timer?
    
    fileprivate var remainingSeconds: Int = 0 {
        willSet {
            if newValue < 10 {
                timeLabel.text = "(0\(newValue)S)"
            }else {
                timeLabel.text = "(\(newValue)S)"
            }
            
            if newValue <= 0 {
                timeLabel.text = "(15S)"
                isCounting = false
                cancel()
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                remainingSeconds = 15
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
        }
    }
    
    @objc func updateTime() {
        remainingSeconds -= 1
    }
    
    @objc func cancel() {
        hide()
        if cancelCallback != nil {
            cancelCallback()
        }
    }
    
    @objc func again(){
        hide()
        if againCallback != nil {
            againCallback()
        }
    }
    
    override func hide() {
        isCounting = false
        countdownTimer?.invalidate()
        countdownTimer = nil
        super.hide()
    }

}
