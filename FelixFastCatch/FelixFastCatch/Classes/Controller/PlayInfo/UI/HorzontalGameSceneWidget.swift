//
//  HorzontalGameSceneWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/11/30.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class HorzontalGameSceneWidget: NSObject {

}

extension HorizontalGameSceneViewController{
    
    /// 装载UI
    func setupUI(){
        ///设置背景图
        var backgroundImage:UIImageView;
        if isDurexTheme {
           backgroundImage = UIImageView(image: UIImage(named: "杜蕾斯-横版背景"))
        }else{
           backgroundImage = UIImageView(image: UIImage(named: "横版背景"))
        }
        
        backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
        view.addSubview(backgroundImage)
        
        /// 初始化直播模块
        initLiveModel()
        
        setupBtns()
        
        createControllerBtn()
    }
    
    /// 装载摄像头
    func setupBtns() -> () {
        /// 切换摄像头
        lensBtn.setImage(UIImage(named: "icon_lens"), for: .normal)
        lensBtn.sizeToFit()
        view.addSubview(lensBtn)
        
        lensBtn.addTarget(self, action: #selector(switchCamare), for: .touchUpInside)
        
        lensBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(liveView).offset(-5)
            make.right.equalTo(liveView).offset(-5)
        }
        
        /// 音频按钮
        audioBtn = UIButton(type: .custom)
        audioBtn.setImage(UIImage(named: "icon_audio"), for: .normal)
        audioBtn.sizeToFit()
        view.addSubview(audioBtn)
        
        audioBtn.addTarget(self, action: #selector(switchAudio), for: .touchUpInside)
        
        audioBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(liveView).offset(-5)
            make.left.equalTo(liveView).offset(5)
        }
        
        if UserDefaults.standard.bool(forKey: Constants.User.USER_AUDIO_SETTING) == false {
            isCloseMusic = false
            audioBtn.setImage(UIImage(named: "icon_audio"), for: .normal)
        }else{
            isCloseMusic = true
            audioBtn.setImage(UIImage(named: "audio_close"), for: .normal)
        }
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
    
//    /// 设置返回按钮
//    func setupBackBtn() -> () {
//        let backBtn = UIButton(type: UIButtonType.custom)
//        backBtn.setBackgroundImage(UIImage(named: "icon_back"), for: .normal)
//        backBtn.sizeToFit()
//        backBtn.frame = CGRect(x: 10, y: 10, width: backBtn.bounds.width, height: backBtn.bounds.height)
//        view.addSubview(backBtn)
//        backBtn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
//    }
//
//    /// 关闭当前的viewcontroller
//    @objc func closeVC() -> () {
//        self.navigationController?.popViewController(animated: false)//关闭页面
//    }
    
}

/// 直播相关的
extension HorizontalGameSceneViewController{
    
    /// 初始化直播模块
    func initLiveModel(){
        let liveBackgroundView = UIImageView(image: UIImage(named: "横版视频底"))
        liveBackgroundView.frame = CGRect(x: UIScreen.main.bounds.height/2 - (UIScreen.main.bounds.height/2.5)/2, y: 5, width: UIScreen.main.bounds.height/2.5, height: UIScreen.main.bounds.width - 10)
        liveGroupView.addSubview(liveBackgroundView)
        
        view.addSubview(liveGroupView)
        
        liveGroupView.addSubview(liveView)
        
        liveView.frame = CGRect(x: 0, y: 0, width: liveBackgroundView.bounds.width * 0.95, height: liveBackgroundView.bounds.height * 0.96)
        liveView.center = liveBackgroundView.center
        
        liveView.layer.cornerRadius = 10
        liveView.layer.masksToBounds = true
        
        initAgoLiveKit()
    }
    
    /// 初始化声网的SDK
    func initAgoLiveKit(){
        initLive()
    }
    
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
        agoraKit.setClientRole(AgoraRtcClientRole.clientRole_Broadcaster, withKey: nil)
        
        let code = agoraKit.joinChannel(byKey: nil, channelName: deviceId, info: nil, uid: 0, joinSuccess: nil)
        
        if code != 0 {
            DispatchQueue.main.async(execute: {
                print("Join channel failed: \(code)")
            })
        }else {
            print("进入直播房间成功:\(code)")
            agoraKit.setupRemoteVideo(nil)
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
            agoraKit.setupRemoteVideo(nil)
            let canvas = AgoraRtcVideoCanvas()
            canvas.view = liveView
            canvas.uid = sideLiveCamare!
            canvas.renderMode = .render_Hidden
            
            agoraKit.setRemoteVideoStream(sideLiveCamare!, type: .videoStream_High)
            agoraKit.setupRemoteVideo(canvas)
            
            nowLiveCamare = sideLiveCamare
            
            nowCamareDirection = 2
        }else{
            agoraKit.setupRemoteVideo(nil)
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

extension HorizontalGameSceneViewController : AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit!, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit!, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didOfflineOfUid uid: UInt, reason: AgoraRtcUserOfflineReason) {
        
    }
}

/// 游戏界面的操作按钮
extension HorizontalGameSceneViewController{
    
    /// 创建控制的按钮
    func createControllerBtn() -> () {
        let controllerSize = UIScreen.main.bounds.height * 0.12
        
        /// 左
        controllerLeft = CustomerControllerButton(frame: CGRect.zero, controllerDown: {[weak self] (button) in
                self?.gameSceneVC.horizontalControllerPathDown(sender: 3, nowCamareDirection: (self?.nowCamareDirection)!)
            }, controllerUp: {[weak self] (button) in
                self?.gameSceneVC.horizontalControllerPathUp(sender: 3, nowCamareDirection: (self?.nowCamareDirection)!)
            }, controllerMove:{[weak self] (button) in
                self?.gameSceneVC.controllerMove(sender: button)
        })
        if isDurexTheme {
            controllerLeft.setImage(UIImage(named: "杜蕾斯-左"), for: .normal)
            controllerLeft.setImage(UIImage(named: "杜蕾斯-左点击"), for: .highlighted)
            controllerLeft.setImage(UIImage(named: "controller_left_disabled"), for: .disabled)
        }else{
            controllerLeft.setImage(UIImage(named: "controller_left"), for: .normal)
            controllerLeft.setImage(UIImage(named: "controller_left_h"), for: .highlighted)
            controllerLeft.setImage(UIImage(named: "controller_left_disabled"), for: .disabled)
        }
        controllerLeft.sizeToFit()
        view.addSubview(controllerLeft)
        
        
        controllerLeft.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.left.equalTo(view).offset(14)
            make.width.equalTo(controllerSize)
            make.height.equalTo(controllerSize)
        }
        
        /// 右
        controllerRight = CustomerControllerButton(frame: CGRect.zero, controllerDown: {[weak self] (button) in
                  self?.gameSceneVC.horizontalControllerPathDown(sender: 4, nowCamareDirection: (self?.nowCamareDirection)!)
                  self?.gameSceneVC.controllerPathDown(sender: button)
            }, controllerUp: {[weak self] (button) in
                self?.gameSceneVC.horizontalControllerPathUp(sender: 4, nowCamareDirection: (self?.nowCamareDirection)!)
            }, controllerMove:{[weak self] (button) in
                self?.gameSceneVC.controllerMove(sender: button)
        })
        if isDurexTheme {
            controllerRight.setImage(UIImage(named: "杜蕾斯-右"), for: .normal)
            controllerRight.setImage(UIImage(named: "杜蕾斯-右点击"), for: .highlighted)
            controllerRight.setImage(UIImage(named: "controller_right_disabled"), for: .disabled)
        }else{
            controllerRight.setImage(UIImage(named: "controller_right"), for: .normal)
            controllerRight.setImage(UIImage(named: "controller_right_h"), for: .highlighted)
            controllerRight.setImage(UIImage(named: "controller_right_disabled"), for: .disabled)
        }
        controllerRight.sizeToFit()
        view.addSubview(controllerRight)
        
        controllerRight.snp.makeConstraints { (make) in
            make.width.equalTo(controllerSize)
            make.height.equalTo(controllerSize)
            make.right.equalTo(liveView).offset(-(14 + liveView.bounds.width))
            make.centerY.equalTo(view)
        }
        
        /// 下爪
        if isDurexTheme {
            grabBtn.setImage(UIImage(named: "杜蕾斯-抓按钮"), for: .normal)
            grabBtn.setImage(UIImage(named: "杜蕾斯-抓按钮点击"), for: .highlighted)
            grabBtn.setImage(UIImage(named: "controller_grab_disabled"), for: .disabled)
        }else {
            grabBtn.setImage(UIImage(named: "controller_grab"), for: .normal)
            grabBtn.setImage(UIImage(named: "controller_grab_h"), for: .highlighted)
            grabBtn.setImage(UIImage(named: "controller_grab_disabled"), for: .disabled)
        }
        grabBtn.sizeToFit()
        view.addSubview(grabBtn)
        
        grabBtn.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width * 0.21)
            make.height.equalTo(UIScreen.main.bounds.width * 0.21)
            make.centerY.equalTo(view)
            make.left.equalTo(liveView).offset(UIScreen.main.bounds.height/2.05)
        }
        
        grabBtn.addTarget(self, action: #selector(controllerGrap), for: .touchUpInside)
        
        /// 倒计时
        playTime.outLineWidth = 1
        playTime.outTextColor = UIColor.white
        playTime.outLienTextColor = UIColor.gray
        playTime.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(18))
        playTime.text = "0:30"
        playTime.sizeToFit()
        playTime.textAlignment = .center
        view.addSubview(playTime)
        
        playTime.snp.makeConstraints { (make) in
            make.centerX.equalTo(grabBtn)
            make.top.equalTo(grabBtn).offset(UIScreen.main.bounds.width * 0.21 + 2.5)
            make.width.equalTo(100)
        }
        
        /// 上
        controllerUp = CustomerControllerButton(frame: CGRect.zero, controllerDown: { [weak self] (button)  in
                    self?.gameSceneVC.horizontalControllerPathDown(sender: 1, nowCamareDirection: (self?.nowCamareDirection)!)
            }, controllerUp: { [weak self] (button) in
                    self?.gameSceneVC.horizontalControllerPathUp(sender: 1, nowCamareDirection: (self?.nowCamareDirection)!)
                }, controllerMove:{[weak self] (button) in
                    self?.gameSceneVC.controllerMove(sender: button)
        })
        if isDurexTheme {
            controllerUp.setImage(UIImage(named: "杜蕾斯-上"), for: .normal)
            controllerUp.setImage(UIImage(named: "杜蕾斯-上点击"), for: .highlighted)
            controllerUp.setImage(UIImage(named: "controller_up_disabled"), for: .disabled)
        }else {
            controllerUp.setImage(UIImage(named: "controller_up"), for: .normal)
            controllerUp.setImage(UIImage(named: "controller_up_h"), for: .highlighted)
            controllerUp.setImage(UIImage(named: "controller_up_disabled"), for: .disabled)
        }
        controllerUp.sizeToFit()
        view.addSubview(controllerUp)
        
        controllerUp.snp.makeConstraints { (make) in
            make.centerX.equalTo(grabBtn)
            make.bottom.equalTo(grabBtn).offset(-(grabBtn.bounds.height + 20))
        }
        
        /// 下
        controllerDown = CustomerControllerButton(frame: CGRect.zero, controllerDown: {[weak self] (button) in
            self?.gameSceneVC.horizontalControllerPathDown(sender: 2, nowCamareDirection: (self?.nowCamareDirection)!)
            }, controllerUp: {[weak self] (button) in
                self?.gameSceneVC.horizontalControllerPathUp(sender: 2, nowCamareDirection: (self?.nowCamareDirection)!)
            }, controllerMove:{[weak self] (button) in
//                self?.controllerMove(sender: button)
                self?.gameSceneVC.controllerMove(sender: button)
        })
        if isDurexTheme {
            controllerDown.setImage(UIImage(named: "杜蕾斯-下"), for: .normal)
            controllerDown.setImage(UIImage(named: "杜蕾斯-下点击"), for: .highlighted)
            controllerDown.setImage(UIImage(named: "controller_down_disabled"), for: .disabled)
        }else{
            controllerDown.setImage(UIImage(named: "controller_down"), for: .normal)
            controllerDown.setImage(UIImage(named: "controller_down_h"), for: .highlighted)
            controllerDown.setImage(UIImage(named: "controller_down_disabled"), for: .disabled)
        }
        controllerDown.sizeToFit()
        view.addSubview(controllerDown)
        
        controllerDown.snp.makeConstraints { (make) in
            make.centerX.equalTo(grabBtn)
            make.top.equalTo(grabBtn).offset(grabBtn.bounds.height + 20)
        }
    }
    
    /// 下爪
    @objc func controllerGrap() -> () {
        disableControllerBtns(isEnbled: false)
        self.gameSceneVC.controllerGrap()//执行下爪
        
        self.countdownTimer?.invalidate()
        self.countdownTimer = nil
        
        isCounting = false
    }
    
    func disableControllerBtns(isEnbled:Bool) -> () {
        controllerUp.isEnabled = isEnbled
        controllerLeft.isEnabled = isEnbled
        controllerRight.isEnabled = isEnbled
        controllerDown.isEnabled = isEnbled
        grabBtn.isEnabled = isEnbled
    }
    
    @objc func startGame(){
        disableControllerBtns(isEnbled: true) /// 设置按钮可以点击了
        
        countdownTimer?.invalidate()
        countdownTimer = nil
        isCounting = true
    }
    
}






