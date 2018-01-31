//
//  MainVCWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/26.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension HomeViewController{
    
    func setupUI() -> () {
        self.view.backgroundColor = UIColor.white
        
        
        createMainBtns()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        if isShowADV {
            isShowADV = true
            return
        }
        if SplashView.isExistsSplashData() == false {
            isShowADV = true
            if Constants.User.USER_ID != "" {
                getsUserInfo()
            }
            return
        }
        SplashView.showSplashView(duration: 5, defaultImage: UIImage(named: "Launchplaceholder"), tapSplashImageBlock: { (resultStr) in
            if resultStr != "" {
                switch UserDefaults.standard.integer(forKey: SplashView.OPEN_ADV_URL_TYPE) {
                case 1:
                    let link = resultStr
                    // 跳转到网页
                    if link == "" {
                        return
                    }
                    let webVC = WebViewController()
                    webVC.link = link
                    webVC.shareTitle = UserDefaults.standard.string(forKey: SplashView.OPEN_ADV_SHARE_TITLE)
                    webVC.shareInfo = UserDefaults.standard.string(forKey: SplashView.OPEN_ADV_SHARE_INFO)
                    webVC.thumbShareImage = UserDefaults.standard.string(forKey: SplashView.OPEN_ADV_SHARE_THUMBIMAGE)
                    webVC.actionTitle = UserDefaults.standard.string(forKey: SplashView.OPEN_ADV_URL_TITLE)
                    self.navigationController?.pushViewController(webVC, animated: true)
                    break
                case 2:
                    let link = Int(resultStr!)
                    if link == -1 {
                        self.showPayDialog()
                    }else{
//                        self.itemClick(index: link!)
                    }
                    break
                case 3:
                    //跳转到外部链接
                    if let url = URL(string: resultStr!) {
                        //根据iOS系统版本，分别处理
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url, options: [:],completionHandler: {(success) in })
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    break
                default: break
                    //什么都不干
                }
            }
        }) { (isDiss) in
            self.isShowADV = true
            
            if Constants.User.USER_ID == "" {
                
            }else {
                self.getsUserInfo()
            }
        }
    }
}

extension HomeViewController{
    
    /// 来到首页的时候，读取用户信息
    func getsUserInfo() -> () {
        if Constants.User.USER_ID == "" {
            payGemBtn.actionLabel.text = "0"
            return
        }

        if isShowADV == false {
            return
        }

        UserTools.getUserInfo(callback: { [weak self] in
            if self?.payGemBtn != nil {
                self?.payGemBtn.actionLabel.text = String(Constants.User.diamondsCount)
            }
        })
    }
    
    /// 清除钻石数量
    func clearGemNumber() -> () {
        payGemBtn.actionLabel.text = "0"
    }
}

extension HomeViewController{
    
    /// 在加载显示完首页的viewcontroller之后，需要调用该方法来成功获取系统的window
    func loadDialogToWindow() -> () {
        
        /// 购买钻石的dialog
        payGemDialog = PayListDialog(frame: UIScreen.main.bounds)
        
        /// 用户信息
        userInfoDialog = UserInfoDialog(frame: UIScreen.main.bounds)
        
        /// 签到
//        checkInDialog = CheckInDialog(frame: UIScreen.main.bounds)
        
        /// 邀请
        inviteDialog = InviteDialog(frame: UIScreen.main.bounds)
        
        /// 帮助
        helpDialog = HelpDialog(frame: UIScreen.main.bounds)
        
        if UserDefaults.standard.bool(forKey: Constants.IS_FIRST_OPEN_MAIN) == false {
            payGuidView = MainBeginnerGuidPayView(frame: UIScreen.main.bounds)
            payGuidView.createView()
            payGuidView.show()
            UserDefaults.standard.set(true, forKey: Constants.IS_FIRST_OPEN_MAIN)
        }
    }
    
    func showFastLogin() -> () {
        
    }
    
}

// MARK: - 按钮集合
extension HomeViewController{
    
    // 创建首页的按钮
    func createMainBtns() -> () {
        // 设置按钮
        let settingImage = UIImageView(image: UIImage(named: "Settings-btn"))
        
        setupSettings(testImage: settingImage)
        
        let settingsBtn = MainFloatMenu(frame: CGRect(x: self.view.bounds.width - 10 - settingImage.bounds.width, y: UIScreen.main.bounds.height - 90, width: settingImage.bounds.width, height: settingImage.bounds.height), image: settingImage.image, actionTitle: "设置")
        view.addSubview(settingsBtn)
        
        settingsBtn.addBtnClickAction(target: self, action: #selector(settingsClick))
        
        /// 邀请按钮
        let inviteBtn = MainFloatMenu(frame: CGRect(x: self.view.bounds.width - 10 * 2 - settingsBtn.bounds.width * 2, y: UIScreen.main.bounds.height - 90, width: settingsBtn.bounds.width, height: settingsBtn.bounds.height), image: UIImage(named: "Store-btn"), actionTitle: "邀请")
        view.addSubview(inviteBtn)
        
        inviteBtn.addBtnClickAction(target: self, action: #selector(showInviteDialog))
        
        /// 签到 （修改为积分商城）
        let checkInBtn = MainFloatMenu(frame: CGRect(x: self.view.bounds.width - 10 * 3 - settingsBtn.bounds.width * 3, y: UIScreen.main.bounds.height - 90, width: settingsBtn.bounds.width, height: settingsBtn.bounds.height), image: UIImage(named: "首页积分商城"), actionTitle: "积分商城")
        view.addSubview(checkInBtn)
        checkInBtn.addBtnClickAction(target: self, action: #selector(showCheckInDialog))
        
        /// 礼物按钮
        let giftBtn = MainFloatMenu(frame: CGRect(x: self.view.bounds.width - 10 * 4 - settingsBtn.bounds.width * 4, y: UIScreen.main.bounds.height - 90, width: settingsBtn.bounds.width, height: settingsBtn.bounds.height), image: UIImage(named: "Leaderboard-btn"), actionTitle: "奖品")
        view.addSubview(giftBtn)
        giftBtn.addBtnClickAction(target: self, action: #selector(showMyGift))
        
        /// 购买钻石按钮
        payGemBtn = MainFloatMenu(frame: CGRect(x: 10, y: UIScreen.main.bounds.height - 90, width: settingImage.bounds.width, height: 90), image: UIImage(named: "Plus-btn"), actionTitle: "0")
        view.addSubview(payGemBtn)
        
        let infoDictionary = Bundle.main.infoDictionary!
        versionLabel = UILabel()
        versionLabel.font = UIFont.systemFont(ofSize: 12)
        versionLabel.textColor = UIColor.lightGray
        versionLabel.text = "V " + (infoDictionary["CFBundleShortVersionString"] as? String)!
        versionLabel.sizeToFit()
        versionLabel.frame = CGRect(x: UIScreen.main.bounds.width - versionLabel.bounds.width, y: UIScreen.main.bounds.height - versionLabel.bounds.height, width: versionLabel.bounds.width, height: versionLabel.bounds.height)
        view.addSubview(versionLabel)
        
        payGemBtn.addBtnClickAction(target: self, action: #selector(showPayDialog))
        
    }
    
    /// 显示邀请界面
    @objc func showInviteDialog() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        inviteDialog.createView()
        inviteDialog.show()
    }
    
    /// 显示我的礼物
    @objc func showMyGift() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        let mailingListVC = MailingListViewController()
        self.navigationController?.pushViewController(mailingListVC, animated: true)
    }
    
    /// 显示签到的dialog （ 修改为积分商城）
    @objc func showCheckInDialog() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        self.navigationController?.pushViewController(PointsMallViewController(), animated: true)
    }
    
    // 点击展开隐藏设置按钮
    @objc fileprivate func settingsClick() -> () {
        if settingsGroupView.isHidden {
            settingsGroupView.isHidden = false
        }else {
            settingsGroupView.isHidden = true
        }
    }
    
    // 装载弹出的设置按钮
    func setupSettings(testImage:UIImageView) {
        
        let testUserIconImage = UIImageView(image: UIImage(named: "daeva_profile"))
        _ = UIImageView(image: UIImage(named: "Info-icon"))
        
        let settingsY = UIScreen.main.bounds.height - (80 - testImage.bounds.height) - 250 - 14
        let settingsWidth = testImage.bounds.width - 10
        
        settingsGroupView = UIView(frame: CGRect(x: self.view.bounds.width - testImage.bounds.width - 5, y: settingsY, width: settingsWidth, height: 250))
        settingsGroupView.layer.cornerRadius = 20
        settingsGroupView.layer.masksToBounds = true
        settingsGroupView.backgroundColor = UIColor(red: 99/255.0, green: 168/255.0, blue: 205/255.0, alpha: 1)
        view.addSubview(settingsGroupView)
        
        /// 用户中心
        let userIcon = UIButton(type: .custom)
        userIcon.frame = CGRect(x: settingsWidth/2-testUserIconImage.bounds.width/2, y: 10, width: 0, height: 0)
        userIcon.setBackgroundImage(UIImage(named: "daeva_profile"), for: .normal)
        userIcon.sizeToFit()
        settingsGroupView.addSubview(userIcon)
        userIcon.addTarget(self, action: #selector(showUserInfoDialog), for: .touchUpInside)
        
        /// 游戏记录
        let gameHistroy = UIButton(type: .custom)
        gameHistroy.setBackgroundImage(UIImage(named: "游戏记录"), for: .normal)
        gameHistroy.sizeToFit()
        settingsGroupView.addSubview(gameHistroy)
        
        gameHistroy.addTarget(self, action: #selector(showGameHistoryView), for: .touchUpInside)
        
        gameHistroy.snp.makeConstraints { (make) in
            make.top.equalTo(userIcon).offset(userIcon.bounds.height + 20)
            make.centerX.equalTo(settingsGroupView)
        }
        
        /// 代币记录
        let tokenHistroy = UIButton(type: .custom)
        tokenHistroy.setBackgroundImage(UIImage(named: "代币记录"), for: .normal)
        tokenHistroy.sizeToFit()
        settingsGroupView.addSubview(tokenHistroy)
        
        tokenHistroy.addTarget(self, action: #selector(showTokenHistoryView), for: .touchUpInside)
        
        tokenHistroy.snp.makeConstraints { (make) in
            make.top.equalTo(gameHistroy).offset(gameHistroy.bounds.height + 20)
            make.centerX.equalTo(settingsGroupView)
        }
        
        /// 帮助
        let infoIcon = UIImageView()
        infoIcon.image = UIImage(named: "Info-icon")
        infoIcon.sizeToFit()
        settingsGroupView.addSubview(infoIcon)
        
        infoIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(settingsGroupView)
            make.top.equalTo(tokenHistroy).offset(tokenHistroy.bounds.height + 20)
        }
        
        infoIcon.isUserInteractionEnabled = true
        
        let infoTap = UITapGestureRecognizer(target: self, action: #selector(showHelpDialog))
        infoTap.numberOfTapsRequired = 1
        infoIcon.addGestureRecognizer(infoTap)
        
        settingsGroupView.isHidden = true
    }
    
    /// 显示用户信息
    @objc func showUserInfoDialog() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        let userCenterVC = UserCenterViewController()
        self.navigationController?.pushViewController(userCenterVC, animated: true)
    }
    
    @objc func showHelpDialog() -> () {
        helpDialog.createView()
        helpDialog.show()
    }
    
    @objc func showGameHistoryView(){
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        let gameHistoryVC = GameHistoryViewController()
        self.navigationController?.pushViewController(gameHistoryVC, animated: true)
    }
    
    @objc func showTokenHistoryView(){
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        let tokenHistoryVC = TokenHistoryViewController()
        self.navigationController?.pushViewController(tokenHistoryVC, animated: true)
    }
    
}

// MARK: - 获取开屏页广告
extension HomeViewController {
    
    func getOpenAdv() -> () {
        Alamofire.request(Constants.Network.Machine.GET_OPEN_ADV).responseJSON { (dataResponse) in
            if NetWorkUtils.checkReponse(response: dataResponse) {
                let json = JSON(data: dataResponse.data!)
                if json["data"].arrayValue.count > 0 {
                    SplashView.updateSplashData(imgUrl: json["data"].arrayValue[0]["advertiseBigImg"].stringValue, actUrl: json["data"].arrayValue[0]["scheme"].stringValue, shareTitle: json["data"].arrayValue[0]["shareTitle"].stringValue, shareInfo: json["data"].arrayValue[0]["shareSubtitle"].stringValue, shareImage: json["data"].arrayValue[0]["shareImg"].stringValue, urlType: json["data"].arrayValue[0]["redirectType"].intValue, title:json["data"].arrayValue[0]["name"].stringValue )
                }else{
                    UserDefaults.standard.removeObject(forKey: SplashView.IMG_URL)
                    UserDefaults.standard.removeObject(forKey: SplashView.ACT_URL)
                }
            }
        }
    }
    
}



