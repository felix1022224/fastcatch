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
        
        createVIPModelView()
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
        bottomGroupView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 0.3 + 25, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 25 - UIScreen.main.bounds.height * 0.3 - 5)
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
            make.top.equalTo(titleImage).offset(titleImage.bounds.height + 5)
        }
        /// 用户头像
        userFaceImage.frame.size = CGSize(width: userFaceImageBackground.bounds.width * 0.9, height: userFaceImageBackground.bounds.height * 0.9)
        userFaceImage.backgroundColor = UIColor.gray
        userFaceImage.layer.cornerRadius = userFaceImage.bounds.width/2
        userFaceImage.layer.masksToBounds = true
        userFaceImage.frame = CGRect(x: 24 + userFaceImageBackground.bounds.width/2 - userFaceImage.bounds.width/2, y: titleImage.bounds.height + 5 + UIApplication.shared.statusBarFrame.height + (userFaceImageBackground.bounds.width/2 - userFaceImage.bounds.width/2), width: userFaceImage.bounds.width, height: userFaceImage.bounds.height)
        topGroupView.addSubview(userFaceImage)
        
        userFaceImage.kf.setImage(with: URL(string: Constants.User.USER_FACE_IMAGE), placeholder: UIImage(named: "default_user_face"), options: nil, progressBlock: nil, completionHandler: nil)
        
        /// vip标签
        if Constants.User.vip == 100000 {
            /// vip
            vipImage.image = UIImage(named: "VIP标签")
            vipImage.isHidden = false
        }else if Constants.User.vip == 110000 {
            /// svip
            vipImage.image = UIImage(named: "SVIP标签")
            vipImage.isHidden = false
        }else{
            vipImage.isHidden = true
        }
        vipImage.sizeToFit()
        
        topGroupView.addSubview(vipImage)
        
        vipImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(userFaceImage)
            make.bottom.equalTo(userFaceImage).offset(vipImage.bounds.height/2)
        }
        
        /// 用户昵称
        userNickNameLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 13)
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
            make.right.equalTo(view).offset(-100)
        }
        
        /// 用户性别
        userSexLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 13)
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
        userBirthdayLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 13)
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
        userIdLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 11)
        userIdLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        userIdLabel.outTextColor = UIColor.white
        userIdLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        userIdLabel.numberOfLines = 2
        userIdLabel.text = "ID:" + Constants.User.USER_ID
        userIdLabel.sizeToFit()
        topGroupView.addSubview(userIdLabel)
        
        userIdLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userFaceImageBackground).offset(userFaceImageBackground.bounds.height + 5)
            make.left.equalTo(userFaceImageBackground).offset(-5)
        }
        
        // 退出登录
        let logoutBtnImage = UIImage(named: "退出登录")
        logoutBtn = UIButton(type: .custom)
        logoutBtn.setBackgroundImage(logoutBtnImage, for: .normal)
        logoutBtn.setBackgroundImage(UIImage(named: "退出登录点击"), for: .highlighted)
        logoutBtn.sizeToFit()
        view.addSubview(logoutBtn)
        
        logoutBtn.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        
        // 编辑资料
        let changeUserInfoImage = UIImage(named: "个人中心编辑资料")
        changeInfoBtn = UIButton(type: .custom)
        changeInfoBtn.setBackgroundImage(changeUserInfoImage, for: .normal)
        changeInfoBtn.setBackgroundImage(UIImage(named: "个人中心编辑资料点击"), for: .highlighted)
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
            make.top.equalTo(view).offset(UIApplication.shared.statusBarFrame.height)
            make.centerX.equalTo(view)
            make.width.equalTo(Constants.UI.TITLE_IMAGE_WIDTH)
            make.height.equalTo(Constants.UI.TITLE_IMAGE_HEIGHT)
        }
        
        /// 返回按钮
        backBtn.setImage(UIImage(named: "邮寄返回"), for: .normal)
        backBtn.sizeToFit()
        view.addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(ucTitleImage)
            make.left.equalTo(view).offset(14)
        }
        
        backBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        /// 用户消息中心
        userNotificationIcon.setBackgroundImage(UIImage(named: "用户消息"), for: .normal)
        userNotificationIcon.sizeToFit()
        view.addSubview(userNotificationIcon)
        
        userNotificationIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(ucTitleImage)
            make.right.equalTo(view).offset(-14)
        }
        
        userNotificationIcon.addTarget(self, action: #selector(showNotifictionVC), for: .touchUpInside)
        
        setupUserCenterWidget(titleImage: ucTitleImage)
    }
    
    /// 显示通知页面
    @objc private func showNotifictionVC() {
        let notificationVC = NotificationViewController()
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
}

// MARK: - vip 模块
extension UserCenterViewController{
    
    func createVIPModelView() {
        vipGroupView.frame = CGRect(x: 0, y: topGroupView.bounds.height * 0.9, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.08)
        vipGroupView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        view.addSubview(vipGroupView)
        
        vipLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        vipLabel.outTextColor = UIColor.white
        vipLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        vipLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        changeVIPLabel()
        vipLabel.sizeToFit()
        vipLabel.frame.origin = CGPoint(x: 15, y: vipGroupView.bounds.height/2 - vipLabel.bounds.height/2)
        vipGroupView.addSubview(vipLabel)
        
        if Constants.User.vipDay <= 0 {
            switchVIPOpenedButton(isVip: true)
        }else{
           switchVIPOpenedButton(isVip: false)
        }
        
        vipOpenedButton.sizeToFit()
        vipOpenedButton.frame = CGRect(x: UIScreen.main.bounds.width - 15 - vipOpenedButton.bounds.width, y: vipGroupView.bounds.height/2 - vipOpenedButton.bounds.height/2 + 2, width: vipOpenedButton.bounds.width, height: vipOpenedButton.bounds.height)
        vipGroupView.addSubview(vipOpenedButton)
        
        vipOpenedButton.addTarget(self, action: #selector(clickVIPOpened), for: .touchUpInside)
        
    }
    
    /// 切换vip开通按钮的状态
    func switchVIPOpenedButton(isVip:Bool) -> () {
        if isVip {
            /// 已经是vip了
            vipOpenedButton.setBackgroundImage(UIImage(named: "立即续费"), for: .normal)
            vipOpenedButton.setBackgroundImage(UIImage(named: "立即续费点击"), for: .highlighted)
        }else{
            /// 还不是vip
            vipOpenedButton.setBackgroundImage(UIImage(named: "立即开通"), for: .normal)
            vipOpenedButton.setBackgroundImage(UIImage(named: "立即开通点击"), for: .highlighted)
        }
    }
    
    /// 修改vip描述的内容
    func changeVIPLabel() -> () {
        var currentDate = Date()
        currentDate.addTimeInterval(TimeInterval(Constants.User.vipDay * 24 * 3600))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current // 设置时区
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if Constants.User.vip == 100000 {
            //vip
            vipLabel.text = "VIP会员：\(dateFormatter.string(from: currentDate))到期"
        }else if Constants.User.vip == 110000 {
            //svip
            vipLabel.text = "SVIP会员：\(dateFormatter.string(from: currentDate))到期"
        }else{
            //不是vip
            vipLabel.text = "开通VIP，送480币+充值八折特权"
        }
    }
    
    /// 点击立即开通按钮
    @objc func clickVIPOpened(){
        let payVC = PayViewController()
        payVC.userStatusCallback = {[weak self] in
            
        }
        self.navigationController?.pushViewController(payVC, animated: true)
    }
    
}

