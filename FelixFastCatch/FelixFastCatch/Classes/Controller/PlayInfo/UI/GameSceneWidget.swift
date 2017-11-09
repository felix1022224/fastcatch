//
//  GameSceneWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/11/2.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

/// 控制widget
class GameSceneWidget: NSObject {

}

extension GameSceneViewController{
    
    /// 装载UI
    func setupUI() -> () {
        createBackground()
        
        //顶部的view
        topGroupView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width - UIApplication.shared.statusBarFrame.height)
        view.addSubview(topGroupView)
        
        //底部的view
        bottomGroupView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width, width: self.view.bounds.width, height: UIScreen.main.bounds.height - UIScreen.main.bounds.width + UIApplication.shared.statusBarFrame.height))
        view.addSubview(bottomGroupView)
        
        setupTopView()
        
        createPlayUserInfo()
        
        setupBottomView()
        
    }
    
    /// 创建背景板
    func createBackground() -> () {
        backgroundView.frame = self.view.bounds
        view.addSubview(backgroundView)
        
        let backgroundImageView = UIImageView(image: UIImage(named: "main_background"))
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        view.addSubview(backgroundImageView)
        
        let playGameBackgroundImage = UIImageView(image: UIImage(named: "play_game_background_blue"))
        playGameBackgroundImage.sizeToFit()
        playGameBackgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(playGameBackgroundImage)
        
    }
    
    //装载底部的view
    func setupBottomView() -> () {
        createBottomGroup()
    }
    
}

// MARK: - 顶部的view
extension GameSceneViewController{
    
    private struct btnsKeys{
        static var backBtns = "backBtnsKey"
    }
    
    //装载顶部的view
    func setupTopView() -> () {
        // 直播的view
        liveView.backgroundColor = UIColor.black
        liveView.frame = topGroupView.frame
        view.addSubview(liveView)
        
        // 初始化直播的框架
        initLive()
        
        setupBtns()
        
        createStartBtn()
        
        createNumber()
        
        createReStartTimeLabel()
        
        createPlayControllerView()
    }
    
    /// 装载按钮
    func setupBtns() -> () {
        setupBackBtn()
        
        /// 问号按钮
        let helpBtn = UIButton(type: .custom)
        helpBtn.setImage(UIImage(named: "icon_qa"), for: .normal)
        helpBtn.sizeToFit()
        view.addSubview(helpBtn)
        
        helpBtn.addTarget(self, action: #selector(showFeedbackView), for: .touchUpInside)
        
        helpBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(liveView).offset(-40)
            make.left.equalTo(self.view).offset(10)
        }
        
        /// 切换摄像头
        lensBtn.setImage(UIImage(named: "icon_lens"), for: .normal)
        lensBtn.sizeToFit()
        view.addSubview(lensBtn)
        
        lensBtn.addTarget(self, action: #selector(switchCamare), for: .touchUpInside)
        
        lensBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(helpBtn)
            make.right.equalTo(self.view).offset(-10)
        }
        
        /// 音频按钮
        audioBtn = UIButton(type: .custom)
        audioBtn.setImage(UIImage(named: "icon_audio"), for: .normal)
        audioBtn.sizeToFit()
        view.addSubview(audioBtn)
        
        audioBtn.addTarget(self, action: #selector(switchAudio), for: .touchUpInside)
        
        audioBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(helpBtn).offset(-(helpBtn.bounds.height + 10))
            make.left.equalTo(helpBtn)
        }
        
        if UserDefaults.standard.bool(forKey: Constants.User.USER_AUDIO_SETTING) == false {
            isCloseMusic = false
            audioBtn.setImage(UIImage(named: "icon_audio"), for: .normal)
        }else{
            isCloseMusic = true
            audioBtn.setImage(UIImage(named: "audio_close"), for: .normal)
        }
        
        createGemBackground()
    }
    
    /// 切换音频按钮
    @objc func switchAudio() -> () {
        if isCloseMusic {
            bgMusicPlayer.play()
            isCloseMusic = false
            audioBtn.setImage(UIImage(named: "icon_audio"), for: .normal)
            UserDefaults.standard.set(false, forKey: Constants.User.USER_AUDIO_SETTING)
        }else{
            bgMusicPlayer.pause()
            isCloseMusic = true
            audioBtn.setImage(UIImage(named: "audio_close"), for: .normal)
            UserDefaults.standard.set(true, forKey: Constants.User.USER_AUDIO_SETTING)
        }
    }
    
    /// 创建钻石
    func createGemBackground() -> () {
        gemBackground.image = UIImage(named: "bg_gem_number")
        gemBackground.sizeToFit()
        view.addSubview(gemBackground)
        
        gemBackground.snp.makeConstraints { (make) in
            make.centerY.equalTo(backBtn!).offset(-4)
            make.right.equalTo(self.view).offset(-10)
        }
        
        gemLabel.text = String(Constants.User.diamondsCount)
        gemLabel.outLineWidth = 1
        gemLabel.outTextColor = UIColor.white
        gemLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        gemLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(11))
        view.addSubview(gemLabel)
        
        gemLabel.snp.makeConstraints { (make) in
            make.right.equalTo(gemBackground).offset(-28)
            make.centerY.equalTo(gemBackground).offset(2)
        }
        
        gemBackground.isUserInteractionEnabled = true
        let payTap = UITapGestureRecognizer(target: self, action: #selector(showPayDialog))
        gemBackground.addGestureRecognizer(payTap)
        
        if Constants.isShowPay == false {
            gemBackground.isHidden = true
            gemLabel.isHidden = true
        }else{
            if Constants.User.USER_ID == "" {
                gemBackground.isHidden = true
                gemLabel.isHidden = true
            }else{
                gemBackground.isHidden = false
                gemLabel.isHidden = false
            }
        }
    }
    
    /// 显示购买的dialog
    @objc func showPayDialog(){
        if payDialog == nil {
            payDialog = PayListDialog(frame: UIScreen.main.bounds)
        }
        payDialog.createView()
        payDialog.show()
        
        /// 回调
        payDialog.paySuccessCallback = {[weak self] in
            self?.getsUserInfo()
        }
    }
    
    /// 获取用户信息
    func getsUserInfo() -> () {
        if Constants.User.USER_ID == "" {
            return
        }
        print("获取用户信息")
        UserTools.getUserInfo(callback: { [weak self] in
            if self?.gemLabel != nil {
                self?.gemLabel.text = String(Constants.User.diamondsCount)
            }
        })
    }
    
    /// 显示意见反馈按钮
    @objc func showFeedbackView() -> () {
        if isShowFeedbackView {
            return
        }
        ToastUtils.showLoadingToast(msg: "请稍后……")
        let feecback = BCFeedbackKit.init(appKey: "24593910", appSecret: "dc313e3a0bf8a0cbcd4288e26e0adc73")
        feecback?.defaultCloseButtonTitleFont = UIFont.systemFont(ofSize: 18)
        feecback?.makeFeedbackViewController(completionBlock: { (vc, error) in
            if vc != nil {
                self.isShowFeedbackView = true
                self.navigationController?.navigationBar.isHidden = false
                vc?.closeBlock = { (feedbackVc) in
                    self.isShowFeedbackView = false
                    self.navigationController?.navigationBar.isHidden = true
                    vc?.navigationController?.popViewController(animated: true)
                }
                self.navigationController?.pushViewController(vc!, animated: true)
                ToastUtils.hide()
            }
        })
    }
    
    /// 返回按钮
    var backBtn:UIButton?{
        set{
            if let newValue = newValue {
                objc_setAssociatedObject(self, &btnsKeys.backBtns, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        get{
            return objc_getAssociatedObject(self, &btnsKeys.backBtns) as? UIButton
        }
    }
    
    /// 返回按钮
    func setupBackBtn() -> () {
        backBtn = UIButton(type: UIButtonType.custom)
        backBtn?.setImage(UIImage(named: "icon_back"), for: .normal)
        backBtn?.sizeToFit()
        view.addSubview(backBtn!)
        backBtn?.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        
        backBtn?.frame = CGRect(x: 10, y: UIApplication.shared.statusBarFrame.height + 10, width: (backBtn?.bounds.width)!, height: (backBtn?.bounds.height)!)
        
        setupDarwCountNumber()
    }
 
    /// 装载抓取次数
    func setupDarwCountNumber() -> () {
        darwCountLabel.text = "游戏0次"
        darwCountLabel.textColor = UIColor.white
        darwCountLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        darwCountLabel.sizeToFit()
        
        darwCountBgView.frame.size = CGSize(width: darwCountLabel.bounds.width * 2, height: darwCountLabel.bounds.height * 1.5)
        darwCountBgView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
        darwCountBgView.layer.cornerRadius = (darwCountLabel.bounds.height * 1.5)/2
        darwCountBgView.layer.masksToBounds = true
        view.addSubview(darwCountBgView)
        
        view.addSubview(darwCountLabel)
        
        darwCountBgView.frame = CGRect(x: self.view.bounds.width - darwCountBgView.bounds.width - 10, y: topGroupView.bounds.height - darwCountBgView.bounds.height - 5, width: darwCountBgView.bounds.width, height: darwCountBgView.bounds.height)
        
        darwCountLabel.center = darwCountBgView.center
    }
    
    /// 更新抓取次数的UI
    func updateDrawUI() -> () {
        darwCountLabel.sizeToFit()
        darwCountBgView.frame.size = CGSize(width: darwCountLabel.bounds.width * 1.5, height: darwCountLabel.bounds.height * 1.5)
        darwCountBgView.frame = CGRect(x: self.view.bounds.width - darwCountBgView.bounds.width - 10, y: topGroupView.bounds.height - darwCountBgView.bounds.height - 5, width: darwCountBgView.bounds.width, height: darwCountBgView.bounds.height)
        
        darwCountLabel.center = darwCountBgView.center
    }
    
    ///关闭当前页面
    @objc func backBtnClick() -> () {
        if isGameing {
            /// 游戏中点击返回键
            outGameDialog.createView()
            outGameDialog.show2 {[weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        self.navigationController?.popViewController(animated: true)
        
        bgMusicPlayer.pause()
        bgMusicPlayer.stop() //暂停音乐
        
        bgMusicPlayer = nil
        
        NotificationCenter.default.removeObserver(self)
        
        agoraKit.stopPreview()
        agoraKit.leaveChannel { (status) in }
        
        gameSceneController.disconnect()
        
        gameSceneController = nil
    }
}


// MARK: - 游戏开始按钮
extension GameSceneViewController{
    
    /// 创建开始游戏的按钮
    func createStartBtn() -> () {
        let startBtnImage = UIImage(named: "icon_start")
        startBtnBackgroundView.frame = CGRect(x: 0, y: topGroupView.bounds.height, width: self.view.bounds.width, height: startBtnImage!.size.height * 1.5 + 25)
        view.addSubview(startBtnBackgroundView)
        
        startPlayBtn.setImage(startBtnImage, for: .normal)
        startPlayBtn.setImage(UIImage(named: "icon_start_h"), for: .highlighted)
        startPlayBtn.setImage(UIImage(named: "正在游戏中"), for: .disabled)
        startPlayBtn.sizeToFit()
        startBtnBackgroundView.addSubview(startPlayBtn)
        
        startPlayBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(startBtnBackgroundView)
            make.right.equalTo(self.view).offset(-10)
        }
        
        startPlayBtn.addTarget(self, action: #selector(waitQueue), for: .touchUpInside)
        
        createQueueNumber()
    }
    
    /// 排队的ui
    func createQueueNumber() -> () {
        playQueueNumberStatus = UIView()
        view.addSubview(playQueueNumberStatus)
        
        let backgroundImage = UIImageView(image: UIImage(named: "正在排队图标"))
        backgroundImage.sizeToFit()
        playQueueNumberStatus.addSubview(backgroundImage)
        
        playQueueStausNumber = MainCustomerLabel()
        playQueueStausNumber.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        playQueueStausNumber.outTextColor = UIColor.white
        playQueueStausNumber.outLienTextColor = UIColor.gray
        playQueueStausNumber.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(16))
        playQueueStausNumber.text = "预约第\(1)位"
        playQueueStausNumber.sizeToFit()
        playQueueNumberStatus.addSubview(playQueueStausNumber)
        
        playQueueNumberStatus.isHidden = true
        
        playQueueStausNumber.snp.makeConstraints { (make) in
            make.center.equalTo(startPlayBtn)
        }
        
        backgroundImage.snp.makeConstraints { (make) in
            make.center.equalTo(startPlayBtn)
        }
        
        playQueueNumberStatus.snp.makeConstraints { (make) in
            make.center.equalTo(startPlayBtn)
        }
    }
    
}

// MARK: - 观看人数和排队人数
extension GameSceneViewController{
    
    func createNumber() -> () {
        let playNumberBackground = UIImageView(image: UIImage(named: "bg_now_play_number"))
        playNumberBackground.sizeToFit()
        startBtnBackgroundView.addSubview(playNumberBackground)
        
        playNumberBackground.snp.makeConstraints { (make) in
            make.top.equalTo(startBtnBackgroundView).offset(10)
            make.left.equalTo(10)
        }
        
        playNumber = MainCustomerLabel()
        playNumber.text = "0人观看"
        playNumber.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        playNumber.outTextColor = UIColor.white
        playNumber.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        playNumber.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        playNumber.sizeToFit()
        startBtnBackgroundView.addSubview(playNumber)
        
        playNumber.snp.makeConstraints { (make) in
            make.left.equalTo(playNumberBackground).offset(playNumberBackground.bounds.width * 0.25)
            make.centerY.equalTo(playNumberBackground)
        }
        
        /// 等待人数
        let queueNumberBackground = UIImageView(image: UIImage(named: "bg_queue"))
        queueNumberBackground.sizeToFit()
        startBtnBackgroundView.addSubview(queueNumberBackground)
        
        queueNumberBackground.snp.makeConstraints { (make) in
            make.left.equalTo(playNumberBackground)
            make.bottom.equalTo(startBtnBackgroundView).offset(-10)
        }
        
        queueNumber = MainCustomerLabel()
        queueNumber.text = "0人等待"
        queueNumber.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        queueNumber.outTextColor = UIColor.white
        queueNumber.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        queueNumber.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        queueNumber.sizeToFit()
        startBtnBackgroundView.addSubview(queueNumber)
        
        queueNumber.snp.makeConstraints { (make) in
            make.centerY.equalTo(queueNumberBackground)
            make.left.equalTo(queueNumberBackground).offset(queueNumberBackground.bounds.width * 0.25)
        }
    }
}

/// 底部介绍
extension GameSceneViewController{
    
    /// 底部展示奖品的view
    func createBottomGroup() -> () {
        bottomGroupView.frame = CGRect(x: 0, y: UIScreen.main.bounds.width + startBtnBackgroundView.bounds.height, width: self.view.bounds.width, height: UIScreen.main.bounds.height - UIScreen.main.bounds.width + UIApplication.shared.statusBarFrame.height - startBtnBackgroundView.bounds.height)
        
        let cardWidth = (bottomGroupView.bounds.width - 20*2 - 20)/2.1
        
        ///奖品card
        bottomAwardCard = UIView()
        bottomAwardCard.backgroundColor = UIColor.white
        bottomAwardCard.layer.masksToBounds = true
        bottomAwardCard.layer.cornerRadius = 4
        bottomGroupView.addSubview(bottomAwardCard)
        
        bottomAwardCard.snp.makeConstraints { (make) in
            make.width.equalTo(cardWidth)
            make.height.equalTo(cardWidth)
            make.centerY.equalTo(bottomGroupView)
            make.left.equalTo(bottomGroupView).offset(15)
        }
        
        let bottomAwardImage = UIImageView()
        bottomAwardImage.layer.cornerRadius = 3
        bottomAwardImage.layer.masksToBounds = true
        bottomAwardImage.backgroundColor = UIColor.red
        bottomAwardCard.addSubview(bottomAwardImage)
        
        bottomAwardImage.snp.makeConstraints { (make) in
            make.width.equalTo(cardWidth*0.95)
            make.height.equalTo(cardWidth*0.95)
            make.center.equalTo(bottomAwardCard)
        }
        
        bottomAwardImage.kf.setImage(with: URL(string: bottomAwardCardImagePath), placeholder: UIImage(named: "main_no_value"), options: nil, progressBlock: nil, completionHandler: nil)
        
        let awardTap = UITapGestureRecognizer(target: self, action: #selector(showAwardInfo))
        bottomAwardCard.addGestureRecognizer(awardTap)
        
        /// banner card
        bottomBannerCard = UIView()
        bottomBannerCard.backgroundColor = UIColor.white
        bottomBannerCard.layer.masksToBounds = true
        bottomBannerCard.layer.cornerRadius = 4
        bottomGroupView.addSubview(bottomBannerCard)
        
        bottomBannerCard.snp.makeConstraints { (make) in
            make.width.equalTo(cardWidth)
            make.height.equalTo(cardWidth)
            make.centerY.equalTo(bottomGroupView)
            make.right.equalTo(bottomGroupView).offset(-15)
        }
        
        let bottomBannerImage = UIImageView()
        bottomBannerImage.layer.cornerRadius = 3
        bottomBannerImage.layer.masksToBounds = true
        bottomBannerImage.backgroundColor = UIColor.red
        bottomBannerCard.addSubview(bottomBannerImage)
        
        bottomBannerImage.snp.makeConstraints { (make) in
            make.width.equalTo(cardWidth*0.95)
            make.height.equalTo(cardWidth*0.95)
            make.center.equalTo(bottomBannerCard)
        }
        
        bottomBannerImage.kf.setImage(with: URL(string: bootomBannerCardImagePath), placeholder: UIImage(named: "main_no_value"), options: nil, progressBlock: nil, completionHandler: nil)
        
        let bannerTap = UITapGestureRecognizer(target: self, action: #selector(showBannerInfo))
        bottomBannerCard.addGestureRecognizer(bannerTap)
        
    }
    
    @objc func showBannerInfo() -> () {
        if bottomBannerCardScheme == "" {
            return
        }
        if bottomBannerDialog == nil {
            bottomBannerDialog = PlayInfoBannerDialog(frame: UIScreen.main.bounds)
        }
        bottomBannerDialog.createView()
        bottomBannerDialog.showUrl(link:bottomBannerCardScheme)
    }
    
    @objc func showAwardInfo() -> () {
        if bottomAwardDialog == nil {
            bottomAwardDialog = PlayInfoAwardDialog(frame: UIScreen.main.bounds)
        }
        bottomAwardDialog.createView()
        bottomAwardDialog.showInfo(title: bottomAwardTitle, description: bootomAwardDescription, imagePath: bottomAwardCardImagePath)
    }
    
}





