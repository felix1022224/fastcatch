//
//  NewUserGiftDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/2/3.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class NewUserGiftDialog: BasicDialog {

    override func createView() {
        createBackgroundImage(imageName: "新手礼包")
        
        createCloseBtn()
        
        let payButton = UIButton.init(type: UIButtonType.custom)
        payButton.setImage(UIImage.init(named: "购买礼包"), for: UIControlState.normal)
        payButton.sizeToFit()
        addSubview(payButton)
        
        payButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.bottom.equalTo(backgroundImage).offset(-10)
        }
        
        payButton.addTarget(self, action: #selector(payNewUserGift), for: UIControlEvents.touchUpInside)
        
        addDialogToWindow()
    }
    
    /// 购买一元礼包
    @objc func payNewUserGift() {
        let newUserGiftPayDialog = NewUserGiftPayDialog(frame: UIScreen.main.bounds)
        newUserGiftPayDialog.createView()
        newUserGiftPayDialog.show()
        self.hide()
    }

}
