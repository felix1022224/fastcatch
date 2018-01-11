//
//  VIPDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/10.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class VIPDialog: BaseDialog {

    let closeView = UIView()
    
    var vipCallback:(()->())!
    
    override func createView() {
        createBackgroundImage(imageName: "VIP会员")
        backgroundImage.center = self.center
        
        addSubview(closeView)
        
        closeView.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundImage)
            make.top.equalTo(backgroundImage)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        closeView.isUserInteractionEnabled = true
        closeView.addGestureRecognizer(tap)
        
        /// 购买按钮
        let payButton = UIButton(type: UIButtonType.custom)
        
        payButton.setBackgroundImage(UIImage(named: "立即开通VIPH"), for: .disabled)
        
        if Constants.User.vip == 110000 {
            ///svip 直接置灰
            payButton.isEnabled = false
        }else{
            payButton.isEnabled = true
            if Constants.User.vip == 100000 {
                payButton.setBackgroundImage(UIImage(named: "续费"), for: .normal)
            }else{
                payButton.setBackgroundImage(UIImage(named: "立即开通VIP"), for: .normal)
            }
        }
        payButton.sizeToFit()
        addSubview(payButton)
        
        payButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.bottom.equalTo(backgroundImage).offset(-20)
        }
        
        payButton.addTarget(self, action: #selector(callback), for: .touchUpInside)
        
        addDialogToWindow()
    }
    
    @objc func callback(){
        if vipCallback != nil {
            vipCallback!()
        }
        hide()
    }

}