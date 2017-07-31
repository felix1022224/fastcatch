//
//  LoginDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/27.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

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
            phoneNumberLogin.createView(fastLogin:self)
            phoneNumberLogin.show()
        }else if sender == wechatLoginBtn {
            ToastUtils.showLoadingToast(msg: "正在加载中")
            WeChatShared.login({ [weak self] (info) in
                print("微信登录成功:\(info)")
                self?.wechatLogin(wechatCode:info["code"] as! String)
            }, failsure: { (error) in
                print("微信登录失败:\(error)")
                SVProgressHUD.dismiss()
            })
        }else{
            ToastUtils.showLoadingToast(msg: "正在加载中")
            TencentShared.login({ [weak self] (info) in
                print("qq登录成功:\(info)")
                self?.qqLogin(qqInfo: info)
            }, failsure: { (error) in
                print("qq登录失败:\(error)")
                SVProgressHUD.dismiss()
            })
        }
    }
    
    /// 微信登录
    func wechatLogin(wechatCode:String) -> () {
        var params = NetWorkUtils.createBaseParams()
        params["code"] = wechatCode
        
        Alamofire.request(Constants.Network.User.WECHAT_LOGIN, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            let resultJson = JSON(data: response.data!)
            print("result:\(resultJson)")
            if NetWorkUtils.checkReponse(response: response) {
                print("response:\(String(describing: response.response?.allHeaderFields))")
                LocalDataUtils.updateLocalUserData(resultData: resultJson, dataResponse:response)
                ToastUtils.showSuccessToast(msg: "登录成功")
                self.hide()
            }
        }
    }
    
    /// qq登录
    ///
    /// - Parameter qqInfo: qq返回的数据
    func qqLogin(qqInfo:[String:Any]) -> () {
        var params = NetWorkUtils.createBaseParams()
        params["openid"] = qqInfo["uid"] as? String
        params["nickname"] = qqInfo["nickName"] as? String
        params["gender"] = qqInfo["sex"] as? String
        params["figureurl_qq_1"] = qqInfo["advatarStr"] as? String
        
        Alamofire.request(Constants.Network.User.QQ_LOGIN, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            let resultJson = JSON(data: response.data!)
            if NetWorkUtils.checkReponse(response: response) {
                print("response:\(String(describing: response.response?.allHeaderFields))")
                LocalDataUtils.updateLocalUserData(resultData: resultJson, dataResponse:response)
                ToastUtils.showSuccessToast(msg: "登录成功")
                self.hide()
            }else {
                SVProgressHUD.dismiss()
            }
        }
    }
    
}
