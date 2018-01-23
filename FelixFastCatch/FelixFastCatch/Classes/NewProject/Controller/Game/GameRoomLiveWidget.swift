//
//  GameRoomLiveWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/22.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

extension GameRoomViewController{
    
    private struct liveKeys {
        static var ids = "liveBroadcastingIdsKey"
        static var mainLiveCamareId = "mainLiveCamareIdKey"
        static var sideLiveCamareId = "sideLiveCamareIdKey"
        static var nowLiveCamareId = "nowLiveCamareIdKey"
    }
    
    /// 主摄像头Id
    var mainLiveCamare:UInt?{
        set{
            if let newValue = newValue {
                objc_setAssociatedObject(self, &liveKeys.mainLiveCamareId, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        get{
            return objc_getAssociatedObject(self, &liveKeys.mainLiveCamareId) as? UInt
        }
    }
    
    /// 侧面摄像头Id
    var sideLiveCamare:UInt?{
        set{
            if let newValue = newValue {
                objc_setAssociatedObject(self, &liveKeys.sideLiveCamareId, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        get{
            return objc_getAssociatedObject(self, &liveKeys.sideLiveCamareId) as? UInt
        }
    }
    
    /// 当前摄像头Id
    var nowLiveCamare:UInt?{
        set{
            if let newValue = newValue {
                objc_setAssociatedObject(self, &liveKeys.nowLiveCamareId, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        get{
            return objc_getAssociatedObject(self, &liveKeys.nowLiveCamareId) as? UInt
        }
    }
    
    /// 初始化直播view
    func initLiveView() {
        
        liveView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width + UIScreen.main.bounds.width / 3)
        liveView.backgroundColor = UIColor.white
        
        let backgroundView = UIImageView()
        backgroundView.frame = CGRect(x: 0, y: liveView.bounds.height * 0.85, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.65)
        backgroundView.image = UIImage(named: "游戏界面底部背景")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        rootView.addSubview(backgroundView)
        
        rootView.addSubview(liveView)
        
        liveView.corner(byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radii: 25)
        
        createLiveBtns()
        
        initLive()
    }
    
    func createLiveBtns() {
        switchCamareBtn = UIButton(type: UIButtonType.custom)
        switchCamareBtn.setBackgroundImage(UIImage.init(named: "相机切换icon"), for: UIControlState.normal)
        switchCamareBtn.sizeToFit()
        switchCamareBtn.frame = CGRect(x: UIScreen.main.bounds.width - switchCamareBtn.bounds.width, y: liveView.bounds.height/2 - switchCamareBtn.bounds.height/2, width: switchCamareBtn.bounds.width, height: switchCamareBtn.bounds.height)
        
        rootView.addSubview(switchCamareBtn)
        
        switchCamareBtn.addTarget(self, action: #selector(switchCamare), for: UIControlEvents.touchUpInside)
        
        backBtn.setBackgroundImage(UIImage.init(named: "游戏界面返回"), for: UIControlState.normal)
        backBtn.sizeToFit()
        backBtn.frame.origin = CGPoint(x: 14, y: statusHeight + 20)
        rootView.addSubview(backBtn)
        
        backBtn.addTarget(self, action: #selector(closeView), for: UIControlEvents.touchUpInside)
        
        createGemNumber()
        createHelpBtn()
        createAudioButton()
        createGameRoomNumbers()
    }
    
    @objc func closeView(){
        self.navigationController?.popViewController(animated: true)
        
        agoraKit.stopPreview()
        agoraKit.leaveChannel { (status) in }
    }
    
    /// 创建帮助按钮
    func createHelpBtn() {
        helpBtn.setBackgroundImage(UIImage.init(named: "疑问"), for: UIControlState.normal)
        helpBtn.sizeToFit()
        rootView.addSubview(helpBtn)
        
        helpBtn.frame = CGRect(x: UIScreen.main.bounds.width - 10 - helpBtn.bounds.width, y: liveView.bounds.height - helpBtn.bounds.height - 25, width: helpBtn.bounds.width, height: helpBtn.bounds.height)
        
        helpBtn.addTarget(self, action: #selector(showFeedbackView), for: .touchUpInside)
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
                self.navigationController?.isNavigationBarHidden = false
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
    
    /// 创建音频按钮
    func createAudioButton() {
        audioBtn.setBackgroundImage(UIImage.init(named: "声音"), for: UIControlState.normal)
        audioBtn.setBackgroundImage(UIImage.init(named: "静音"), for: UIControlState.selected)
        
        audioBtn.sizeToFit()
        audioBtn.frame.origin = CGPoint(x: UIScreen.main.bounds.width - helpBtn.bounds.width - 20 - audioBtn.bounds.width, y: helpBtn.frame.origin.y)
        
        rootView.addSubview(audioBtn)
        
        audioBtn.addTarget(self, action: #selector(switchAudio), for: UIControlEvents.touchUpInside)
        
        if UserDefaults.standard.bool(forKey: Constants.User.USER_AUDIO_SETTING) == false {
            isCloseMusic = false
            audioBtn.isSelected = false
        }else{
            isCloseMusic = true
            audioBtn.isSelected = true
        }
    }
    
    /// 切换音频按钮
    @objc func switchAudio() -> () {
        if isCloseMusic {
            bgMusicPlayer.play()
            isCloseMusic = false
            audioBtn.isSelected = false
            UserDefaults.standard.set(false, forKey: Constants.User.USER_AUDIO_SETTING)
        }else{
            bgMusicPlayer.pause()
            isCloseMusic = true
            audioBtn.isSelected = true
            UserDefaults.standard.set(true, forKey: Constants.User.USER_AUDIO_SETTING)
        }
    }
    
    /// 创建观看和游戏次数的view
    func createGameRoomNumbers() {
        watchNumber.image = UIImage.init(named: "观看人数icon")
        watchNumber.sizeToFit()
        gameRoomNumberGroupView.addSubview(watchNumber)
        
        watchNumberLabel.font = UIFont.systemFont(ofSize: 12)
        watchNumberLabel.textColor = UIColor.white
        watchNumberLabel.text = "0人"
        watchNumberLabel.sizeToFit()
        gameRoomNumberGroupView.addSubview(watchNumberLabel)
        
        queueNumber.image = UIImage.init(named: "排队人数icon")
        queueNumber.sizeToFit()
        gameRoomNumberGroupView.addSubview(queueNumber)
        
        queueNumberLabel.font = UIFont.systemFont(ofSize: 12)
        queueNumberLabel.textColor = UIColor.white
        queueNumberLabel.text = "0人"
        queueNumberLabel.sizeToFit()
        gameRoomNumberGroupView.addSubview(queueNumberLabel)
        
        gameNumber.image = UIImage.init(named: "游戏次数")
        gameNumber.sizeToFit()
        gameRoomNumberGroupView.addSubview(gameNumber)
        
        gameNumberLabel.font = UIFont.systemFont(ofSize: 12)
        gameNumberLabel.textColor = UIColor.white
        gameNumberLabel.text = "共0次"
        gameNumberLabel.sizeToFit()
        gameRoomNumberGroupView.addSubview(gameNumberLabel)
        
        gameRoomNumberGroupView.frame.size = CGSize(width: gameNumber.bounds.width + gameNumberLabel.bounds.width + queueNumber.bounds.width + queueNumberLabel.bounds.width + watchNumber.bounds.width + watchNumberLabel.bounds.width + 35, height: 30)
        gameRoomNumberGroupView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        gameRoomNumberGroupView.layer.cornerRadius = 15
        
        gameRoomNumberGroupView.frame.origin = CGPoint(x: 10, y: helpBtn.frame.origin.y + helpBtn.bounds.height/2 - gameRoomNumberGroupView.bounds.height/2)
        
        rootView.addSubview(gameRoomNumberGroupView)
        
        updateGameRoomNumbers(watchNumberStr: "0人", queueNumberStr: "0人")
        updateGameNumber(gameNumberStr: "共0次")
    }
    
    /// 更新观看和游戏的次数
    func updateGameRoomNumbers(watchNumberStr:String, queueNumberStr:String) {
        watchNumberLabel.text = watchNumberStr
        queueNumberLabel.text = queueNumberStr
        
        watchNumberLabel.sizeToFit()
        queueNumberLabel.sizeToFit()
        
        gameRoomNumberGroupView.frame.size = CGSize(width: gameNumber.bounds.width + gameNumberLabel.bounds.width + queueNumber.bounds.width + queueNumberLabel.bounds.width + watchNumber.bounds.width + watchNumberLabel.bounds.width + 45, height: 30)
        
        watchNumber.frame.origin = CGPoint(x: 10, y: gameRoomNumberGroupView.bounds.height/2 - watchNumber.bounds.height/2)
        watchNumberLabel.frame.origin = CGPoint(x: watchNumber.bounds.width + 10 + 5, y: gameRoomNumberGroupView.bounds.height/2 - watchNumberLabel.bounds.height/2)
        
        queueNumber.frame.origin = CGPoint(x: 10 + 5 * 2 + watchNumber.bounds.width + watchNumberLabel.bounds.width, y: gameRoomNumberGroupView.bounds.height/2 - queueNumber.bounds.height/2)
        queueNumberLabel.frame.origin = CGPoint(x: 10 + 5 * 3 + watchNumber.bounds.width + watchNumberLabel.bounds.width + queueNumber.bounds.width, y: gameRoomNumberGroupView.bounds.height/2 - queueNumberLabel.bounds.height/2)
        
        gameNumber.frame.origin = CGPoint(x: 10 + 5 * 4 + watchNumber.bounds.width + watchNumberLabel.bounds.width + queueNumber.bounds.width + queueNumberLabel.bounds.width, y: gameRoomNumberGroupView.bounds.height/2 - gameNumber.bounds.height/2)
        gameNumberLabel.frame.origin = CGPoint(x: 10 + 5 * 5 + watchNumber.bounds.width + watchNumberLabel.bounds.width + queueNumber.bounds.width + queueNumberLabel.bounds.width + gameNumber.bounds.width, y: gameRoomNumberGroupView.bounds.height/2 - gameNumberLabel.bounds.height/2)
    }
    
    func updateGameNumber(gameNumberStr:String) {
        gameNumberLabel.text = gameNumberStr
        gameNumberLabel.sizeToFit()
        
        gameRoomNumberGroupView.frame.size = CGSize(width: gameNumber.bounds.width + gameNumberLabel.bounds.width + queueNumber.bounds.width + queueNumberLabel.bounds.width + watchNumber.bounds.width + watchNumberLabel.bounds.width + 45, height: 30)
        
        watchNumber.frame.origin = CGPoint(x: 10, y: gameRoomNumberGroupView.bounds.height/2 - watchNumber.bounds.height/2)
        watchNumberLabel.frame.origin = CGPoint(x: watchNumber.bounds.width + 10 + 5, y: gameRoomNumberGroupView.bounds.height/2 - watchNumberLabel.bounds.height/2)
        
        queueNumber.frame.origin = CGPoint(x: 10 + 5 * 2 + watchNumber.bounds.width + watchNumberLabel.bounds.width, y: gameRoomNumberGroupView.bounds.height/2 - queueNumber.bounds.height/2)
        queueNumberLabel.frame.origin = CGPoint(x: 10 + 5 * 3 + watchNumber.bounds.width + watchNumberLabel.bounds.width + queueNumber.bounds.width, y: gameRoomNumberGroupView.bounds.height/2 - queueNumberLabel.bounds.height/2)
        
        gameNumber.frame.origin = CGPoint(x: 10 + 5 * 4 + watchNumber.bounds.width + watchNumberLabel.bounds.width + queueNumber.bounds.width + queueNumberLabel.bounds.width, y: gameRoomNumberGroupView.bounds.height/2 - gameNumber.bounds.height/2)
        gameNumberLabel.frame.origin = CGPoint(x: 10 + 5 * 5 + watchNumber.bounds.width + watchNumberLabel.bounds.width + queueNumber.bounds.width + queueNumberLabel.bounds.width + gameNumber.bounds.width, y: gameRoomNumberGroupView.bounds.height/2 - gameNumberLabel.bounds.height/2)
    }
    
    /// 创建金币框
    func createGemNumber() {
        
        goldIcon.image = UIImage.init(named: "金币gold")
        goldIcon.sizeToFit()
        goldGroupView.addSubview(goldIcon)
        
        goldNumber.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        goldNumber.textColor = Constants.UI.GEM_TEXT_COLOR
        goldNumber.text = String(Constants.User.diamondsCount)
        goldNumber.sizeToFit()
        goldGroupView.addSubview(goldNumber)
        
        payButton = UIButton(type: UIButtonType.custom)
        payButton.setBackgroundImage(UIImage.init(named: "游戏界面充值"), for: UIControlState.normal)
        payButton.sizeToFit()
        goldGroupView.addSubview(payButton)
        
        payButton.addTarget(self, action: #selector(showPayVC), for: UIControlEvents.touchUpInside)
        
        goldGroupView.frame.size = CGSize(width: goldIcon.bounds.width + goldNumber.bounds.width + payButton.bounds.width + 20, height: payButton.bounds.height + 5)
        goldGroupView.frame.origin = CGPoint(x: UIScreen.main.bounds.width - goldGroupView.bounds.width - 10, y: backBtn.frame.origin.y + backBtn.bounds.height/2 - goldGroupView.bounds.height/2)
        
        goldGroupView.backgroundColor = UIColor.white
        goldGroupView.layer.cornerRadius = goldGroupView.bounds.height/2
        
        payButton.frame.origin = CGPoint(x: goldGroupView.bounds.width - 2 - payButton.bounds.width, y: goldGroupView.bounds.height/2 - payButton.bounds.height/2)
        
        goldIcon.frame.origin = CGPoint(x: 4, y: goldGroupView.bounds.height/2 - goldIcon.bounds.height/2)
        
        goldNumber.frame.origin = CGPoint(x: 4 + goldIcon.bounds.width + 4, y: goldGroupView.bounds.height/2 - goldNumber.bounds.height/2)
        
        rootView.addSubview(goldGroupView)
        
        goldGroupView.isHidden = true
        
        if Constants.User.ID != "" {
            goldGroupView.isHidden = false
        }
    }
    
    /// 显示充值页面
    @objc func showPayVC() {
    
    }
    
    /// 更新金币view
    func updateGoldNumberView() {
        goldNumber.text = String(Constants.User.diamondsCount)
        goldNumber.sizeToFit()
        
        goldGroupView.frame.size = CGSize(width: goldIcon.bounds.width + goldNumber.bounds.width + payButton.bounds.width + 20, height: payButton.bounds.height + 5)
        goldGroupView.frame.origin = CGPoint(x: UIScreen.main.bounds.width - goldGroupView.bounds.width - 10, y: backBtn.frame.origin.y + backBtn.bounds.height/2 - goldGroupView.bounds.height/2)
        
        payButton.frame.origin = CGPoint(x: goldGroupView.bounds.width - 2 - payButton.bounds.width, y: goldGroupView.bounds.height/2 - payButton.bounds.height/2)
        
        goldIcon.frame.origin = CGPoint(x: 4, y: goldGroupView.bounds.height/2 - goldIcon.bounds.height/2)
        
        goldNumber.frame.origin = CGPoint(x: 4 + goldIcon.bounds.width + 4, y: goldGroupView.bounds.height/2 - goldNumber.bounds.height/2)
    }
    
    func initLive() -> () {
        mainLiveCamare = UInt(deviceId)! + 1
        sideLiveCamare = UInt(deviceId)! + 2
        
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "a61c87d429a748cfbdae28178e082289", delegate: self)
        
        /// 默认是直播模式
        agoraKit.setChannelProfile(AgoraRtcChannelProfile.channelProfile_LiveBroadcasting)
        agoraKit.enableDualStreamMode(true)
        
        agoraKit.disableAudio()
        
        agoraKit.enableLocalVideo(false)
        agoraKit.setupLocalVideo(nil)
        agoraKit.enableVideo()
        
        agoraKit.setVideoProfile(._VideoProfile_480P, swapWidthAndHeight: false)
        agoraKit.setClientRole(AgoraRtcClientRole.clientRole_Audience, withKey: nil)
        
        let code = agoraKit.joinChannel(byKey: nil, channelName: deviceId, info: nil, uid: 0, joinSuccess: nil)
        
        if code != 0 {
            DispatchQueue.main.async(execute: {
                print("Join channel failed: \(code)")
            })
        }else {
            print("进入直播房间成功:\(code)")
            let canvas = AgoraRtcVideoCanvas()
            canvas.view = liveView
            canvas.uid = mainLiveCamare!
            canvas.renderMode = .render_Hidden
            
            agoraKit.setRemoteVideoStream(mainLiveCamare!, type: .videoStream_High)
            agoraKit.setupRemoteVideo(canvas)
            
            nowLiveCamare = mainLiveCamare
        }
    }
    
    /// 切换摄像头
    @objc func switchCamare() -> () {
        if mainLiveCamare == nowLiveCamare {
            let canvas = AgoraRtcVideoCanvas()
            canvas.view = liveView
            canvas.uid = sideLiveCamare!
            canvas.renderMode = .render_Hidden
            
            agoraKit.setRemoteVideoStream(sideLiveCamare!, type: .videoStream_High)
            agoraKit.setupRemoteVideo(canvas)
            
            nowLiveCamare = sideLiveCamare
            
            nowCamareDirection = 2
        }else{
            let canvas = AgoraRtcVideoCanvas()
            canvas.view = liveView
            canvas.uid = mainLiveCamare!
            canvas.renderMode = .render_Hidden
            
            agoraKit.setRemoteVideoStream(mainLiveCamare!, type: .videoStream_High)
            agoraKit.setupRemoteVideo(canvas)
            
            nowLiveCamare = mainLiveCamare
            
            nowCamareDirection = 1
        }
    }
    
    /// 切换到游戏模式
    func switchGameMode() -> () {
        agoraKit.setClientRole(AgoraRtcClientRole.clientRole_Broadcaster, withKey: nil)
        agoraKit.joinChannel(byKey: nil, channelName: deviceId, info: nil, uid: 0, joinSuccess: nil)
    }
    
    /// 切换到非游戏模式
    func switchNotGameMode() -> () {
        agoraKit.setClientRole(AgoraRtcClientRole.clientRole_Audience, withKey: nil)
        agoraKit.joinChannel(byKey: nil, channelName: deviceId, info: nil, uid: 0, joinSuccess: nil)
    }
}

extension GameRoomViewController : AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraRtcUserOfflineReason) {
        
    }
}


