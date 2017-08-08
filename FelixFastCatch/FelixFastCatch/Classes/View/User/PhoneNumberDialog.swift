//
//  PhoneNumberDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/27.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class PhoneNumberDialog: BaseDialog {

    // 登录按钮
    fileprivate lazy var loginBtn:UIButton = UIButton(type: UIButtonType.custom)
    
    // 手机号输入框
    fileprivate lazy var phoneNumberEdit:MainCustomerTextField = MainCustomerTextField()
    
    // 验证码输入框
    fileprivate lazy var verifyCodeEdit:MainCustomerTextField = MainCustomerTextField()
    
    // 验证码发送按钮
    fileprivate lazy var verifySendBtn:UIButton = UIButton(type: UIButtonType.custom)
    
    fileprivate var fastLoginDialog:FastLoginDialog!
    
    /// 新手奖励弹窗
    fileprivate var firstLoginReward:FirstLoginRewardDialog!
    
    override func createView() {
        
    }
    
    func createView(fastLogin:FastLoginDialog) {
        self.fastLoginDialog = fastLogin
        
        firstLoginReward = FirstLoginRewardDialog(frame: UIScreen.main.bounds)
        
        createBackgroundImage(imageName: "register_login_background")
        
        backgroundImage.frame.size = CGSize(width: 290, height: 225)
        backgroundImage.center = self.center
        
        createCloseBtn()
        
        // 手机号的label
        let phoneNumberLabel = MainCustomerLabel()
        phoneNumberLabel.outTextColor = UIColor.white
        phoneNumberLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        phoneNumberLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        phoneNumberLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        phoneNumberLabel.text = "手机号:"
        phoneNumberLabel.sizeToFit()
        addSubview(phoneNumberLabel)
        
        phoneNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage).offset(85)
            make.left.equalTo(backgroundImage).offset(35)
        }
        
        // 手机号输入框
        phoneNumberEdit.background = UIImage(named: "phone_number_background")
        phoneNumberEdit.outTextColor = UIColor.white
        phoneNumberEdit.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        phoneNumberEdit.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        phoneNumberEdit.placeholder = "请输入手机号码"
        phoneNumberEdit.font = UIFont.systemFont(ofSize: CGFloat(12))
        phoneNumberEdit.keyboardType = .phonePad
        phoneNumberEdit.textAlignment = NSTextAlignment.left
        phoneNumberEdit.textColor = UIColor.white
        phoneNumberEdit.tintColor = UIColor.clear
        phoneNumberEdit.delegate = self
        phoneNumberEdit.clearButtonMode = .unlessEditing
        phoneNumberEdit.text = "17600860082"
        addSubview(phoneNumberEdit)
        
        phoneNumberEdit.snp.makeConstraints { (make) in
            make.centerY.equalTo(phoneNumberLabel)
            make.height.equalTo(phoneNumberLabel).offset(20)
            make.left.equalTo(phoneNumberLabel).offset(phoneNumberLabel.bounds.width + 5)
            make.right.equalTo(backgroundImage).offset(-30)
        }
        
        // 验证码文字
        let verifyLabel = MainCustomerLabel()
        verifyLabel.outTextColor = UIColor.white
        verifyLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        verifyLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        verifyLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        verifyLabel.text = "验证码:"
        verifyLabel.sizeToFit()
        addSubview(verifyLabel)
        
        verifyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumberLabel).offset(phoneNumberLabel.bounds.height + 20 + 10)
            make.right.equalTo(phoneNumberLabel)
        }
        
        // 验证码发送按钮
        verifySendBtn.setBackgroundImage(UIImage(named: "login_send"), for: .normal)
        verifySendBtn.setTitle("发送", for: .normal)
        verifySendBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(12))
        verifySendBtn.sizeToFit()
        addSubview(verifySendBtn)
        
        verifySendBtn.snp.makeConstraints { (make) in
            make.right.equalTo(phoneNumberEdit)
            make.centerY.equalTo(verifyLabel)
        }
        
        verifySendBtn.addTarget(self, action: #selector(sendVerifyCode), for: .touchUpInside)
        
        // 验证码输入框
        verifyCodeEdit.background = UIImage(named: "phone_number_background")
        verifyCodeEdit.outTextColor = UIColor.white
        verifyCodeEdit.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        verifyCodeEdit.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        verifyCodeEdit.placeholder = "验证码"
        verifyCodeEdit.font = UIFont.systemFont(ofSize: CGFloat(12))
        verifyCodeEdit.keyboardType = .numberPad
        verifyCodeEdit.textAlignment = NSTextAlignment.left
        verifyCodeEdit.textColor = UIColor.white
        verifyCodeEdit.tintColor = UIColor.clear
        verifyCodeEdit.clearButtonMode = .unlessEditing
        verifyCodeEdit.delegate = self
        verifyCodeEdit.text = "888888"
        addSubview(verifyCodeEdit)
        
        verifyCodeEdit.snp.makeConstraints { (make) in
            make.centerY.equalTo(verifyLabel)
            make.height.equalTo(verifyLabel).offset(20)
            make.left.equalTo(phoneNumberEdit)
            make.right.equalTo(verifySendBtn).offset(-(verifySendBtn.bounds.width + 5))
        }
        
        // login 按钮
        loginBtn.setBackgroundImage(UIImage(named: "now_login"), for: .normal)
        loginBtn.sizeToFit()
        addSubview(loginBtn)
        
        loginBtn.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(35)
            make.bottom.equalTo(backgroundImage).offset(35/2)
            make.centerX.equalTo(backgroundImage)
        }
        
        loginBtn.addTarget(self, action: #selector(loginByPhoneNumber), for: .touchUpInside)
        
        addDialogToWindow()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
    
    /// 倒计时
    fileprivate var countdownTimer: Timer?
    
    private var remainingSeconds: Int = 0 {
        willSet {
            verifySendBtn.setTitle("\(newValue)s", for: .normal)
            
            if newValue <= 0 {
                verifySendBtn.setTitle("发送", for: .normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                
                remainingSeconds = 60
                verifySendBtn.setTitleColor(UIColor.gray, for: .normal)
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                verifySendBtn.setTitleColor(UIColor.white, for: .normal)
            }
            
            verifySendBtn.isEnabled = !newValue
        }
    }
    
    override func hide() {
        super.hide()
        isCounting = false
        if self.fastLoginDialog != nil {
            self.fastLoginDialog.hide()
        }
    }
    
    @objc private func updateTime() {
        remainingSeconds -= 1
    }
    
}


// MARK: - 手机号登录
extension PhoneNumberDialog{
    
    // 手机号登录
    func loginByPhoneNumber() -> () {
        if (phoneNumberEdit.text?.characters.count)! <= 0 {
            ToastUtils.showErrorToast(msg: "请输入手机号")
            return
        }
        if (verifyCodeEdit.text?.characters.count)! <= 0 {
            ToastUtils.showErrorToast(msg: "请输入验证码")
            return
        }
        
        ToastUtils.showLoadingToast(msg: "登录中……")
        
        var params = NetWorkUtils.createBaseParams()
        params["code"] = verifyCodeEdit.text
        params["phone"] = phoneNumberEdit.text
        
        Alamofire.request(Constants.Network.PHONE_NUMBER_LOGIN, method: .post, parameters: params).responseJSON { (response) in
            if response.error == nil && response.data != nil {
//                SVProgressHUD.dismiss()
                let resultJson = JSON(data: response.data!)
                if NetWorkUtils.checkReponse(response: response) {
                    print("response:\(String(describing: response.result.value))")
                    LocalDataUtils.updateLocalUserData(resultData: resultJson, dataResponse:response)
                    ToastUtils.showSuccessToast(msg: "登录成功")
                    self.hide()
                    
                    if resultJson["data"]["new"].boolValue {
                        self.showFirstLoginReward()
                    }
                }
            }
        }
    }
    
    /// 显示新手第一次登录的奖励
    func showFirstLoginReward() -> () {
        firstLoginReward.createView()
        firstLoginReward.show()
    }
    
}

// MARK: - 发送验证码
extension PhoneNumberDialog{
    
    // 发送验证码
    func sendVerifyCode() -> () {
        if (phoneNumberEdit.text?.characters.count)! <= 0 {
            ToastUtils.showErrorToast(msg: "请输入手机号")
            return
        }
        var params = NetWorkUtils.createBaseParams()
        params["phone"] = phoneNumberEdit.text
        Alamofire.request(Constants.Network.SEND_VERIFY_CODE, method: .post, parameters: params).responseJSON { (response) in
            if response.error == nil && response.data != nil {
                let json = JSON(data: response.data!)
                if json["code"].int == 0 {
                    self.endEditing(true)
                    ToastUtils.showSuccessToast(msg: "发送成功")
                    // 开始倒计时
                    self.isCounting = true
                }
            }
        }
    }
}

// MARK: - 文字输入框的代理
extension PhoneNumberDialog:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == self.phoneNumberEdit) {
            let existedLength = textField.text?.characters.count;
            let selectedLength = range.length;
            let replaceLength = string.characters.count;
            
            if (existedLength! - selectedLength + replaceLength >= 12) {
                let endIndex = textField.text?.index((textField.text?.startIndex)!, offsetBy: 11)
                
                textField.text = textField.text?.substring(with: Range<String.Index>(uncheckedBounds: ((textField.text?.startIndex)!, endIndex!)))
                return false
            }
        }
        
        if textField == self.verifyCodeEdit {
            let existedLength = textField.text?.characters.count;
            let selectedLength = range.length;
            let replaceLength = string.characters.count;
            
            if (existedLength! - selectedLength + replaceLength >= 7) {
                let endIndex = textField.text?.index((textField.text?.startIndex)!, offsetBy: 6)
                
                textField.text = textField.text?.substring(with: Range<String.Index>(uncheckedBounds: ((textField.text?.startIndex)!, endIndex!)))
                return false
            }
        }
        return true
    }
    
}












