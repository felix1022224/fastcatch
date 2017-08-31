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
        
        // 关闭按钮
//        closeBtn = UIButton(type: .custom)
//        let closeImage = UIImage(named: "icon_close")
//        closeBtn.setBackgroundImage(closeImage, for: .normal)
//        closeBtn.frame = CGRect(x: self.bounds.width/2 + backgroundImage.bounds.width/2 - 18, y: self.bounds.height/2 - backgroundImage.bounds.height/2 - 5, width:27, height: 27)
//        addSubview(closeBtn)
//        closeBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        let outGameInfo = MainCustomerLabel()
        outGameInfo.outTextColor = UIColor.white
        outGameInfo.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        outGameInfo.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        outGameInfo.text = "游戏中不能退出房间"
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
        
        okBtn.isHidden = true
        cancelBtn.isHidden = true
        
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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [weak self] in
            self?.hide()
        }
    }
}
