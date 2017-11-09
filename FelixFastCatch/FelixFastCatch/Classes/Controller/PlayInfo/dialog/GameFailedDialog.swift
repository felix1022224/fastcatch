//
//  GameFailedDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/11/7.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

/// 游戏失败
class GameFailedDialog: BaseDialog {

    /// 继续游戏的callback
    var confirmCallback:(()->())? = nil
    
    /// 不再继续游戏的callback
    var cancelCallback:(()->())? = nil
    
    /// 倒计时的文字
    var againGameTimeLabel:MainCustomerLabel = MainCustomerLabel()
    
    override func createView() {
        createBackgroundImage(imageName: "游戏失败背景")
        
        backgroundImage.center = self.center
        
        //取消游戏的按钮
        let cancelGameButton = UIButton(type: UIButtonType.custom)
        cancelGameButton.setBackgroundImage(UIImage(named: "无力再战"), for: .normal)
        cancelGameButton.setBackgroundImage(UIImage(named: "无力再战点击"), for: .highlighted)
        self.addSubview(cancelGameButton)
        
        cancelGameButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImage).offset(-15)
            make.right.equalTo(backgroundImage).offset(-backgroundImage.bounds.width/2 - 8)
        }
        
        cancelGameButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        //继续游戏的按钮
        let againGameButton = UIButton(type: UIButtonType.custom)
        againGameButton.setBackgroundImage(UIImage(named: "再玩一次"), for: .normal)
        againGameButton.setBackgroundImage(UIImage(named: "再玩一次点击"), for: .highlighted)
        self.addSubview(againGameButton)
        
        againGameButton.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundImage).offset(backgroundImage.bounds.width/2 + 8)
            make.centerY.equalTo(cancelGameButton)
        }
        
        againGameTimeLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(16))
        againGameTimeLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        againGameTimeLabel.outTextColor = UIColor.white
        againGameTimeLabel.outLienTextColor = UIColor.gray
        againGameTimeLabel.text = "再玩一局(15s)"
        addSubview(againGameTimeLabel)
        
        againGameTimeLabel.snp.makeConstraints { (make) in
            make.center.equalTo(againGameButton)
        }
        
        againGameButton.addTarget(self, action: #selector(againGame), for: .touchUpInside)
        
        //开始倒计时
        isCounting = true
        
        addDialogToWindow()
    }
    
    /// 再来一局
    @objc func againGame() -> () {
        if confirmCallback != nil {
            confirmCallback!()
        }
        hide()
    }
    
    /// 游戏倒计时
    fileprivate var countdownTimer: Timer?
    
    fileprivate var remainingSeconds: Int = 0 {
        willSet {
            if newValue < 10 {
                againGameTimeLabel.text = "再玩一局(0\(newValue)s)"
            }else {
                againGameTimeLabel.text = "再玩一局(\(newValue)s)"
            }
            
            if newValue <= 0 {
                againGameTimeLabel.text = "再玩一局(15s)"
                isCounting = false
                close()
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
    
    /// 关闭
    @objc func close(){
        if cancelCallback != nil {
            cancelCallback!()
        }
        hide()
    }
    
    override func hide() {
        isCounting = false
        super.hide()
    }
    

}
