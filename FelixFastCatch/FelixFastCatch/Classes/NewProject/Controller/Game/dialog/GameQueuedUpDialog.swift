//
//  GameQueuedUpDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/24.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class GameQueuedUpDialog: BasicDialog {

    /// 取消的回调
    var cancelCallback:(()->())!
    
    /// 立即开始的回调
    var startGameCallback:(()->())!

    var timeLabel = UILabel()
    
    override func createView() {
        createBackgroundImage(imageName: "到你弹框")
        
        createCloseBtn()
        
        let title = UILabel()
        title.text = "快来开始你的表演~"
        title.textColor = UIColor.init(red: 255/255.0, green: 137/255.0, blue: 143/255.0, alpha: 1.0)
        title.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        title.sizeToFit()
        addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.centerY.equalTo(backgroundImage).offset(10)
        }
        
        let descLabel = UILabel()
        descLabel.text = "哎呀，终于轮到你了"
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.gray
        descLabel.sizeToFit()
        addSubview(descLabel)
        
        descLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(title).offset(title.bounds.height + 15)
        }
        
        let descLabel2 = UILabel()
        descLabel2.text = "快来展示你的绝技啦~"
        descLabel2.font = UIFont.systemFont(ofSize: 14)
        descLabel2.textColor = UIColor.gray
        descLabel2.sizeToFit()
        addSubview(descLabel2)
        
        descLabel2.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(descLabel).offset(descLabel.bounds.height + 5)
        }
        
        let againButton = UIButton.init(type: UIButtonType.custom)
        againButton.setBackgroundImage(UIImage.init(named: "游戏界面立即开始"), for: UIControlState.normal)
        againButton.sizeToFit()
        addSubview(againButton)
        
        againButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImage).offset(-15)
            make.centerX.equalTo(backgroundImage)
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
        
        isCounting = true
        
        addDialogToWindow()
    }
    
    override func createCloseBtn() {
        let closeBtn = UIButton.init(type: UIButtonType.custom)
        closeBtn.setBackgroundImage(UIImage.init(named: "关闭"), for: UIControlState.normal)
        closeBtn.sizeToFit()
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundImage).offset(-10)
            make.top.equalTo(backgroundImage).offset(10)
        }
        closeBtn.addTarget(self, action: #selector(cancel), for: UIControlEvents.touchUpInside)
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
        if startGameCallback != nil {
            startGameCallback()
        }
    }
    
    override func hide() {
        isCounting = false
        countdownTimer?.invalidate()
        countdownTimer = nil
        super.hide()
    }
    
}
