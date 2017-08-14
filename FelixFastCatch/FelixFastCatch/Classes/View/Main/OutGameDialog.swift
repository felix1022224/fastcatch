//
//  OutGameDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class OutGameDialog: BaseDialog {

    /// 确认退出
    var yesOut:(()->())? = nil
    
    override func createView() {
        createBackgroundImage(imageName: "bg_out_game")
        
        backgroundImage.frame.size = CGSize(width: 298, height: 154)
        backgroundImage.center = self.center
        
        let outGameInfo = MainCustomerLabel()
        outGameInfo.outTextColor = UIColor.white
        outGameInfo.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        outGameInfo.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        outGameInfo.text = "确认退出游戏？"
        outGameInfo.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(18))
        outGameInfo.sizeToFit()
        addSubview(outGameInfo)
        
        outGameInfo.center = backgroundImage.center
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setBackgroundImage(UIImage(named: "cancel_button"), for: .normal)
        addSubview(cancelBtn)
    
        
        cancelBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        let okBtn = UIButton(type: .custom)
        okBtn.setBackgroundImage(UIImage(named: "ok_button"), for: .normal)
        addSubview(okBtn)
        
        okBtn.snp.makeConstraints { (make) in
            make.width.equalTo(54)
            make.height.equalTo(54)
            make.bottom.equalTo(backgroundImage).offset(54/2)
            make.left.equalTo(backgroundImage).offset(backgroundImage.bounds.width/2 + 10)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.width.equalTo(54)
            make.height.equalTo(54)
            make.bottom.equalTo(backgroundImage).offset(54/2)
            make.left.equalTo(backgroundImage).offset(backgroundImage.bounds.width/2 - 10 - 54)
        }
        
        okBtn.addTarget(self, action: #selector(out), for: .touchUpInside)
        
        addDialogToWindow()
    }
    
    /// 确认退出游戏
    @objc func out(){
        if yesOut != nil {
            yesOut!()
        }
        hide()
    }
    
    func show2(action:@escaping ()->()) -> () {
        show()
        yesOut = action
    }
}
