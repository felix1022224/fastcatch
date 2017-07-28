//
//  LoginDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/27.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

/// 快速登录的悬浮窗
class FastLoginDialog: BaseDialog {

    /// 手机号登录
    fileprivate var phoneNumberLogin:PhoneNumberDialog!
    
    /// 手机号登录按钮
    fileprivate var phoneNumberLoginBtn:UIButton!
    
    /// 微信登录按钮
    fileprivate var wechatLoginBtn:UIButton!
    
    /// qq登录按钮
    fileprivate var qqLoginBtn:UIButton!
    
    override func createView() {
        createBackgroundImage(imageName: "login_background")
        
        phoneNumberLogin = PhoneNumberDialog(frame: self.bounds)
        
        // 手机号登录
        phoneNumberLoginBtn = UIButton(type: .custom)
        phoneNumberLoginBtn.setImage(UIImage(named: "icon_phone"), for: .normal)
        phoneNumberLoginBtn.sizeToFit()
        addSubview(phoneNumberLoginBtn)
        
        phoneNumberLoginBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.centerY.equalTo(backgroundImage).offset(-phoneNumberLoginBtn.bounds.height/2)
        }
        
        // 微信
        wechatLoginBtn = UIButton(type: .custom)
        wechatLoginBtn.setImage(UIImage(named: "icon_weixin"), for: .normal)
        wechatLoginBtn.sizeToFit()
        addSubview(wechatLoginBtn)
        
        wechatLoginBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage).offset(-wechatLoginBtn.bounds.width)
            make.centerY.equalTo(backgroundImage).offset(wechatLoginBtn.bounds.height/1.5)
        }
        
        
        // qq
        qqLoginBtn = UIButton(type: .custom)
        qqLoginBtn.setImage(UIImage(named: "icon_qq"), for: .normal)
        qqLoginBtn.sizeToFit()
        addSubview(qqLoginBtn)
        
        qqLoginBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage).offset(qqLoginBtn.bounds.width)
            make.centerY.equalTo(wechatLoginBtn)
        }

        phoneNumberLoginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        wechatLoginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        qqLoginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        
        /// 关闭按钮
        let close_btn = UIButton(type: .custom)
        close_btn.setImage(UIImage(named: "fast_login_close_btn"), for: .normal)
        close_btn.sizeToFit()
        addSubview(close_btn)
        
        close_btn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(backgroundImage).offset(close_btn.bounds.height/2)
        }
        
        close_btn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        addDialogToWindow()
    }
    
    // 按钮点击事件
    func loginBtnClick(sender:UIButton) -> () {
        if sender == phoneNumberLoginBtn {
            phoneNumberLogin.createView()
            phoneNumberLogin.show()
        }else if sender == wechatLoginBtn {
            WeChatShared.login({ (info) in
                print("微信登录成功:\(info)")
            }, failsure: { (error) in
                print("微信登录失败:\(error)")
            })
        }else{
            TencentShared.login({ (info) in
                print("qq登录成功:\(info)")
            }, failsure: { (error) in
                print("qq登录失败:\(error)")
            })
        }
    }

}
