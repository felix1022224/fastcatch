//
//  EditUserInfo.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/31.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import Alamofire

class EditUserInfo: BaseActionBarViewController {

    let ladyButton = UIButton.init(type: UIButtonType.custom)
    let manButton = UIButton.init(type: UIButtonType.custom)
    
    var selectDateTime:SelectDateView!
    
    let brithdaySelectedLabel = UILabel.init()
    
    let nickTextFiled = UITextField.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionTitleLabel.text = "编辑资料"
        
        let centerGroupView = UIView.init()
        centerGroupView.backgroundColor = UIColor.white
        centerGroupView.frame = CGRect.init(x: 0, y: headView.bounds.height + 5, width: UIScreen.main.bounds.width, height: 51*3)
        view.addSubview(centerGroupView)
        
        let nickGroupView = UIView.init()
        nickGroupView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        centerGroupView.addSubview(nickGroupView)
        
        let nickLabel = UILabel.init()
        nickLabel.text = "昵 称"
        nickLabel.font = UIFont.systemFont(ofSize: 16)
        nickLabel.sizeToFit()
        nickLabel.frame.origin = CGPoint.init(x: 15, y: nickGroupView.bounds.height/2 - nickLabel.bounds.height/2)
        nickGroupView.addSubview(nickLabel)
        
        
        nickTextFiled.frame = CGRect.init(x: nickLabel.bounds.width + 30, y: 0, width: UIScreen.main.bounds.width - nickLabel.bounds.width - 45, height: 50)
        nickTextFiled.placeholder = "请输入昵称"
        nickTextFiled.text = Constants.User.USER_NICK_NAME
        nickGroupView.addSubview(nickTextFiled)
        
        let line1View = UIView.init()
        line1View.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        line1View.frame = CGRect.init(x: UIScreen.main.bounds.width * 0.05, y: 50, width: UIScreen.main.bounds.width * 0.9, height: 1)
        centerGroupView.addSubview(line1View)
        
        /// 性别
        let sexGroupView = UIView.init()
        sexGroupView.frame = CGRect.init(x: 0, y: 51, width: UIScreen.main.bounds.width, height: 50)
        centerGroupView.addSubview(sexGroupView)
        
        let sexLabel = UILabel.init()
        sexLabel.text = "性 别"
        sexLabel.font = UIFont.systemFont(ofSize: 16)
        sexLabel.sizeToFit()
        sexLabel.frame.origin = CGPoint.init(x: 15, y: sexGroupView.bounds.height/2 - sexLabel.bounds.height/2)
        sexGroupView.addSubview(sexLabel)
        
        ladyButton.setBackgroundImage(UIImage.init(named: "未选女生"), for: UIControlState.normal)
        ladyButton.setBackgroundImage(UIImage.init(named: "选中女生"), for: UIControlState.selected)
        ladyButton.sizeToFit()
        ladyButton.frame.origin = CGPoint.init(x: sexLabel.frame.origin.x + sexLabel.bounds.width + 15, y: sexGroupView.bounds.height/2 - ladyButton.bounds.height/2)
        sexGroupView.addSubview(ladyButton)
        
        manButton.setBackgroundImage(UIImage.init(named: "未选男生"), for: UIControlState.normal)
        manButton.setBackgroundImage(UIImage.init(named: "选中男生"), for: UIControlState.selected)
        manButton.sizeToFit()
        manButton.frame.origin = CGPoint.init(x: ladyButton.frame.origin.x + ladyButton.bounds.width + 15, y: sexGroupView.bounds.height/2 - manButton.bounds.height/2)
        sexGroupView.addSubview(manButton)
        
        manButton.addTarget(self, action: #selector(switchSex(sender:)), for: UIControlEvents.touchUpInside)
        ladyButton.addTarget(self, action: #selector(switchSex(sender:)), for: UIControlEvents.touchUpInside)
        
        let line2View = UIView.init()
        line2View.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        line2View.frame = CGRect.init(x: UIScreen.main.bounds.width * 0.05, y: 51 * 2, width: UIScreen.main.bounds.width * 0.9, height: 1)
        centerGroupView.addSubview(line2View)
        
        /// 生日
        let brithdayGroupView = UIView.init()
        brithdayGroupView.frame = CGRect.init(x: 0, y: 51*2, width: UIScreen.main.bounds.width, height: 50)
        centerGroupView.addSubview(brithdayGroupView)
        
        let brithdayLabel = UILabel.init()
        brithdayLabel.text = "生 日"
        brithdayLabel.font = UIFont.systemFont(ofSize: 16)
        brithdayLabel.sizeToFit()
        brithdayLabel.frame.origin = CGPoint.init(x: 15, y: brithdayGroupView.bounds.height/2 - sexLabel.bounds.height/2)
        brithdayGroupView.addSubview(brithdayLabel)
        
        brithdaySelectedLabel.font = UIFont.systemFont(ofSize: 16)
        if Constants.User.USER_BRITHDAY == "" {
            brithdaySelectedLabel.text = "请选择您的生日"
            brithdaySelectedLabel.textColor = UIColor.gray
        }else{
            brithdaySelectedLabel.text = Constants.User.USER_BRITHDAY
            brithdaySelectedLabel.textColor = UIColor.black
        }
        brithdaySelectedLabel.sizeToFit()
        brithdaySelectedLabel.frame.origin = CGPoint.init(x: 30 + brithdayLabel.bounds.width, y: brithdayGroupView.bounds.height/2 - brithdaySelectedLabel.bounds.height/2)
        brithdayGroupView.addSubview(brithdaySelectedLabel)
        
        let saveButton = UIButton.init(type: UIButtonType.custom)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.setBackgroundImage(UIImage.init(named: "退出登录背景"), for: UIControlState.normal)
        saveButton.setTitle("保 存", for: UIControlState.normal)
        saveButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        saveButton.sizeToFit()
        saveButton.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width/2 - saveButton.bounds.width/2, y: centerGroupView.bounds.height + 30 + centerGroupView.frame.origin.y)
        
        view.addSubview(saveButton)
        
        saveButton.addTarget(self, action: #selector(saveUserInfo), for: UIControlEvents.touchUpInside)
        
        if Constants.User.USER_SEX == "1" || Constants.User.USER_SEX == "-1"{
            manButton.isSelected = false
            ladyButton.isSelected = true
        }else{
            manButton.isSelected = true
            ladyButton.isSelected = false
        }
        
        brithdayGroupView.isUserInteractionEnabled = true
        let tapBirthday = UITapGestureRecognizer.init(target: self, action: #selector(selectBrithDayDate))
        brithdayGroupView.addGestureRecognizer(tapBirthday)
    }
    
    @objc func selectBrithDayDate() {
        view.endEditing(true)
        selectDateTime = nil
        selectDateTime = SelectDateView(frame: UIScreen.main.bounds)
        selectDateTime.createView()
        selectDateTime.show2 { [weak self] in
            // 选择了时间
            self?.brithdaySelectedLabel.text = self?.selectDateTime.selectTime
        }
    }
    
    /// 保存用户信息
    @objc func saveUserInfo() -> () {
        if !checkUserInfo() {
            return
        }
        
        var params = NetWorkUtils.createBaseParams()
        params["id"] = Constants.User.USER_ID
        params["nick"] = nickTextFiled.text
        if manButton.isSelected {
            params["gender"] = "0"
        }else{
            params["gender"] = "1"
        }
        params["birthday"] = brithdaySelectedLabel.text
        
        Alamofire.request(Constants.Network.User.UPDATE_USER_INFO, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                ToastUtils.showSuccessToast(msg: "保存成功")
                self.back()
            }
        }
        
    }
    
    /// 检查用户信息
    func checkUserInfo() -> Bool {
        if (nickTextFiled.text?.count)! <= 0 {
            ToastUtils.showErrorToast(msg: "请输入昵称")
            return false
        }
        if (brithdaySelectedLabel.text == "请选择您的生日") {
            ToastUtils.showErrorToast(msg: "请选择您的生日")
            return false
        }
        return true
    }
    
    @objc func switchSex(sender:UIButton) {
        if sender == manButton {
            manButton.isSelected = true
            ladyButton.isSelected = false
        }else{
            manButton.isSelected = false
            ladyButton.isSelected = true
        }
    }
    
}
