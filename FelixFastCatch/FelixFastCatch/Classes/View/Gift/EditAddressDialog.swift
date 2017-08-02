//
//  EditAddressDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/2.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire

class EditAddressDialog: BaseDialog {

    var userName = ""
    
    var phoneNumber = ""
    
    var address = ""
    
    fileprivate lazy var userNameTextField:MainCustomerTextField = MainCustomerTextField()
    
    fileprivate lazy var phoneNumberTextField:MainCustomerTextField = MainCustomerTextField()
    
    fileprivate lazy var addressTextFiled:MainCustomerTextField = MainCustomerTextField()
    
    fileprivate lazy var userNameLabel:MainCustomerLabel = MainCustomerLabel()
    
    fileprivate lazy var phoneNumberLabel:MainCustomerLabel = MainCustomerLabel()
    
    fileprivate lazy var addressLabel:MainCustomerLabel = MainCustomerLabel()
    
    /// 保存按钮
    fileprivate lazy var saveBtn:UIButton = UIButton(type: UIButtonType.custom)
    
    /// 取消按钮
    fileprivate lazy var cancelBtn:UIButton = UIButton(type: UIButtonType.custom)
    
    fileprivate var myGiftDialog:MyGiftDialog!
    
    override func createView() {
        
        createBackgroundImage(imageName: "邮寄地址填写背景")
        
        
        createCloseBtn()
        
        /// 收件人填写
        userNameLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        userNameLabel.outTextColor = UIColor.white
        userNameLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        userNameLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        userNameLabel.text = "姓名:"
        userNameLabel.textAlignment = .right
        userNameLabel.sizeToFit()
        addSubview(userNameLabel)
        
        userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundImage).offset(20)
            make.top.equalTo(backgroundImage).offset(65)
        }
        
        /// 收件人输入框
        userNameTextField.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        userNameTextField.outTextColor = UIColor.white
        userNameTextField.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        userNameTextField.font = UIFont.systemFont(ofSize: CGFloat(12))
        userNameTextField.placeholder = "请输入姓名"
        userNameTextField.background = UIImage(named: "邮寄地址输入框")
        userNameTextField.textColor = UIColor.white
        userNameTextField.clearButtonMode = .unlessEditing
        addSubview(userNameTextField)
        
        userNameTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(userNameLabel)
            make.left.equalTo(userNameLabel).offset(userNameLabel.bounds.width + 5)
            make.right.equalTo(backgroundImage).offset(-20)
            make.height.equalTo(userNameLabel).offset(20)
        }
        
        /// 电话填写
        phoneNumberLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        phoneNumberLabel.outTextColor = UIColor.white
        phoneNumberLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        phoneNumberLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        phoneNumberLabel.text = "手机:"
        phoneNumberLabel.sizeToFit()
        addSubview(phoneNumberLabel)
        
        phoneNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userNameLabel)
            make.width.equalTo(userNameLabel)
            make.right.equalTo(userNameLabel)
            make.bottom.equalTo(userNameTextField).offset(phoneNumberLabel.bounds.height + 20)
        }
        
        /// 电话输入框
        phoneNumberTextField.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        phoneNumberTextField.outTextColor = UIColor.white
        phoneNumberTextField.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        phoneNumberTextField.font = UIFont.systemFont(ofSize: CGFloat(12))
        phoneNumberTextField.placeholder = "请输入手机"
        phoneNumberTextField.background = UIImage(named: "邮寄地址输入框")
        phoneNumberTextField.textColor = UIColor.white
        phoneNumberTextField.clearButtonMode = .unlessEditing
        phoneNumberTextField.keyboardType = .phonePad
        addSubview(phoneNumberTextField)
        
        phoneNumberTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(phoneNumberLabel)
            make.left.equalTo(userNameTextField)
            make.right.equalTo(userNameTextField)
            make.height.equalTo(phoneNumberLabel).offset(20)
        }
        
        /// 收件人填写
        addressLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        addressLabel.outTextColor = UIColor.white
        addressLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        addressLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        addressLabel.text = "地址:"
        addressLabel.sizeToFit()
        addSubview(addressLabel)
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userNameLabel)
            make.width.equalTo(userNameLabel)
            make.right.equalTo(userNameLabel)
            make.bottom.equalTo(phoneNumberTextField).offset(addressLabel.bounds.height + 20)
        }
        
        /// 地址输入框
        addressTextFiled.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        addressTextFiled.outTextColor = UIColor.white
        addressTextFiled.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        addressTextFiled.font = UIFont.systemFont(ofSize: CGFloat(12))
        addressTextFiled.placeholder = "请输入地址"
        addressTextFiled.background = UIImage(named: "邮寄地址输入框")
        addressTextFiled.textColor = UIColor.white
        addressTextFiled.clearButtonMode = .unlessEditing
        addSubview(addressTextFiled)
        
        addressTextFiled.snp.makeConstraints { (make) in
            make.centerY.equalTo(addressLabel)
            make.left.equalTo(userNameTextField)
            make.right.equalTo(userNameTextField)
            make.height.equalTo(addressLabel).offset(20)
        }
        
        /// 保存按钮
        saveBtn.setImage(UIImage(named:"确认填写"), for: .normal)
        saveBtn.sizeToFit()
        addSubview(saveBtn)
        
        saveBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImage).offset(saveBtn.bounds.height/2)
            make.left.equalTo(backgroundImage).offset(backgroundImage.bounds.width/2 + 15)
        }
        
        saveBtn.addTarget(self, action: #selector(saveAddress), for: .touchUpInside)
        
        /// 取消按钮
        cancelBtn.setImage(UIImage(named: "取消填写"), for: .normal)
        cancelBtn.sizeToFit()
        addSubview(cancelBtn)
        
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImage).offset(cancelBtn.bounds.height/2)
            make.left.equalTo(backgroundImage).offset(backgroundImage.bounds.width/2 - cancelBtn.bounds.width - 15)
        }
        
        cancelBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        initAddressInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbFrameChanged(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
        addDialogToWindow()
    }
    
    func createView(dialog:MyGiftDialog) {
        self.myGiftDialog = dialog
        createView()
    }
    
    func kbFrameChanged(_ notification : Notification){
        let info = notification.userInfo
        let kbRect = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        var offsetY:CGFloat
        if kbRect.origin.y >= UIScreen.main.bounds.height {
            //键盘隐藏了
            offsetY = 0
        }else{
            offsetY = kbRect.origin.y - UIScreen.main.bounds.height + backgroundImage.bounds.height
        }
        
        print("off:\(kbRect.origin.y) , \(offsetY), \(UIScreen.main.bounds.height)")
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.transform = CGAffineTransform(translationX: 0, y: offsetY)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }

}

// MARK: - 保存
extension EditAddressDialog{
    
    /// 保存地址
    func saveAddress() -> () {
        if !checkAddressEdit() {
            return
        }
        
        ToastUtils.showLoadingToast(msg: "正在保存中")
        
        var params = NetWorkUtils.createBaseParams()
        params["addr"] = addressTextFiled.text
        params["name"] = userNameTextField.text
        params["phone"] = phoneNumberTextField.text
        
        Alamofire.request(Constants.Network.Gift.CREATE_POSTAGE, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                ToastUtils.showSuccessToast(msg: "保存成功!")
                
                if self.myGiftDialog != nil {
                    self.myGiftDialog.reBackShowMailedConfirm(userInfo: self.userNameTextField.text!, phoneNumber: self.phoneNumberTextField.text!, address: self.addressTextFiled.text!)
                }
                
                self.hide()
            }else{
                ToastUtils.showErrorToast(msg: "保存失败!")
            }
        }
    }
    
    /// 检查地址填写
    func checkAddressEdit() -> Bool {
        if (userNameTextField.text?.characters.count)! <= 0 {
            ToastUtils.showErrorToast(msg: "请输入收件人")
            return false
        }
        if (phoneNumberTextField.text?.characters.count)! <= 0 {
            ToastUtils.showErrorToast(msg: "请输入手机号")
            return false
        }
        if (addressTextFiled.text?.characters.count)! <= 0 {
            ToastUtils.showErrorToast(msg: "请输入地址")
            return false
        }
        return true
    }
    
    /// 首次进入界面，填充信息
    func initAddressInfo() -> () {
        if userName != "" {
            userNameTextField.text = userName
        }
        
        if phoneNumber != "" {
            phoneNumberTextField.text = phoneNumber
        }
        
        if address != "" {
            addressTextFiled.text = address
        }
    }
    
}












