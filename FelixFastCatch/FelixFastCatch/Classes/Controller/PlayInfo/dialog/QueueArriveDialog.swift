//
//  QueueArriveDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/11/6.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

/// 排队排到了的弹出框
class QueueArriveDialog: BaseDialog {

    /// 确认返回的callback
    var confirmCallback:(()->())? = nil
    
    /// 取消或者到时间了的callback
    var cancelCallback:(()->())? = nil
    
    /// 确认按钮
    var confirmBtn:UIButton = UIButton(type: UIButtonType.custom)
    
    /// 倒计时的文字
    var confirmTimeLabel:MainCustomerLabel = MainCustomerLabel()
    
    override func createView() {
        createBackgroundImage(imageName: "排队结束弹框")
        
        backgroundImage.center = self.center
        
        /// 关闭按钮
        let closeBtn = UIButton()
        addSubview(closeBtn)
        
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage)
            make.right.equalTo(backgroundImage)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        confirmBtn.setBackgroundImage(UIImage(named: "立即开始"), for: .normal)
        confirmBtn.setBackgroundImage(UIImage(named: "立即开始点击"), for: .highlighted)
        addSubview(confirmBtn)
        
        confirmBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.bottom.equalTo(backgroundImage).offset(-15)
        }
        
        confirmTimeLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(16))
        confirmTimeLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        confirmTimeLabel.outTextColor = UIColor.white
        confirmTimeLabel.outLienTextColor = UIColor.gray
        confirmTimeLabel.text = "立即开始(12s)"
        addSubview(confirmTimeLabel)
        
        confirmTimeLabel.snp.makeConstraints { (make) in
            make.center.equalTo(confirmBtn)
        }
        
        confirmBtn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        
        //开始倒计时
        isCounting = true
        
        addDialogToWindow()
    }
    
    /// 游戏倒计时
    fileprivate var countdownTimer: Timer?
    
    fileprivate var remainingSeconds: Int = 0 {
        willSet {
            if newValue < 10 {
                confirmTimeLabel.text = "立即开始(0\(newValue)s)"
            }else {
                confirmTimeLabel.text = "立即开始(\(newValue)s)"
            }
            
            if newValue <= 0 {
                confirmTimeLabel.text = "立即开始(12s)"
                isCounting = false
                close()
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                remainingSeconds = 12
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
        }
    }
    
    @objc func updateTime() {
        remainingSeconds -= 1
    }
    
    /// 关闭
    @objc func close(){
        if cancelCallback != nil {
            cancelCallback!()
        }
        hide()
    }
    
    @objc func confirm(){
        if confirmCallback != nil {
            confirmCallback!()
        }
        hide()
    }
    
    override func hide() {
        isCounting = false
        countdownTimer = nil
        super.hide()
    }
    
}
