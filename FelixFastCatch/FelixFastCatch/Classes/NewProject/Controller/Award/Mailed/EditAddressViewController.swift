//
//  EditAddressViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/30.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class EditAddressViewController: BaseActionBarViewController {
    
    let addressNameTextField = UITextField()
    let addressPhoneTextField = UITextField()
    let addressInfoTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionTitleLabel.text = "修改地址"
        
        let groupView = UIView()
        groupView.backgroundColor = UIColor.white
        
        let addressNameLabel = UILabel.init()
        addressNameLabel.text = "收件人"
        addressNameLabel.textColor = UIColor.gray
        addressNameLabel.font = UIFont.systemFont(ofSize: 16)
        addressNameLabel.sizeToFit()
        addressNameLabel.frame.origin = CGPoint.init(x: 18, y: 50/2 - addressNameLabel.bounds.height/2)
        groupView.addSubview(addressNameLabel)
        
        addressNameTextField.placeholder = "请输入收件人名称"
        addressNameTextField.text = Constants.User.addrName
        addressNameTextField.frame.size = CGSize.init(width: UIScreen.main.bounds.width - 18 * 2 - 10, height: 50)
        groupView.addSubview(addressNameTextField)
        
        let line1 = UIView.init()
        line1.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 1)
        line1.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        line1.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width * 0.05, y: 51)
        groupView.addSubview(line1)
        
        let addressPhoneNumberLabel = UILabel.init()
        addressPhoneNumberLabel.text = "联系电话"
        addressPhoneNumberLabel.textColor = UIColor.gray
        addressPhoneNumberLabel.font = UIFont.systemFont(ofSize: 16)
        addressPhoneNumberLabel.sizeToFit()
        addressPhoneNumberLabel.frame.origin = CGPoint.init(x: 18, y: 50/2 - addressPhoneNumberLabel.bounds.height/2 + 51)
        groupView.addSubview(addressPhoneNumberLabel)

        addressPhoneTextField.placeholder = "请输入收件人手机号"
        addressPhoneTextField.keyboardType = .phonePad
        addressPhoneTextField.text = Constants.User.addrPhone
        addressPhoneTextField.frame.size = CGSize.init(width: UIScreen.main.bounds.width - 18 * 2 - 10, height: 50)
        addressNameTextField.frame.origin = CGPoint.init(x: 18 + addressPhoneNumberLabel.bounds.width + 15, y: 0)
        addressPhoneTextField.frame.origin = CGPoint.init(x: 18 + addressPhoneNumberLabel.bounds.width + 15, y: 51)
        groupView.addSubview(addressPhoneTextField)
        
        let line2 = UIView.init()
        line2.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 1)
        line2.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        line2.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width * 0.05, y: 51 * 2)
        groupView.addSubview(line2)
        
        let addressInfoLabel = UILabel.init()
        addressInfoLabel.text = "详细地址"
        addressInfoLabel.textColor = UIColor.gray
        addressInfoLabel.font = UIFont.systemFont(ofSize: 16)
        addressInfoLabel.sizeToFit()
        addressInfoLabel.frame.origin = CGPoint.init(x: 18, y: 50/2 - addressPhoneNumberLabel.bounds.height/2 + 51 * 2)
        groupView.addSubview(addressInfoLabel)
        
        addressInfoTextField.placeholder = "请输入详细收件地址"
        addressInfoTextField.text = Constants.User.addr
        addressInfoTextField.frame.size = CGSize.init(width: UIScreen.main.bounds.width - 18 * 2 - 10, height: 50)
        addressInfoTextField.frame.origin = CGPoint.init(x: 18 + addressPhoneNumberLabel.bounds.width + 15, y: 51 * 2)
        groupView.addSubview(addressInfoTextField)
        
        groupView.frame = CGRect.init(x: 0, y: headView.bounds.height + 10, width: UIScreen.main.bounds.width, height: 155)
        view.addSubview(groupView)
        
        let saveButton = UIButton.init(type: .custom)
        saveButton.setBackgroundImage(UIImage.init(named: "确认地址"), for: UIControlState.normal)
        saveButton.sizeToFit()
        view.addSubview(saveButton)
        
        saveButton.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width/2 - saveButton.bounds.width/2, y: groupView.bounds.height + groupView.frame.origin.y + 30)
        
        saveButton.addTarget(self, action: #selector(saveAddress), for: UIControlEvents.touchUpInside)
    }
    
    /// 保存地址
    @objc func saveAddress() -> () {
        if !checkAddressEdit() {
            return
        }
        
        ToastUtils.showLoadingToast(msg: "正在保存中")
        
        var params = NetWorkUtils.createBaseParams()
        params["addr"] = addressInfoTextField.text
        params["name"] = addressNameTextField.text
        params["phone"] = addressPhoneTextField.text
        
        if Constants.User.addressId != "0" {
            params["id"] = Constants.User.addressId
        }
        
        Alamofire.request(Constants.Network.Gift.SAVE_USER_ADDRESS, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                ToastUtils.showSuccessToast(msg: "修改成功")
                let json = JSON(response.result.value!)
                
                /// 更新内存中的数据
                Constants.User.addrName = params["name"]!
                Constants.User.addrPhone = params["phone"]!
                Constants.User.addr = params["addr"]!
                Constants.User.addressId = json["data"]["id"].stringValue
                
                self.back()
            }else{
                ToastUtils.showErrorToast(msg: "保存失败!")
            }
        }
    }
    
    /// 检查地址填写
    func checkAddressEdit() -> Bool {
        if (addressNameTextField.text?.count)! <= 0 {
            ToastUtils.showErrorToast(msg: "请输入收件人")
            return false
        }
        if (addressPhoneTextField.text?.count)! <= 0 {
            ToastUtils.showErrorToast(msg: "请输入手机号")
            return false
        }
        if (addressPhoneTextField.text?.count)! < 11 {
            ToastUtils.showErrorToast(msg: "请输入正确长度的手机号")
            return false
        }
        if (addressInfoTextField.text?.count)! <= 0 {
            ToastUtils.showErrorToast(msg: "请输入地址")
            return false
        }
        return true
    }

}
