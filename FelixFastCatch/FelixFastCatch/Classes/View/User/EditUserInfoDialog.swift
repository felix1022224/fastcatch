//
//  EditUserInfoDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/2.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire

class EditUserInfoDialog: BaseDialog {

    // 取消按钮
    fileprivate var cancelBtn:UIButton!
    
    // 保存按钮
    fileprivate var saveBtn:UIButton!
    
    // 用户昵称
    fileprivate var nickNameLabel:MainCustomerLabel!
    
    // 昵称输入框
    fileprivate var nickNameEdit:MainCustomerTextField!
    
    // 性别的label
    fileprivate var sexLabel:MainCustomerLabel!
    
    // 生日label
    fileprivate var brithdayTipsLabel:MainCustomerLabel!
    
    // 生日选择
    fileprivate var brithdaySelectGroup:MainCustomerLabel!
    
    // 生日文字
    fileprivate var brithdaySelectLabel:MainCustomerLabel!
    
    fileprivate var manBtn:UIButton!
    fileprivate var ladyBtn:UIButton!
    
    fileprivate var isSelectMan:Bool = false
    
    fileprivate var selectDateTime:SelectDateView!
    
    var callback:((_ nick:String, _ sex:String, _ brithday:String)->())? = nil
    
    override func createView() {
        createBackgroundImage(imageName: "bg_change_userinfo")
        
        selectDateTime = SelectDateView(frame: self.bounds)
        
        
        // 取消按钮
        let cancelImage = UIImage(named: "icon_cancel")
        
        cancelBtn = UIButton(type: .custom)
        cancelBtn.setBackgroundImage(cancelImage, for: .normal)
        cancelBtn.frame = CGRect(x: self.bounds.width/2 - (cancelImage?.size.width)! - 20, y: self.bounds.height/2 + backgroundImage.bounds.height/2 - (cancelImage?.size.height)! / 2, width: (cancelImage?.size.width)!, height: (cancelImage?.size.height)!)
        addSubview(cancelBtn)
        
        cancelBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        // 保存按钮
        let saveImage = UIImage(named: "icon_save")
        
        saveBtn = UIButton(type: .custom)
        saveBtn.setBackgroundImage(saveImage, for: .normal)
        saveBtn.frame = CGRect(x: self.bounds.width/2 + 20, y: self.bounds.height/2 + backgroundImage.bounds.height/2 - (saveImage?.size.height)! / 2, width: (saveImage?.size.width)!, height: (saveImage?.size.height)!)
        addSubview(saveBtn)
        
        saveBtn.addTarget(self, action: #selector(saveUserInfo), for: .touchUpInside)
        
        // 用户昵称
        nickNameLabel = MainCustomerLabel()
        nickNameLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        nickNameLabel.outTextColor = UIColor.white
        nickNameLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        nickNameLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(14))
        nickNameLabel.text = "昵称:"
        nickNameLabel.frame = CGRect(x: self.bounds.width/2 - backgroundImage.bounds.width/2 + 35, y: self.bounds.height/2 - backgroundImage.bounds.height/2 + 55, width: 0, height: 0)
        nickNameLabel.sizeToFit()
        addSubview(nickNameLabel)
        
        // 用户昵称输入框
        nickNameEdit = MainCustomerTextField()
        nickNameEdit.background = UIImage(named: "bg_username")
        nickNameEdit.sizeToFit()
        nickNameEdit.textColor = UIColor.white
        nickNameEdit.tintColor = UIColor.clear
        nickNameEdit.outLineWidth = 1
        nickNameEdit.outTextColor = UIColor.white
        nickNameEdit.outLienTextColor = UIColor.black
        nickNameEdit.textAlignment = NSTextAlignment.left
        nickNameEdit.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        nickNameEdit.placeholder = "请输入昵称"
        nickNameEdit.text = Constants.User.USER_NICK_NAME
        //        nickNameEdit.delegate = self
        addSubview(nickNameEdit)
        
        nickNameEdit.snp.makeConstraints { (make) in
            make.centerY.equalTo(nickNameLabel)
            make.height.equalTo(nickNameLabel).offset(10)
            make.left.equalTo(nickNameLabel).offset(nickNameLabel.bounds.width + 10)
            make.right.equalTo(backgroundImage).offset(-40)
        }
        nickNameEdit.isUserInteractionEnabled = true
        
        addDialogToWindow()
        
        // 性别的label
        sexLabel = MainCustomerLabel()
        sexLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        sexLabel.outTextColor = UIColor.white
        sexLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        sexLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(14))
        sexLabel.text = "性别:"
        sexLabel.sizeToFit()
        addSubview(sexLabel)
        
        sexLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nickNameLabel)
            make.top.equalTo(nickNameLabel).offset(nickNameLabel.bounds.height + 25)
        }
        
        // 男
        let manImage = UIImage(named: "sex_man_normal")
        
        manBtn = UIButton()
        manBtn.setBackgroundImage(manImage, for: .normal)
        manBtn.setBackgroundImage(manImage, for: .highlighted)
        manBtn.setBackgroundImage(UIImage(named: "sex_man_selector"), for: .selected)
        manBtn.sizeToFit()
        addSubview(manBtn)
        
        manBtn.addTarget(self, action: #selector(changeSex), for: .touchUpInside)
        
        manBtn.snp.makeConstraints { (make) in
            make.left.equalTo(nickNameEdit)
            make.centerY.equalTo(sexLabel)
        }
        
        // 女
        ladyBtn = UIButton()
        ladyBtn.setBackgroundImage(UIImage(named: "sex_lady_normal"), for: .normal)
        ladyBtn.setBackgroundImage(UIImage(named: "sex_lady_normal"), for: .highlighted)
        ladyBtn.setBackgroundImage(UIImage(named: "sex_lady_selector"), for: .selected)
        ladyBtn.sizeToFit()
        addSubview(ladyBtn)
        
        ladyBtn.addTarget(self, action: #selector(changeSex), for: .touchUpInside)
        
        ladyBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(sexLabel)
            make.right.equalTo(nickNameEdit)
        }
        
        if Constants.User.USER_SEX == "1" {
            isSelectMan = true
            changeSex()
        }else{
            isSelectMan = false
            changeSex()
        }
        
        // 生日
        brithdayTipsLabel = MainCustomerLabel()
        brithdayTipsLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        brithdayTipsLabel.outTextColor = UIColor.white
        brithdayTipsLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        brithdayTipsLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(14))
        brithdayTipsLabel.text = "生日:"
        brithdayTipsLabel.sizeToFit()
        addSubview(brithdayTipsLabel)
        
        brithdayTipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sexLabel).offset(sexLabel.bounds.height + 25)
            make.left.equalTo(sexLabel)
        }
        
        /// 生日背景
        let brithdyBackgroundImage = UIImageView(image: UIImage(named: "bg_username"))
        addSubview(brithdyBackgroundImage)
        
        brithdyBackgroundImage.snp.makeConstraints { (make) in
            make.left.equalTo(manBtn)
            make.centerY.equalTo(brithdayTipsLabel)
            make.height.equalTo(brithdayTipsLabel).offset(10)
            make.right.equalTo(ladyBtn)
        }
        
        // 生日背景
        brithdaySelectGroup = MainCustomerLabel()
        brithdaySelectGroup.sizeToFit()
        brithdaySelectGroup.outLineWidth = 0
        brithdaySelectGroup.outTextColor = UIColor.white
        brithdaySelectGroup.outLienTextColor = UIColor.black
        addSubview(brithdaySelectGroup)
        brithdaySelectGroup.tintColor = UIColor.clear
        if Constants.User.USER_BRITHDAY == "" {
            brithdaySelectGroup.text = "请选择生日"
        }else{
            brithdaySelectGroup.text = Constants.User.USER_BRITHDAY
        }
        
        brithdaySelectGroup.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        brithdaySelectGroup.isUserInteractionEnabled = true
        
        brithdaySelectGroup.snp.makeConstraints { (make) in
            make.left.equalTo(manBtn).offset(20)
            make.centerY.equalTo(brithdayTipsLabel)
            make.height.equalTo(brithdayTipsLabel).offset(10)
            make.right.equalTo(ladyBtn)
        }
        
        //点击事件
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectDate))
        
        //绑定tap
        brithdaySelectGroup.addGestureRecognizer(tap)
        
    }
    
    func selectDate() -> () {
        endEditing(true)
        selectDateTime.createView()
        selectDateTime.show2 { [weak self] in
            // 选择了时间
            self?.brithdaySelectGroup.text = self?.selectDateTime.selectTime
        }
    }
    
//    //返回该view所在VC
//    func firstViewController() -> UIViewController? {
//        for view in sequence(first: self.superview, next: { $0?.superview }) {
//            if let responder = view?.next {
//                if responder.isKind(of: UIViewController.self){
//                    return responder as? UIViewController
//                }
//            }
//        }
//        return nil
//    }
    
    func changeSex() -> () {
        if isSelectMan {
            isSelectMan = false
            manBtn.isSelected = false
            ladyBtn.isSelected = true
            ladyBtn.isUserInteractionEnabled = false
            manBtn.isUserInteractionEnabled = true
        }else{
            isSelectMan = true
            manBtn.isSelected = true
            ladyBtn.isSelected = false
            ladyBtn.isUserInteractionEnabled = true
            manBtn.isUserInteractionEnabled = false
        }
    }

    func show2(action:@escaping (_ nick:String, _ sex:String, _ brithday:String)->()) {
        super.show()
        callback = action
    }
    
    /// 保存用户信息
    func saveUserInfo() -> () {
        if !checkUserInfo() {
            return
        }
        
        var params = NetWorkUtils.createBaseParams()
        params["id"] = Constants.User.USER_ID
        params["nick"] = nickNameEdit.text
        if isSelectMan {
            params["gender"] = "0"
        }else{
            params["gender"] = "1"
        }
        params["birthday"] = brithdaySelectGroup.text
        
        Alamofire.request(Constants.Network.User.UPDATE_USER_INFO, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                if self.callback != nil {
                    self.callback!(params["nick"]!, params["gender"]!, params["birthday"]!)
                }
                self.hide()
            }
        }
        
    }

    /// 检查用户信息
    func checkUserInfo() -> Bool {
        if (nickNameEdit.text?.characters.count)! <= 0 {
            ToastUtils.showErrorToast(msg: "请输入昵称")
            return false
        }
        if (brithdaySelectGroup.text == "请选择生日") {
            ToastUtils.showErrorToast(msg: "请选择生日")
            return false
        }
        return true
    }
}








