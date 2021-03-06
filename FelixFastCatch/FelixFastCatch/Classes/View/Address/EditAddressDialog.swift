//
//  EditAddressDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/2.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation

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
    
    fileprivate var mailedConfirm:FCMailedConfirmDialog!
    
        
    func createView(mailedConfirm:FCMailedConfirmDialog) {
        
        self.mailedConfirm = mailedConfirm
        
        createBackgroundImage(imageName: "邮寄地址填写背景")
        
        backgroundImage.frame.size = CGSize(width: 300, height: 230)
        backgroundImage.center = self.center
        
        createCloseBtn()
        
        /// 收件人填写
        userNameLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        userNameLabel.outTextColor = UIColor.white
        userNameLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        userNameLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
        userNameLabel.text = "姓名:"
        userNameLabel.textAlignment = .left
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
        userNameTextField.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
        userNameTextField.placeholder = "请输入姓名"
        userNameTextField.background = UIImage(named: "邮寄地址输入框")
        userNameTextField.textColor = UIColor.white
        userNameTextField.clearButtonMode = .unlessEditing
        addSubview(userNameTextField)
        
        userNameTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(userNameLabel)
            make.left.equalTo(userNameLabel).offset(userNameLabel.bounds.width)
            make.right.equalTo(backgroundImage).offset(-20)
            make.height.equalTo(userNameLabel).offset(20)
        }
        
        /// 电话填写
        phoneNumberLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        phoneNumberLabel.outTextColor = UIColor.white
        phoneNumberLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        phoneNumberLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
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
        phoneNumberTextField.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
        phoneNumberTextField.placeholder = "请输入手机"
        phoneNumberTextField.background = UIImage(named: "邮寄地址输入框")
        phoneNumberTextField.textColor = UIColor.white
        phoneNumberTextField.clearButtonMode = .unlessEditing
        phoneNumberTextField.keyboardType = .phonePad
        phoneNumberTextField.delegate = self
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
        addressLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
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
        addressTextFiled.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
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
    
    @objc func kbFrameChanged(_ notification : Notification){
        let info = notification.userInfo
        let kbRect = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        var offsetY:CGFloat
        if kbRect.origin.y >= UIScreen.main.bounds.height {
            //键盘隐藏了
            offsetY = 0
        }else{
            offsetY = kbRect.origin.y - UIScreen.main.bounds.height + backgroundImage.bounds.height
        }
        
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
    @objc func saveAddress() -> () {
        if !checkAddressEdit() {
            return
        }
        
        ToastUtils.showLoadingToast(msg: "正在保存中")
        
        var params = NetWorkUtils.createBaseParams()
        params["addr"] = addressTextFiled.text
        params["name"] = userNameTextField.text
        params["phone"] = phoneNumberTextField.text
        
        if Constants.User.addressId != "0" {
            params["id"] = Constants.User.addressId
        }
        
        Alamofire.request(Constants.Network.Gift.SAVE_USER_ADDRESS, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                ToastUtils.showSuccessToast(msg: "修改成功")
                
                if self.myGiftDialog != nil {
                    self.myGiftDialog.reBackShowMailedConfirm(userInfo: self.userNameTextField.text!, phoneNumber: self.phoneNumberTextField.text!, address: self.addressTextFiled.text!)
                }
                
                let json = JSON(response.result.value!)
                
                /// 更新内存中的数据
                Constants.User.addrName = params["name"]!
                Constants.User.addrPhone = params["phone"]!
                Constants.User.addr = params["addr"]!
                Constants.User.addressId = json["data"]["id"].stringValue
                
                self.mailedConfirm.reloadInfo()
                self.mailedConfirm = nil
                
                self.hide()
            }else{
                ToastUtils.showErrorToast(msg: "保存失败!")
            }
        }
    }
    
    /// 检查地址填写
    func checkAddressEdit() -> Bool {
        if (userNameTextField.text?.count)! <= 0 {
            ToastUtils.showErrorToast(msg: "请输入收件人")
            return false
        }
        if (phoneNumberTextField.text?.count)! <= 0 {
            ToastUtils.showErrorToast(msg: "请输入手机号")
            return false
        }
        if (phoneNumberTextField.text?.count)! < 11 {
            ToastUtils.showErrorToast(msg: "请输入正确长度的手机号")
            return false
        }
        if (addressTextFiled.text?.count)! <= 0 {
            ToastUtils.showErrorToast(msg: "请输入地址")
            return false
        }
        return true
    }
    
    /// 首次进入界面，填充信息
    func initAddressInfo() -> () {
        if Constants.User.addrName != "" {
            userNameTextField.text = Constants.User.addrName
        }
        
        if Constants.User.addrPhone != "" {
            phoneNumberTextField.text = Constants.User.addrPhone
        }
        
        if Constants.User.addr != "" {
            addressTextFiled.text = Constants.User.addr
        }
    }
    
}

// MARK: - 文字输入框的代理
extension EditAddressDialog:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == self.phoneNumberTextField) {
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
        
        return true
    }
    
}












