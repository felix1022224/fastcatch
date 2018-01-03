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
        
        rootView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        view.addSubview(rootView)
        
        //顶部的view
        topGroupView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width-10)/3 + UIScreen.main.bounds.width - 17)
        rootView.addSubview(topGroupView)
        
        //底部的view
        bottomGroupView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width, width: self.view.bounds.width, height: UIScreen.main.bounds.height - UIScreen.main.bounds.width + UIApplication.shared.statusBarFrame.height))
        rootView.addSubview(bottomGroupView)
        
        bottomGroupView.isHidden = true
        
        setupTopView()
        
        createPlayUserInfo()
        
        setupBottomView()
        
        createQueueNumber()
        
        rootView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: topGroupView.bounds.height + startBtnBackgroundView.bounds.height + productBackgroundView.bounds.height + bottomActivityGroup.bounds.height)
    }
    
    /// 创建背景板
    func createBackground() -> () {
        backgroundView.frame = self.view.bounds
        view.addSubview(backgroundView)
        
        let backgroundImageView = UIImageView(image: UIImage(named: "main_background"))
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        view.addSubview(backgroundImageView)
        
        var playGameBackgroundImage:UIImageView
        if isDurexTheme {
            playGameBackgroundImage = UIImageView(image: UIImage(named: "杜蕾斯-竖版游戏页背景"))
        }else{
            let blueBackgroundImage = UIImage(named: "play_game_background_blue")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
            playGameBackgroundImage = UIImageView(image: blueBackgroundImage)
        }
        
        playGameBackgroundImage.sizeToFit()
        playGameBackgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(playGameBackgroundImage)
        
    }
    
    //装载底部的view
    func setupBottomView() -> () {
        if advertiseImg != "" {
            createBottomActivityGroup()
        }
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
        
        let liveBackgroundView = UIImageView()
        liveBackgroundView.image = UIImage(named: "视频框")
        liveBackgroundView.sizeToFit()
        liveBackgroundView.frame = CGRect(x: 5, y: 0, width: UIScreen.main.bounds.width - 10 , height: (UIScreen.main.bounds.width-10)/3 + UIScreen.main.bounds.width - 10 )
        topGroupView.addSubview(liveBackgroundView)
        
        // 直播的view
        liveView.backgroundColor = UIColor.black
        liveView.layer.masksToBounds = true
        liveView.layer.cornerRadius = 8
        topGroupView.addSubview(liveView)
        
        liveView.snp.makeConstraints { (make) in
            make.center.equalTo(liveBackgroundView)
            make.width.equalTo(liveBackgroundView.bounds.width * 0.96)
            make.height.equalTo(liveBackgroundView.bounds.height * 0.97)
        }
        
        // 初始化直播的框架
        initLive()
        
        setupBtns()
        
        let startBtnImage = UIImage(named: "进入")
        startBtnBackgroundView.frame = CGRect(x: 0, y: topGroupView.bounds.height, width: self.view.bounds.width, height: startBtnImage!.size.height * 1.5 + 25)
        rootView.addSubview(startBtnBackgroundView)
        
        createNumber()
        
        createStartBtn()
        
        createReStartTimeLabel()
        
        createPlayControllerView()
        
        setupCoinNumber()
    }
    
    /// 装载按钮
    func setupBtns() -> () {
        setupBackBtn()
        
        /// 问号按钮
        let helpBtn = UIButton(type: .custom)
        helpBtn.setImage(UIImage(named: "icon_qa"), for: .normal)
        helpBtn.sizeToFit()
        rootView.addSubview(helpBtn)
        
        helpBtn.addTarget(self, action: #selector(showFeedbackView), for: .touchUpInside)
        
        helpBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(liveView).offset(-30)
            make.left.equalTo(liveView).offset(5)
        }
        
        /// 切换摄像头
        lensBtn.setImage(UIImage(named: "icon_lens"), for: .normal)
        lensBtn.sizeToFit()
        rootView.addSubview(lensBtn)
        
        lensBtn.addTarget(self, action: #selector(switchCamare), for: .touchUpInside)
        
        lensBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(helpBtn)
            make.right.equalTo(liveView).offset(-5)
        }
        
        /// 音频按钮
        audioBtn = UIButton(type: .custom)
        audioBtn.setImage(UIImage(named: "icon_audio"), for: .normal)
        audioBtn.sizeToFit()
        rootView.addSubview(audioBtn)
        
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
        topGroupView.addSubview(gemBackground)
        
        gemBackground.snp.makeConstraints { (make) in
            make.centerY.equalTo(backBtn!).offset(-4)
            make.right.equalTo(liveView).offset(-5)
        }
        
        gemLabel.text = String(Constants.User.diamondsCount)
        gemLabel.outLineWidth = 1
        gemLabel.outTextColor = UIColor.white
        gemLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        gemLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 11)
        topGroupView.addSubview(gemLabel)
        
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
        topGroupView.addSubview(backBtn!)
        backBtn?.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        
//        backBtn?.frame = CGRect(x: 10, y: UIApplication.shared.statusBarFrame.height + 10, width: (backBtn?.bounds.width)!, height: (backBtn?.bounds.height)!)
        
        backBtn?.snp.makeConstraints({ (make) in
            make.left.equalTo(liveView).offset(5)
            make.top.equalTo(liveView).offset(5)
        })
        
        setupDarwCountNumber()
    }
 
    /// 装载抓取次数
    func setupDarwCountNumber() -> () {
        darwCountLabel.text = "游戏0次"
        darwCountLabel.textColor = UIColor.white
        darwCountLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
        darwCountLabel.sizeToFit()
        
        darwCountBgView.frame.size = CGSize(width: darwCountLabel.bounds.width * 2, height: darwCountLabel.bounds.height * 1.5)
        darwCountBgView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
        darwCountBgView.layer.cornerRadius = (darwCountLabel.bounds.height * 1.5)/2
        darwCountBgView.layer.masksToBounds = true
        topGroupView.addSubview(darwCountBgView)
        
        topGroupView.addSubview(darwCountLabel)
        
        darwCountBgView.frame = CGRect(x: self.view.bounds.width - darwCountBgView.bounds.width - 18, y: topGroupView.bounds.height - darwCountBgView.bounds.height - 5, width: darwCountBgView.bounds.width, height: darwCountBgView.bounds.height)
        
        darwCountLabel.center = darwCountBgView.center
    }
    
    /// 更新抓取次数的UI
    func updateDrawUI() -> () {
        darwCountLabel.sizeToFit()
        darwCountBgView.frame.size = CGSize(width: darwCountLabel.bounds.width * 1.5, height: darwCountLabel.bounds.height * 1.5)
        darwCountBgView.frame = CGRect(x: self.view.bounds.width - darwCountBgView.bounds.width - 18, y: topGroupView.bounds.height - darwCountBgView.bounds.height - 5, width: darwCountBgView.bounds.width, height: darwCountBgView.bounds.height)
        
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
        let startBtnImage = UIImage(named: "进入")
        startPlayBtn.setImage(startBtnImage, for: .normal)
        startPlayBtn.setImage(UIImage(named: "进入点击"), for: .highlighted)
        startPlayBtn.setImage(UIImage(named: "正在游戏中"), for: .disabled)
        startPlayBtn.sizeToFit()
        rootView.addSubview(startPlayBtn)
        
        rootView.isUserInteractionEnabled = true
        startBtnBackgroundView.isUserInteractionEnabled = true
        
        startPlayBtn.snp.makeConstraints { (make) in
            make.top.equalTo(topGroupView).offset(topGroupView.bounds.height + 10)
            make.right.equalTo(self.view).offset(-10)
        }
        
        startPlayBtn.addTarget(self, action: #selector(waitQueue), for: .touchUpInside)
        
    }
    
    /// 排队的ui
    func createQueueNumber() -> () {
        playQueueNumberStatus = UIView()
        view.addSubview(playQueueNumberStatus)
        
        quitBtn.setBackgroundImage(UIImage(named: "取消排队"), for: .normal)
        quitBtn.setBackgroundImage(UIImage(named: "取消排队点击"), for: .highlighted)
        quitBtn.sizeToFit()
        
        quitBtn.addTarget(self, action: #selector(quitGameQueue), for: .touchUpInside)
        
        rootView.addSubview(quitBtn)
        
        playQueueNumberStatus.isUserInteractionEnabled = true
        
        quitBtn.snp.makeConstraints { (make) in
            make.center.equalTo(startPlayBtn)
        }
        
        ///排队人数的显示文案
        playQueueStausNumber = MainCustomerLabel()
        playQueueStausNumber.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        playQueueStausNumber.outTextColor = UIColor.white
        playQueueStausNumber.outLienTextColor = UIColor.gray
        playQueueStausNumber.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        playQueueStausNumber.text = "排队第0位..."
        playQueueStausNumber.sizeToFit()
        playQueueNumberStatus.addSubview(playQueueStausNumber)
        
        quitBtn.isHidden = true
        playQueueNumberStatus.isHidden = true
        
        playQueueStausNumber.snp.makeConstraints { (make) in
            make.centerX.equalTo(coinNumber)
            make.bottom.equalTo(coinNumber).offset(2)
        }
    }
    
    ///退出游戏队列
    @objc func quitGameQueue() -> () {
        /// 隐藏排队界面
        quitBtn.isHidden = true
        playQueueNumberStatus.isHidden = true
        
        /// socket执行退出队列
        gameSceneController.quitQueue()
        
        /// 修改开始游戏按钮的状态
        startPlayBtn.isEnabled = true
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
        playNumber.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
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
            make.bottom.equalTo(startBtnBackgroundView).offset(-5)
        }
        
        queueNumber = MainCustomerLabel()
        queueNumber.text = "0人等待"
        queueNumber.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        queueNumber.outTextColor = UIColor.white
        queueNumber.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        queueNumber.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
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
    
    /// 创建关联的活动
    func createBottomActivityGroup() -> () {
        /// 活动标题
        let activityTitleImage = UIImageView(image: UIImage(named: "活动标题"))
        activityTitleImage.frame.origin = CGPoint(x: 14, y: 0)
        activityTitleImage.sizeToFit()
        bottomActivityGroup.addSubview(activityTitleImage)
        
        /// 活动背景图
        let activityBackgroundImage = UIImageView(image: UIImage(named: "游戏页广告框"))
        let backgroundWidth = UIScreen.main.bounds.width - 8 * 2
        activityBackgroundImage.frame = CGRect(x: UIScreen.main.bounds.width/2 - backgroundWidth/2, y: activityTitleImage.bounds.height + 5, width: backgroundWidth, height: backgroundWidth * 0.4)
        bottomActivityGroup.addSubview(activityBackgroundImage)
        
        /// 活动图
        let activityImage = UIImageView()
        activityImage.frame = CGRect(x: 0, y: 0, width: activityBackgroundImage.bounds.width * 0.96, height: activityBackgroundImage.bounds.height * 0.88)
        activityImage.center = activityBackgroundImage.center
        bottomActivityGroup.addSubview(activityImage)
        
        activityImage.backgroundColor = UIColor.red
        activityImage.layer.masksToBounds = true
        activityImage.layer.cornerRadius = 8
        
        activityImage.kf.setImage(with: URL(string: advertiseImg))
        
        activityImage.isUserInteractionEnabled = true
        
        let activityTap = UITapGestureRecognizer(target: self, action: #selector(clickActivityInfo))
        activityImage.addGestureRecognizer(activityTap)
        
        rootView.addSubview(bottomActivityGroup)
        
        bottomActivityGroup.frame = CGRect(x: 0, y: topGroupView.bounds.height + startBtnBackgroundView.bounds.height + 5, width: UIScreen.main.bounds.width, height: activityTitleImage.bounds.height + activityBackgroundImage.bounds.height)
        
    }
    
    /// 点击活动图
    @objc func clickActivityInfo() -> () {
        if  redirectType == 1 {
            /// 跳转到网页
            let link = bottomBannerCardScheme
            // 跳转到网页
            if link == "" {
                return
            }
            let webVC = WebViewController()
            webVC.link = link
            webVC.shareTitle = shareTitle
            webVC.shareInfo = shareInfo
            webVC.thumbShareImage = thumbShareImage
            webVC.actionTitle = bottomBannerCardTitle
            self.navigationController?.pushViewController(webVC, animated: true)
        }else if redirectType == 3 {
            /// 打开站外链接
            //根据iOS系统版本，分别处理
            if let url = URL(string: bottomBannerCardScheme!) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],completionHandler: {(success) in })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }else if redirectType == 2{
            // 其他
            let link = Int(bottomBannerCardScheme)
            if link == -1 {
                showPayDialog()
                return
            }
        }
    }
    
    /// 底部展示奖品的view
    func createBottomGroup() -> () {
        
        productBottomGroup.frame = CGRect(x: 5, y: topGroupView.bounds.height + startBtnBackgroundView.bounds.height + bottomActivityGroup.bounds.height + 10, width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.width - 10)
        
        productBackgroundView.image = UIImage(named: "底部产品框")
        productBackgroundView.sizeToFit()
        productBackgroundView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.width - 10)
        
        productBottomGroup.addSubview(productBackgroundView)
        
        let productImage = UIImageView(image: UIImage(named: "底部产品框"))
        productImage.frame.size = CGSize(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.width * 0.6)
        productImage.frame = CGRect(x: productBackgroundView.bounds.width/2 - productImage.bounds.width/2, y: 20, width: productImage.bounds.width, height: productImage.bounds.height)
        
        productImage.kf.setImage(with: URL(string: bottomAwardCardImagePath), placeholder: UIImage(named: "main_no_value"), options: nil, progressBlock: nil, completionHandler: nil)
        
        productBottomGroup.addSubview(productImage)
        
        let productInfoLabel = MainCustomerLabel()
        productInfoLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        productInfoLabel.outTextColor = UIColor.white
        productInfoLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        productInfoLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 16)
        productInfoLabel.text = bottomAwardTitle + "\n" + bootomAwardDescription
        productInfoLabel.numberOfLines = 0
        productInfoLabel.textAlignment = .center
        productInfoLabel.sizeToFit()
        productBottomGroup.addSubview(productInfoLabel)
        
        productInfoLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(productBottomGroup)
            make.width.equalTo(productBottomGroup.bounds.width - 35)
            make.top.equalTo(productImage).offset(10 + productImage.bounds.height)
        }
        
        rootView.addSubview(productBottomGroup)
    
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

// MARK: - 装载需要扣的游戏币
extension GameSceneViewController{
    
    func setupCoinNumber() -> () {
        
        startBtnBackgroundView.addSubview(coinNumber)
        
        let coinContentGroup = UIView()
        coinNumber.addSubview(coinContentGroup)
        
        let coinImage = UIImageView(image: UIImage(named: "Coinicon拷贝"))
        coinImage.sizeToFit()
        coinImage.frame = CGRect(x: 0, y: 0, width: coinImage.bounds.width, height: coinImage.bounds.height)
        coinContentGroup.addSubview(coinImage)
        
        coinNumberLabel.text = String(startCoinNumber) + "币/次"
        coinNumberLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        coinNumberLabel.outTextColor = UIColor.white
        coinNumberLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        coinNumberLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        coinNumberLabel.sizeToFit()
        coinContentGroup.addSubview(coinNumberLabel)
        
        coinNumberLabel.frame = CGRect(x: coinImage.bounds.width + 5, y: -3, width: coinNumberLabel.bounds.width, height: coinNumberLabel.bounds.height)
        
        coinNumber.snp.makeConstraints { (make) in
            make.width.equalTo(startPlayBtn.bounds.width)
            make.right.equalTo(view).offset(-10)
            make.bottom.equalTo(queueNumber)
            make.height.equalTo(startPlayBtn.bounds.height)
        }
        
        coinContentGroup.snp.makeConstraints { (make) in
            make.centerX.equalTo(coinNumber)
            make.bottom.equalTo(coinNumber)
            make.width.equalTo(5 + coinImage.bounds.width + coinNumberLabel.bounds.width)
            make.height.equalTo(15)
        }
        
    }
    
}



