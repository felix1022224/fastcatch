//
//  UserInfoDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/31.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire

class UserInfoDialog: BaseDialog {

    // 用户Id
    fileprivate var userIdLabel:MainCustomerLabel = MainCustomerLabel()
    
    // 用户昵称
    fileprivate var userNickName:MainCustomerLabel = MainCustomerLabel()
    
    // 星座
    fileprivate var constellationLabel:MainCustomerLabel = MainCustomerLabel()
    
    // 性别
    fileprivate var sexLabel:MainCustomerLabel = MainCustomerLabel()
    
    // 退出登录
    fileprivate var logoutBtn:UIButton!
    
    // 编辑资料
    fileprivate var changeInfoBtn:UIButton!
    
    // 编辑资料dialog
//    fileprivate var changeUserInfoDialog:FCChanageUserInfoView!
    
    // 用户头像
    fileprivate var userFaceImageView:UIImageView!
    
    // 用户头像背景图
    fileprivate var userFaceImageBackground:UIImageView!
    
    /// 编辑用户资料
    fileprivate var editUserInfoDialog:EditUserInfoDialog!
    
    override func createView() {
        editUserInfoDialog = EditUserInfoDialog(frame: UIScreen.main.bounds)
        
        let bgImage = UIImage(named: "bg_user_info")
        
        backgroundImage = UIImageView()
        backgroundImage.image = bgImage
        backgroundImage.sizeToFit()
//        backgroundImage.frame = CGRect(x: self.bounds.width/2 - (bgImage?.size.width)! * 1.3 / 2, y: self.bounds.height/2 - (bgImage?.size.height)! * 1.3 / 2, width: (bgImage?.size.width)! * 1.3, height: (bgImage?.size.height)! * 1.3)
        backgroundImage.frame.size = CGSize(width: 290, height: 218)
        backgroundImage.center = self.center
        addSubview(backgroundImage)
        
        createCloseBtn()
        
        // 背景图
        let userFaceBorderImage = UIImage(named: "user_face_border")
        userFaceImageBackground = UIImageView()
        userFaceImageBackground.image = userFaceBorderImage
        userFaceImageBackground.frame = CGRect(x: self.bounds.width/2 - backgroundImage.bounds.width/2 + 54, y: self.bounds.height/2 - backgroundImage.bounds.height/2 + 80, width: 61, height: 61)
        addSubview(userFaceImageBackground)
        
        //头像
        userFaceImageView = UIImageView()
        userFaceImageView.layer.cornerRadius = 61 * 0.8 / 2
        userFaceImageView.layer.masksToBounds = true
        userFaceImageView.backgroundColor = UIColor.white
        
        userFaceImageView.kf.setImage(with: URL(string: Constants.User.USER_FACE_IMAGE), placeholder: UIImage(named: "default_user_face"), options: nil, progressBlock: nil, completionHandler: nil)
        
//        userFaceImageView.frame = CGRect(x: self.bounds.width/2 - backgroundImage.bounds.width/2 + 54 + userFaceImageBackground.bounds.width/2 - (userFaceBorderImage?.size.width)! * 0.8 / 2, y: self.bounds.height/2 - backgroundImage.bounds.height/2 + 80 + userFaceImageBackground.bounds.height/2 - (userFaceBorderImage?.size.height)! * 0.8 / 2, width: (userFaceBorderImage?.size.width)! * 0.8, height: (userFaceBorderImage?.size.height)! * 0.8)
        
        userFaceImageView.frame.size = CGSize(width: 58, height: 58)
        
        addSubview(userFaceImageView)
        
        userFaceImageView.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.center.equalTo(userFaceImageBackground)
        }
        
        // 用户id
        userIdLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
//        let index = Constants.User.USER_ID.index(Constants.User.USER_ID.endIndex, offsetBy: -5)
//        userIdLabel.text = "ID:\(Constants.User.USER_ID.substring(from: index))"
        userIdLabel.text = "ID: " + Constants.User.USER_ID
        userIdLabel.outLineWidth = 2
        userIdLabel.outTextColor = UIColor.white
        userIdLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        userIdLabel.sizeToFit()
        addSubview(userIdLabel)
        
        userIdLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userFaceImageBackground).offset(userFaceImageBackground.bounds.height + 10)
            make.centerX.equalTo(userFaceImageBackground)
        }
        
        // 用户昵称
        userNickName.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        userNickName.text = "昵称: \(Constants.User.USER_NICK_NAME)"
        userNickName.outLineWidth = 3
        userNickName.outTextColor = UIColor.white
        userNickName.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        userNickName.sizeToFit()
        userNickName.frame = userNickName.frame.insetBy(dx: CGFloat(1), dy: CGFloat(0))
        addSubview(userNickName)
        
        userNickName.snp.makeConstraints { (make) in
            make.top.equalTo(userFaceImageBackground).offset(5)
            make.left.equalTo(userFaceImageBackground).offset(userFaceImageBackground.bounds.width + 20)
        }
        
        // 用户星座
        constellationLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        constellationLabel.text = "星座: 水瓶座"
        constellationLabel.outLineWidth = 3
        constellationLabel.outTextColor = UIColor.white
        constellationLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        constellationLabel.sizeToFit()
        addSubview(constellationLabel)
        
        constellationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNickName).offset(userNickName.bounds.height + 5)
            make.left.equalTo(userNickName)
        }
        
        // 用户性别
        sexLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        if Constants.User.USER_SEX == "0" {
            sexLabel.text = "性别: 男"
        }else if Constants.User.USER_SEX == "-1"{
            sexLabel.text = "性别: 未知"
        }else{
            sexLabel.text = "性别: 女"
        }
        sexLabel.outLineWidth = 3
        sexLabel.outTextColor = UIColor.white
        sexLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        sexLabel.sizeToFit()
        addSubview(sexLabel)
        
        sexLabel.snp.makeConstraints { (make) in
            make.top.equalTo(constellationLabel).offset(constellationLabel.bounds.height + 5)
            make.left.equalTo(userNickName)
        }
        
        // 退出登录
        let logoutBtnImage = UIImage(named: "btn_logout")
        logoutBtn = UIButton(type: .custom)
        logoutBtn.setBackgroundImage(logoutBtnImage, for: .normal)
        logoutBtn.frame = CGRect(x: self.bounds.width/2 - (logoutBtnImage?.size.width)! - 5, y: self.bounds.height/2 + backgroundImage.bounds.height/2 - (logoutBtnImage?.size.height)! / 2, width: (logoutBtnImage?.size.width)!, height: (logoutBtnImage?.size.height)! )
        addSubview(logoutBtn)
        
        logoutBtn.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        
        // 编辑资料
        let changeUserInfoImage = UIImage(named: "change_user_info")
        changeInfoBtn = UIButton(type: .custom)
        changeInfoBtn.setBackgroundImage(changeUserInfoImage, for: .normal)
        changeInfoBtn.frame = CGRect(x: self.bounds.width/2 + 5, y: self.bounds.height/2 + backgroundImage.bounds.height/2 - (changeUserInfoImage?.size.height)! / 2, width: (changeUserInfoImage?.size.width)!, height: (changeUserInfoImage?.size.height)!)
        addSubview(changeInfoBtn)
        changeInfoBtn.addTarget(self, action: #selector(editUserInfo), for: .touchUpInside)
        
        initBrithday()
        
        addDialogToWindow()
    }

    /// 退出登录
    @objc func logOut() -> () {
        if mainVC != nil {
            mainVC.clearGemNumber()
        }
        
        LocalDataUtils.clearLoaclData()
        self.hide()
        
        Alamofire.request(Constants.Network.User.LOGOUT_URL, method: .post, parameters: NetWorkUtils.createBaseParams()).responseJSON { (response) in
            
        }
    }
    
    @objc func editUserInfo() -> () {
        editUserInfoDialog.createView()
        editUserInfoDialog.show2(action: { [weak self] (nick, sex, birthday) in
            self?.userNickName.text = "昵称:" + nick
            if sex == "0" {
                self?.sexLabel.text = "性别:男"
            }else {
                self?.sexLabel.text = "性别:女"
            }
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let con = ConstellationUtils.calculateWithDate(date: df.date(from: birthday)!)
            self?.constellationLabel.text = "星座:" + con
            
            self?.updateLocalUserInfo(nick: nick, sex: sex, birthday: birthday)
        })
    }
    
    func updateLocalUserInfo(nick:String, sex:String, birthday:String) -> () {
        Constants.User.USER_NICK_NAME = nick
        Constants.User.USER_SEX = sex
        Constants.User.USER_BRITHDAY = birthday
        UserDefaults.standard.set(nick, forKey: Constants.User.USER_NICK_NAME_KEY)
        UserDefaults.standard.set(sex, forKey: Constants.User.USER_SEX_KEY)
        UserDefaults.standard.set(birthday, forKey: Constants.User.USER_BRITHDAY_KEY)
    }
    
    /// 初始化生日
    func initBrithday() -> () {
        if Constants.User.USER_BRITHDAY == "" {
            constellationLabel.text = "星座:未知"
            return
        }
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        constellationLabel.text = "星座:" + ConstellationUtils.calculateWithDate(date: format.date(from: Constants.User.USER_BRITHDAY)!)
    }
    
    private var mainVC:MainViewController!
    
    func show2(mainViewController:MainViewController) -> () {
        mainVC = mainViewController
        show()
    }
    
}


















