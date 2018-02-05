//
//  LoginViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/23.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// 登录界面
class LoginViewController: UIViewController {

    /// 打开登录页面
    static func showLoginVC(){
        UIApplication.shared.keyWindow?.rootViewController?.present(LoginViewController(), animated: true, completion: nil)
    }
    
    /// 输入手机号
    var phoneNumberEdit = UITextField()
    
    /// 验证码输入框
    var verifyCodeEdit = UITextField()
    
    /// 发送验证码的按钮
    var sendVerifyCodeBtn = UIButton()
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let topBackgroundView = UIImageView()
        topBackgroundView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5)
        topBackgroundView.image = UIImage.init(named: "登录头部")
        view.addSubview(topBackgroundView)
        
        let closeBtn = UIButton.init(type: UIButtonType.custom)
        closeBtn.setBackgroundImage(UIImage.init(named: "登录关闭"), for: UIControlState.normal)
        closeBtn.sizeToFit()
        view.addSubview(closeBtn)
        
        closeBtn.addTarget(self, action: #selector(close), for: UIControlEvents.touchUpInside)
        
        let startusHeight = UIDevice.current.isX() ? 44 : 20
        
        closeBtn.frame.origin = CGPoint(x: UIScreen.main.bounds.width - 10 - closeBtn.bounds.width, y: CGFloat(startusHeight + 10))
        
        /// 手机号
        let phoneNumberEditBg = UIView()
        phoneNumberEditBg.backgroundColor = UIColor.white
        phoneNumberEditBg.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8 * 0.18)
        phoneNumberEditBg.layer.cornerRadius = phoneNumberEditBg.bounds.height/2
        phoneNumberEditBg.layer.borderColor = UIColor.init(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1.0).cgColor
        phoneNumberEditBg.layer.borderWidth = 0.5
        
        // 阴影
        phoneNumberEditBg.layer.shadowColor = UIColor.init(red: 160/255.0, green: 195/255.0, blue: 253/255.0, alpha: 1.0).cgColor
        phoneNumberEditBg.layer.shadowOpacity = 0.2
        phoneNumberEditBg.layer.shadowRadius = 20
        phoneNumberEditBg.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        phoneNumberEditBg.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width * 0.1, y: topBackgroundView.bounds.height + 10)
        
        view.addSubview(phoneNumberEditBg)
        
        phoneNumberEdit.frame = CGRect.init(x: phoneNumberEditBg.frame.origin.x + phoneNumberEditBg.bounds.width * 0.1, y: topBackgroundView.bounds.height + 10, width: phoneNumberEditBg.bounds.width * 0.6, height: phoneNumberEditBg.bounds.height)
        phoneNumberEdit.placeholder = "请输入您的手机号"
        phoneNumberEdit.keyboardType = .phonePad
        phoneNumberEdit.font = UIFont.systemFont(ofSize: 14)
        phoneNumberEdit.delegate = self
        view.addSubview(phoneNumberEdit)
        
        /// 清除输入框中的文字
        let clearBtn = UIButton.init(type: UIButtonType.custom)
        clearBtn.setBackgroundImage(UIImage.init(named: "删除内容"), for: UIControlState.normal)
        clearBtn.sizeToFit()
        view.addSubview(clearBtn)
        
        clearBtn.snp.makeConstraints { (make) in
            make.right.equalTo(phoneNumberEditBg).offset(-(phoneNumberEditBg.bounds.width * 0.1))
            make.centerY.equalTo(phoneNumberEditBg)
        }
        
        clearBtn.addTarget(self, action: #selector(clearPhoneNumberEdit), for: UIControlEvents.touchUpInside)
        
        /// 验证码
        let varifyCodeBg = UIView()
        varifyCodeBg.backgroundColor = UIColor.white
        varifyCodeBg.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8 * 0.18)
        varifyCodeBg.layer.cornerRadius = phoneNumberEditBg.bounds.height/2
        varifyCodeBg.layer.borderColor = UIColor.init(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1.0).cgColor
        varifyCodeBg.layer.borderWidth = 0.5
        
        // 阴影
        varifyCodeBg.layer.shadowColor = UIColor.init(red: 160/255.0, green: 195/255.0, blue: 253/255.0, alpha: 1.0).cgColor
        varifyCodeBg.layer.shadowOpacity = 0.2
        varifyCodeBg.layer.shadowRadius = 20
        varifyCodeBg.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        varifyCodeBg.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width * 0.1, y: topBackgroundView.bounds.height + 10 + phoneNumberEditBg.bounds.height + 15)
        
        view.addSubview(varifyCodeBg)
        
        verifyCodeEdit.frame = CGRect.init(x: phoneNumberEditBg.frame.origin.x + phoneNumberEditBg.bounds.width * 0.1, y: topBackgroundView.bounds.height + 10 + phoneNumberEditBg.bounds.height + 15, width: phoneNumberEditBg.bounds.width * 0.6, height: phoneNumberEditBg.bounds.height)
        verifyCodeEdit.placeholder = "请输入您的验证码"
        verifyCodeEdit.delegate = self
        verifyCodeEdit.keyboardType = .numberPad
        verifyCodeEdit.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(verifyCodeEdit)
        
        /// 发送验证码的按钮
        sendVerifyCodeBtn.setBackgroundImage(UIImage.init(named: "获取验证码"), for: UIControlState.normal)
        sendVerifyCodeBtn.setTitle("获取验证码", for: UIControlState.normal)
        sendVerifyCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        sendVerifyCodeBtn.titleLabel?.textColor = UIColor.white
        sendVerifyCodeBtn.sizeToFit()
        view.addSubview(sendVerifyCodeBtn)
        
        sendVerifyCodeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(varifyCodeBg)
            make.right.equalTo(varifyCodeBg).offset(-10)
        }
        
        sendVerifyCodeBtn.addTarget(self, action: #selector(sendVerifyCode), for: UIControlEvents.touchUpInside)
        
        /// 登录按钮
        let loginBtn = UIButton.init(frame: UIScreen.main.bounds)
        loginBtn.setBackgroundImage(UIImage.init(named: "登录btn"), for: UIControlState.normal)
        loginBtn.sizeToFit()
        loginBtn.frame = CGRect(x: UIScreen.main.bounds.width/2 - loginBtn.bounds.width/2, y: topBackgroundView.bounds.height + 10 + phoneNumberEditBg.bounds.height + 15 + varifyCodeBg.bounds.height + 25, width: loginBtn.bounds.width, height: loginBtn.bounds.height)
        view.addSubview(loginBtn)
        
        loginBtn.addTarget(self, action: #selector(phoneLogin), for: UIControlEvents.touchUpInside)
        
        
//        let loginLabel = UILabel()
//        loginLabel.textColor = UIColor.white
//        loginLabel.text = "登 录"
//        loginLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
//        loginLabel.sizeToFit()
//        loginBtn.addSubview(loginLabel)
//
//        loginLabel.frame.origin = CGPoint.init(x: loginBtn.bounds.width/2 - loginLabel.bounds.width/2, y: loginBtn.bounds.height/2 - loginLabel.bounds.height/2)
//        view.addSubview(loginBtn)
//
//        loginBtn.isUserInteractionEnabled = true
//        let loginTap = UITapGestureRecognizer.init(target: self, action: #selector(phoneLogin))
//        loginBtn.addGestureRecognizer(loginTap)
        
        let protocolLabel = UILabel()
        protocolLabel.textColor = UIColor.lightGray
        protocolLabel.font = UIFont.systemFont(ofSize: 12)
        
        let attrText = NSMutableAttributedString.init(string: "点击登录，即表示您已经同意《秒抓APP用户协议》")
        attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.init(red: 0/255.0, green: 217/255.0, blue: 252/255.0, alpha: 1.0), range: NSRange(location: 13, length:11))
        protocolLabel.sizeToFit()
        protocolLabel.attributedText = attrText
        
        view.addSubview(protocolLabel)
        
        protocolLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn).offset(loginBtn.bounds.height + 15)
            make.centerX.equalTo(loginBtn)
        }
        
        let protocoLabelTap = UITapGestureRecognizer.init(target: self, action: #selector(tapProtoco))
        protocolLabel.isUserInteractionEnabled = true
        protocolLabel.addGestureRecognizer(protocoLabelTap)
        
        /// lineGroup
        let lineGroupView = UIView()
        lineGroupView.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8 * 0.2)
        lineGroupView.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width * 0.1, y: loginBtn.frame.origin.y + loginBtn.bounds.height + 40)
        view.addSubview(lineGroupView)
        
        let leftLineView = UIView()
        leftLineView.backgroundColor = UIColor.gray
        leftLineView.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.3, height: 1)
        lineGroupView.addSubview(leftLineView)
        
        
        let middLabel = UILabel()
        middLabel.text = "OR"
        middLabel.textColor = UIColor.gray
        middLabel.font = UIFont.systemFont(ofSize: 16)
        middLabel.sizeToFit()
        lineGroupView.addSubview(middLabel)
        
        let rightLine = UIView()
        rightLine.backgroundColor = UIColor.gray
        rightLine.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.3, height: 1)
        lineGroupView.addSubview(rightLine)
        
        middLabel.frame.origin = CGPoint.init(x: lineGroupView.bounds.width/2 - middLabel.bounds.width/2, y: lineGroupView.bounds.height/2 - middLabel.bounds.height/2)
        
        leftLineView.frame.origin = CGPoint.init(x: 0, y: lineGroupView.bounds.height/2 - 0.5)
        rightLine.frame.origin = CGPoint.init(x: lineGroupView.bounds.width - rightLine.bounds.width, y: lineGroupView.bounds.height/2 - 0.5)
        
        /// 微信登录
        let wechatLogin = UIButton.init(type: UIButtonType.custom)
        wechatLogin.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8 * 0.14)
        wechatLogin.setBackgroundImage(UIImage.init(named: "微信登录"), for: UIControlState.normal)
        view.addSubview(wechatLogin)
        
        wechatLogin.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width/2 - wechatLogin.bounds.width/2, y: lineGroupView.frame.origin.y + lineGroupView.bounds.height + 10)
        
        wechatLogin.addTarget(self, action: #selector(wechatLoginClick), for: UIControlEvents.touchUpInside)
        
        /// qq登录
        let qqLoginBtn = UIButton.init(type: UIButtonType.custom)
        qqLoginBtn.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8 * 0.14)
        qqLoginBtn.setBackgroundImage(UIImage.init(named: "qq登录"), for: UIControlState.normal)
        view.addSubview(qqLoginBtn)
        
        qqLoginBtn.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width/2 - qqLoginBtn.bounds.width/2, y: wechatLogin.bounds.height + wechatLogin.frame.origin.y + 15)
        
        qqLoginBtn.addTarget(self, action: #selector(qqLoginClick), for: UIControlEvents.touchUpInside)
        
        if WeChatShared.isInstall() == false {
            /// 没有安装微信
            wechatLogin.isHidden = true
        }else{
            wechatLogin.isHidden = false
        }
    }
    
    @objc func tapProtoco(){
        let protocoVC = UserAgreementViewController()
        self.present(protocoVC, animated: true, completion: nil)
    }
    
    /// 手机号进行登录
    @objc func phoneLogin(){
        if phoneNumberEdit.text?.count != 11 {
            ToastUtils.showErrorToast(msg: "请输入正确的手机号")
            return
        }
        if (verifyCodeEdit.text?.count)! > Int(6) || (verifyCodeEdit.text?.count)! <= Int(0) {
            ToastUtils.showErrorToast(msg: "请输入正确的验证码")
            return
        }
        
        ToastUtils.showLoadingToast(msg: "登录中……")
        
        var params = NetWorkUtils.createBaseParams()
        params["code"] = verifyCodeEdit.text
        params["phone"] = phoneNumberEdit.text
        
        Alamofire.request(Constants.Network.PHONE_NUMBER_LOGIN, method: .post, parameters: params).responseJSON { (response) in
            if response.error == nil && response.data != nil {
                let resultJson = JSON(data: response.data!)
                if NetWorkUtils.checkReponse(response: response) {
                    LocalDataUtils.updateLocalUserData(resultData: resultJson, response)
                    ToastUtils.showSuccessToast(msg: "登录成功")
                    self.close()
//                    if resultJson["data"]["new"].boolValue {
//                        self.showFirstLoginReward()
//                    }
                }else{
                    let json = JSON(response.result.value!)
                    ToastUtils.showErrorToast(msg: "登录失败:\(json["msg"].stringValue)")
                }
            }
        }
    }
    
    /// 发送验证码
    @objc func sendVerifyCode(){
        if phoneNumberEdit.text?.count != 11 {
            ToastUtils.showErrorToast(msg: "请输入正确的手机号")
            return
        }
        
        var params = NetWorkUtils.createBaseParams()
        params["phone"] = phoneNumberEdit.text
        Alamofire.request(Constants.Network.SEND_VERIFY_CODE, method: .post, parameters: params).responseJSON { (response) in
            if response.error == nil && response.data != nil {
                let json = JSON(data: response.data!)
                if json["code"].int == 0 {
                    self.view.endEditing(true)
                    ToastUtils.showSuccessToast(msg: "发送成功")
                    // 开始倒计时
                    self.isCounting = true
                }
            }
        }
    }
    
    /// 倒计时
    fileprivate var countdownTimer: Timer?
    
    private var remainingSeconds: Int = 0 {
        willSet {
            sendVerifyCodeBtn.setTitle("\(newValue)s", for: .normal)
            
            if newValue <= 0 {
                sendVerifyCodeBtn.setTitle("获取验证码", for: .normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                
                remainingSeconds = 60
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
            
            sendVerifyCodeBtn.isEnabled = !newValue
        }
    }
    
    @objc private func updateTime() {
        remainingSeconds -= 1
    }
    
    @objc func clearPhoneNumberEdit(){
        phoneNumberEdit.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func wechatLoginClick()  {
        WeChatShared.login({ [weak self] (info) in
            /// 微信登录成功
            self?.wechatLogin(wechatCode:info["code"] as! String)
            }, failsure: { (error) in
                /// 微信登录失败
                ToastUtils.showErrorToast(msg: "微信登录异常")
        })
    }
    
    /// 微信登录
    func wechatLogin(wechatCode:String) -> () {
        var params = NetWorkUtils.createBaseParams()
        params["code"] = wechatCode
        
        Alamofire.request(Constants.Network.User.WECHAT_LOGIN, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let resultJson = JSON(data: response.data!)
                LocalDataUtils.updateLocalUserData(resultData: resultJson, response)
                ToastUtils.showSuccessToast(msg: "登录成功")
//                if resultJson["data"]["new"].boolValue {
//                    self.showFirstLoginReward()
//                }
                self.close()
            }
        }
    }
    
    @objc func qqLoginClick() {
        TencentShared.login({ [weak self] (info) in
            /// 登录成功
            self?.qqLogin(qqInfo: info)
            }, failsure: { (error) in
                /// 登录失败
                ToastUtils.showErrorToast(msg: "QQ登录异常")
        })
    }
    
    /// qq登录
    ///
    /// - Parameter qqInfo: qq返回的数据
    func qqLogin(qqInfo:[String:Any]) -> () {
        var params = NetWorkUtils.createBaseParams()
        params["openid"] = qqInfo["uid"] as? String
        params["nickname"] = qqInfo["nickName"] as? String
        if qqInfo["sex"] as? String == "男" {
            params["gender"] = "0"
        }else {
            params["gender"] = "1"
        }
        params["figureurl_qq_1"] = qqInfo["advatarStr"] as? String
        
        Alamofire.request(Constants.Network.User.QQ_LOGIN, method: .post, parameters: params).responseJSON { (response) in
            let resultJson = JSON(data: response.data!)
            print("请求服务器QQ登录回调:\(String(describing: response.result.value))")
            if NetWorkUtils.checkReponse(response: response) {
                ToastUtils.showSuccessToast(msg: "登录成功")
                LocalDataUtils.updateLocalUserData(resultData: resultJson, response)
//                if resultJson["data"]["new"].boolValue {
//                    self.showFirstLoginReward()
//                }
                self.close()
            }else {
                ToastUtils.hide()
            }
        }
    }

}

// MARK: - 文字输入框的代理
extension LoginViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == self.phoneNumberEdit) {
            let existedLength = textField.text?.count;
            let selectedLength = range.length;
            let replaceLength = string.count;
            
            if (existedLength! - selectedLength + replaceLength >= 12) {
                let endIndex = textField.text?.index((textField.text?.startIndex)!, offsetBy: 11)
                
                let subString = textField.text?.prefix(upTo: endIndex!)
                textField.text = String(subString!)
                
                return false
            }
        }
        
        if textField == self.verifyCodeEdit {
            let existedLength = textField.text?.count;
            let selectedLength = range.length;
            let replaceLength = string.count;
            
            if (existedLength! - selectedLength + replaceLength >= 7) {
                let endIndex = textField.text?.index((textField.text?.startIndex)!, offsetBy: 6)
                
                let subString = textField.text?.prefix(upTo: endIndex!)
                textField.text = String(subString!)
                
                return false
            }
        }
        return true
    }
    
}
