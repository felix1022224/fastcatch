//
//  UserCenterWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/12.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire

class UserCenterWidget: NSObject {
    
}

extension UserCenterViewController {
    
    /// 装载UI
    func setupUI() -> () {
        createBackground()
        createTitlesGroup()
    }
    
    /// 创建背景图片
    func createBackground() -> () {
        /// 背景图片
        backgroundImage.image = UIImage(named: "我的资料背景")
        backgroundImage.frame = UIScreen.main.bounds
        view.addSubview(backgroundImage)
        
        /// 顶部的集合
        topGroupView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3)
        view.addSubview(topGroupView)
        
        /// 底部的集合
        bottomGroupView.frame = CGRect(x: 5, y: UIScreen.main.bounds.height * 0.3 + 25, width: UIScreen.main.bounds.width - 5*2, height: UIScreen.main.bounds.height - 25 - UIScreen.main.bounds.height * 0.3 - 5)
        view.addSubview(bottomGroupView)
        
        setupTopWidget()
    }
    
    /// 创建用户相关的widget
    func setupUserCenterWidget(titleImage:UIImageView) -> () {
        let userFaceImageBackground = UIImageView()
        userFaceImageBackground.image = UIImage(named: "我的资料头像框")
        userFaceImageBackground.sizeToFit()
        topGroupView.addSubview(userFaceImageBackground)
        
        userFaceImageBackground.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(24)
            make.top.equalTo(titleImage).offset(titleImage.bounds.height + 25)
        }
        /// 用户头像
        userFaceImage.frame.size = CGSize(width: userFaceImageBackground.bounds.width * 0.9, height: userFaceImageBackground.bounds.height * 0.9)
        userFaceImage.backgroundColor = UIColor.gray
        userFaceImage.layer.cornerRadius = userFaceImage.bounds.width/2
        userFaceImage.layer.masksToBounds = true
        userFaceImage.frame = CGRect(x: 24 + userFaceImageBackground.bounds.width/2 - userFaceImage.bounds.width/2, y: titleImage.bounds.height + 25 + UIApplication.shared.statusBarFrame.height + 5 + (userFaceImageBackground.bounds.width/2 - userFaceImage.bounds.width/2), width: userFaceImage.bounds.width, height: userFaceImage.bounds.height)
        topGroupView.addSubview(userFaceImage)
        
        userFaceImage.kf.setImage(with: URL(string: Constants.User.USER_FACE_IMAGE))
        
        /// 用户昵称
        userNickNameLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(14))
        userNickNameLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        userNickNameLabel.outTextColor = UIColor.white
        userNickNameLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        userNickNameLabel.numberOfLines = 1
        userNickNameLabel.text = "昵称: " + Constants.User.USER_NICK_NAME
        userNickNameLabel.sizeToFit()
        topGroupView.addSubview(userNickNameLabel)
        
        userNickNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userFaceImageBackground).offset(5)
            make.left.equalTo(userFaceImageBackground).offset(userFaceImageBackground.bounds.width + 15)
        }
        
        /// 用户性别
        userSexLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(14))
        userSexLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        userSexLabel.outTextColor = UIColor.white
        userSexLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        userSexLabel.numberOfLines = 1
        if Constants.User.USER_SEX == "0" {
            userSexLabel.text = "性别: 男"
        }else if Constants.User.USER_SEX == "-1"{
            userSexLabel.text = "性别: 未知"
        }else{
            userSexLabel.text = "性别: 女"
        }
        userSexLabel.sizeToFit()
        topGroupView.addSubview(userSexLabel)
        
        userSexLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNickNameLabel).offset(userNickNameLabel.bounds.height + 5)
            make.left.equalTo(userNickNameLabel)
        }
        
        /// 用户生日
        userBirthdayLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(14))
        userBirthdayLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        userBirthdayLabel.outTextColor = UIColor.white
        userBirthdayLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        userBirthdayLabel.numberOfLines = 1
        userBirthdayLabel.sizeToFit()
        topGroupView.addSubview(userBirthdayLabel)
        
        userBirthdayLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(userSexLabel).offset(userSexLabel.bounds.height + 5)
            make.left.equalTo(userNickNameLabel)
        }
        
        /// 用户ID
        let userIdLabel = MainCustomerLabel()
        userIdLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(11))
        userIdLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        userIdLabel.outTextColor = UIColor.white
        userIdLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        userIdLabel.numberOfLines = 1
        userIdLabel.text = "ID:" + Constants.User.USER_ID
        userIdLabel.sizeToFit()
        topGroupView.addSubview(userIdLabel)
        
        userIdLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userFaceImageBackground).offset(userFaceImageBackground.bounds.height + 15)
            make.centerX.equalTo(userFaceImageBackground)
        }
        
        // 退出登录
        let logoutBtnImage = UIImage(named: "btn_logout")
        logoutBtn = UIButton(type: .custom)
        logoutBtn.setBackgroundImage(logoutBtnImage, for: .normal)
        logoutBtn.sizeToFit()
        view.addSubview(logoutBtn)
        
        logoutBtn.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        
        // 编辑资料
        let changeUserInfoImage = UIImage(named: "change_user_info")
        changeInfoBtn = UIButton(type: .custom)
        changeInfoBtn.setBackgroundImage(changeUserInfoImage, for: .normal)
        changeInfoBtn.sizeToFit()
        view.addSubview(changeInfoBtn)
        changeInfoBtn.addTarget(self, action: #selector(editUserInfo), for: .touchUpInside)
        
        changeInfoBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-14)
            make.top.equalTo(userFaceImageBackground)
        }
        
        logoutBtn.snp.makeConstraints { (make) in
            make.top.equalTo(changeInfoBtn).offset(logoutBtn.bounds.height + 15)
            make.centerX.equalTo(changeInfoBtn)
        }
        
        initBrithday()
    }
    
    /// 退出登录
    @objc func logOut() -> () {
        LocalDataUtils.clearLoaclData()
        self.navigationController?.popViewController(animated: true)
        
        Alamofire.request(Constants.Network.User.LOGOUT_URL, method: .post, parameters: NetWorkUtils.createBaseParams()).responseJSON { (response) in
            
        }
    }
    
    @objc func editUserInfo() -> () {
        editUserInfoDialog.createView()
        editUserInfoDialog.show2(action: { [weak self] (nick, sex, birthday) in
            self?.userNickNameLabel.text = "昵称: " + nick
            if sex == "0" {
                self?.userSexLabel.text = "性别: 男"
            }else {
                self?.userSexLabel.text = "性别: 女"
            }
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let con = ConstellationUtils.calculateWithDate(date: df.date(from: birthday)!)
            self?.userBirthdayLabel.text = "星座: " + con
            
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
            userBirthdayLabel.text = "星座: 未知"
            return
        }
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        userBirthdayLabel.text = "星座: " + ConstellationUtils.calculateWithDate(date: format.date(from: Constants.User.USER_BRITHDAY)!)
    }
    
    /// 装载顶部的UI
    func setupTopWidget() -> () {
        let ucTitleImage = UIImageView(image: UIImage(named: "我的资料顶部"))
        ucTitleImage.sizeToFit()
        view.addSubview(ucTitleImage)
        
        ucTitleImage.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(UIApplication.shared.statusBarFrame.height + 5)
            make.centerX.equalTo(view)
        }
        
        backBtn.setImage(UIImage(named: "邮寄返回"), for: .normal)
        backBtn.sizeToFit()
        view.addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(ucTitleImage)
            make.left.equalTo(view).offset(14)
        }
        
        backBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        setupUserCenterWidget(titleImage: ucTitleImage)
    }
    
    
    
}