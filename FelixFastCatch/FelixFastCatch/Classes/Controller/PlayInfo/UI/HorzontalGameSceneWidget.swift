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
        let backgroundImage = UIImageView(image: UIImage(named: "横版背景"))
        backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
        view.addSubview(backgroundImage)
        
//        setupBackBtn()
        
        setupBottomLogo()
        
        /// 初始化直播模块
        initLiveModel()
    }
    
    /// 装载背景底部的logo图
    func setupBottomLogo() -> () {
        let manLogo = UIImageView(image: UIImage(named: "男秒抓"))
        manLogo.frame = CGRect(x: UIScreen.main.bounds.height/4 - (UIScreen.main.bounds.height/6)/2 + UIScreen.main.bounds.height/2 + (UIScreen.main.bounds.height/6)/2, y: UIScreen.main.bounds.width - UIScreen.main.bounds.width/7, width: UIScreen.main.bounds.height/6, height: UIScreen.main.bounds.width/7)
        view.addSubview(manLogo)
        
        let ladyLogo = UIImageView(image: UIImage(named: "女秒抓"))
        ladyLogo.frame = CGRect(x: UIScreen.main.bounds.height/6/2, y: UIScreen.main.bounds.width - UIScreen.main.bounds.width/7, width: UIScreen.main.bounds.height/6, height: UIScreen.main.bounds.width/7)
        view.addSubview(ladyLogo)
        
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
        agoraKit.setClientRole(AgoraRtcClientRole.clientRole_Audience, withKey: nil)
        
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






