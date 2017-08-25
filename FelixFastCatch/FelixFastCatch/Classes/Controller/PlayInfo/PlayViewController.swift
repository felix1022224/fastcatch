//
//  PlayViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/26.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AudioToolbox
import AVFoundation

class PlayViewController: UIViewController {

    /// 设备id
    var deviceId:String = ""
    
    /// 背景view
    fileprivate lazy var backgroundView:UIView = UIView()
    
    /// 钻石背景
    fileprivate lazy var gemBackground:UIImageView = UIImageView()
    
    /// 钻石数量
    fileprivate lazy var gemLabel:MainCustomerLabel = MainCustomerLabel()
    
    /// 视屏view
    fileprivate lazy var videoView:UIView = UIView()
    
    /// 游戏开始的按钮
    fileprivate lazy var startPlayBtn:UIButton = UIButton()

    /// 观看人数
    fileprivate var playNumber:MainCustomerLabel!
    
    /// 排队人数
    fileprivate var queueNumber:MainCustomerLabel!
    
    /// 操作group
    fileprivate var startBtnBackgroundView = UIView()
    
    /// 游戏group
    fileprivate var playGroupView:UIView = UIView()
    
    /// 下爪按钮
    fileprivate lazy var grabBtn = UIButton()
    
    /// controller up
    fileprivate var controllerUp:CustomerControllerButton!
    
    /// play time
    fileprivate lazy var playTime:MainCustomerLabel = MainCustomerLabel()
    
    /// controller down
    fileprivate var controllerDown:CustomerControllerButton!
    
    /// controller left
    fileprivate var controllerLeft:CustomerControllerButton!
    
    /// controller right
    fileprivate var controllerRight:CustomerControllerButton!
    
    /// 是否已经下爪
    fileprivate lazy var isGrab:Bool = false
    
    /// 是否正在操作
    fileprivate lazy var isControoler:Bool = false
    
    /// 是否调用了开始游戏
    fileprivate lazy var isStartClick:Bool = false
    
    /// 本地local
    var localVideo:AgoraRtcVideoCanvas!
    
    /// 中奖信息的code
    var wardCode = ""
    
    /// 获取中奖信息的次数
    fileprivate var getWardCodeNumber = 0
    
    /// 直播kit
    var agoraKit: AgoraRtcEngineKit!
    
    /// 视频id数组
    var liveVideoIds = [UInt]()
    
    /// 默认的id数组
    var defaultVideoIds = [UInt]()
    
    /// 是否是直播间
    var isLive = true
    
    /// 当前默认模式下的镜头id
    var nowDefaultVideoId:UInt!
    
    /// 当前直播模式下的镜头id
    var nowLiveVideoId:UInt!
    
    /// 摄像头按钮
    fileprivate lazy var lensBtn:UIButton = UIButton(type: UIButtonType.custom)
    
    /// 游戏结果
    fileprivate var playResultDialog:PlayResultDialog!
    
    /// 播放声音
    var bgMusicPlayer = AVAudioPlayer()
    
    /// 再玩一次
    var rePlayGameBtn:UIButton!
    
    /// 再玩一次的倒计时
    var rePlayGameTimeLabel:MainCustomerLabel!
    
    /// 关掉声音
    var isCloseMusic:Bool = false
    
    /// 退出游戏的询问框
    var outGameDialog:OutGameDialog!
    
    /// 是否正在游戏中
    var isGameing = false
    
    var playSuccess:(()->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        outGameDialog = OutGameDialog(frame: UIScreen.main.bounds)
        
        playResultDialog = PlayResultDialog(frame: UIScreen.main.bounds)
        
        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = UIColor.white
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;   //禁用侧滑手势
        
        enter()
        
        setupUI()
        
        /// 播放背景音乐
        playBackgroundMusic()

    }

    deinit {
        out(deviceId: deviceId)
        agoraKit.leaveChannel { (starts) in
            // 离开
            print("离开")
        }
    }
    
    /// 游戏倒计时
    fileprivate var countdownTimer: Timer?
    
    fileprivate var remainingSeconds: Int = 0 {
        willSet {
            if newValue < 10 {
                playTime.text = "0:0\(newValue)"
            }else {
                playTime.text = "0:\(newValue)"
            }
            
            if newValue <= 0 {
                playTime.text = "0:30"
                isCounting = false
                if !isGrab{
                    //到时间了，还没抓呢
                    controllerGrap()
                }
//                hidePlayGroup()
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                isControoler = false
                remainingSeconds = 30
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
        }
    }
    
    /// 再来一次的倒计时
    fileprivate var replayCountdownTimer: Timer?
    
    fileprivate var replaySeconds: Int = 0 {
        willSet {
            if newValue < 10 {
                rePlayGameTimeLabel.text = "0:0\(newValue)"
            }else {
                rePlayGameTimeLabel.text = "0:\(newValue)"
            }
            
            if newValue <= 0 {
                rePlayGameTimeLabel.text = "0:15"
                isCounting = false
                /// 到时间了，隐藏界面
                hideReplayView()
            }
        }
    }
    
    var isReplayCounting = false {
        willSet {
            if newValue {
                replayCountdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateReplayTime), userInfo: nil, repeats: true)
                replaySeconds = 15
            } else {
                replayCountdownTimer?.invalidate()
                replayCountdownTimer = nil
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("页面销毁")
        bgMusicPlayer.stop()
    }
    
}


// MARK: - 装载与游戏相关的控件
extension PlayViewController{
    
    /// 加载UI
    func setupUI() -> () {
        createBackground()
        
        createVideo()
        
        createBtns()
        
        createPlayControllerView()
        
        /// 重新游戏倒计时的view
        createReStartTimeLabel()
    }
    
    /// 创建背景板
    func createBackground() -> () {
        backgroundView.backgroundColor = UIColor.lightGray
        backgroundView.frame = self.view.bounds
        view.addSubview(backgroundView)
        
        let backgroundImageView = UIImageView(image: UIImage(named: "main_background"))
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        view.addSubview(backgroundImageView)
        
    }
    
    /// 创建按钮的集合
    func createBtns() -> () {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "icon_back"), for: .normal)
        backBtn.sizeToFit()
        view.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(UIApplication.shared.statusBarFrame.height + 5)
            make.left.equalTo(self.view).offset(10)
        }
        
        createGemBackground()
        
        createVideoBtns()
        
        createStartBtn()
        
        createNumber()
    }
    
    /// 创建钻石
    func createGemBackground() -> () {
        gemBackground.image = UIImage(named: "bg_gem_number")
        gemBackground.sizeToFit()
        view.addSubview(gemBackground)
        
        gemBackground.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(UIApplication.shared.statusBarFrame.height + 2)
            make.right.equalTo(self.view).offset(-10)
        }
        
        gemLabel.text = ""
        gemLabel.outLineWidth = 1
        gemLabel.outTextColor = UIColor.white
        gemLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        gemLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(11))
        view.addSubview(gemLabel)
        
        gemLabel.snp.makeConstraints { (make) in
            make.right.equalTo(gemBackground).offset(-28)
            make.centerY.equalTo(gemBackground).offset(2)
        }
    }
    
    /// 创建游戏相关按钮
    func createVideoBtns() -> () {
        /// 教程按钮
        let helpBtn = UIButton(type: .custom)
        helpBtn.setImage(UIImage(named: "icon_qa"), for: .normal)
        helpBtn.sizeToFit()
        view.addSubview(helpBtn)
        
        helpBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(videoView).offset(-10)
            make.left.equalTo(self.view).offset(10)
        }
        
        /// 音频按钮
        let audioBtn = UIButton(type: .custom)
        audioBtn.setImage(UIImage(named: "icon_audio"), for: .normal)
        audioBtn.sizeToFit()
        view.addSubview(audioBtn)
        
        audioBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(helpBtn).offset(-(helpBtn.bounds.height + 10))
            make.left.equalTo(helpBtn)
        }
        
        lensBtn.setImage(UIImage(named: "icon_lens"), for: .normal)
        lensBtn.sizeToFit()
        view.addSubview(lensBtn)
        
        lensBtn.addTarget(self, action: #selector(changeLens(sender:)), for: .touchUpInside)
        
        lensBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(helpBtn)
            make.right.equalTo(self.view).offset(-10)
        }
    }
    
    /// 创建开始游戏的按钮
    func createStartBtn() -> () {
        let startBtnImage = UIImage(named: "icon_start")
        startBtnBackgroundView.backgroundColor = UIColor(red: 91/255.0, green: 177/255.0, blue: 228/255.0, alpha: 1.0)
        startBtnBackgroundView.frame = CGRect(x: 0, y: videoView.bounds.height, width: self.view.bounds.width, height: startBtnImage!.size.height * 1.5 + 25)
        view.addSubview(startBtnBackgroundView)
        
        startPlayBtn.setImage(startBtnImage, for: .normal)
        startPlayBtn.setImage(UIImage(named: "正在游戏中"), for: .disabled)
        startPlayBtn.sizeToFit()
        startBtnBackgroundView.addSubview(startPlayBtn)
        
        startPlayBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(startBtnBackgroundView)
            make.right.equalTo(self.view).offset(-10)
        }
        
        startPlayBtn.addTarget(self, action: #selector(waitQueue), for: .touchUpInside)
    }
    
    /// 关闭当前页面
    func backBtnClick() -> () {
        if isGameing {
            /// 游戏中点击返回键
            outGameDialog.createView()
            outGameDialog.show2 {[weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - 创建直播视屏的view
extension PlayViewController{
    
    /// 创建video 的view
    func createVideo() -> () {
        videoView.backgroundColor = UIColor.lightGray
        videoView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 0.5)
        view.addSubview(videoView)
        
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "a61c87d429a748cfbdae28178e082289", delegate: self)
        
        /// 默认是直播模式
        agoraKit.setChannelProfile(AgoraRtcChannelProfile.channelProfile_LiveBroadcasting)
        agoraKit.enableDualStreamMode(true)
        
        agoraKit.disableAudio()
        
        agoraKit.enableLocalVideo(false)
        agoraKit.enableVideo()
        
        agoraKit.setVideoProfile(._VideoProfile_360P, swapWidthAndHeight: false)
        agoraKit.setClientRole(AgoraRtcClientRole.clientRole_Audience, withKey: nil)
        
        agoraKit.muteAllRemoteAudioStreams(true)
        
//        let hostingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        hostingView.translatesAutoresizingMaskIntoConstraints = false
        
        let code = agoraKit.joinChannel(byKey: nil, channelName: "test4", info: nil, uid: 878, joinSuccess: nil)
        
        if code != 0 {
            DispatchQueue.main.async(execute: {
                print("Join channel failed: \(code)")
            })
        }else {
            isLive = true
            print("进入直播房间成功:\(code)")
        }
        
        // 在没有游戏时，隐藏摄像头的按钮
//        lensBtn.isHidden = true
    }
    
    /// 切换视频的房间到一对一聊天界面
    func switchVideoChannelToDefault() -> () {
        
        /// 首次切换，清空ID
        defaultVideoIds.removeAll()
        
        agoraKit.leaveChannel { (starts) in
            print("在进入前，先离开上一个房间")
        }
        
        agoraKit.setChannelProfile(AgoraRtcChannelProfile.channelProfile_Communication)
        
        let code = agoraKit.joinChannel(byKey: nil, channelName: "test3", info: nil, uid: 0, joinSuccess: nil)
        
        if code != 0 {
            DispatchQueue.main.async(execute: {
                print("Join channel failed: \(code)")
            })
        }else {
            print("进入房间成功:\(code)")
            isLive = false
            
            playStartGame()
        }
    }
    
    // 切换镜头
    func changeLens(sender:UIButton) -> () {
        if !isLive {
            lensBtn.isEnabled = false
            //不是直播模式，就是在游戏中
            for item in defaultVideoIds {
                if item != nowDefaultVideoId {
                    switchLens(uid: item)
                    break
                }
            }
        }else{
            lensBtn.isEnabled = false
            if liveVideoIds.count <= 1 {
                /// 镜头小于2，不切换
                return
            }
            //直播模式
            for item in liveVideoIds {
                if item != nowDefaultVideoId {
                    switchLens(uid: item)
                    break
                }
            }
        }
        playSwitchMusic()
    }
    
    func switchLens(uid:UInt) -> () {
        /// 暂停上一个镜头
        agoraKit.setupRemoteVideo(nil)
        
        let canvas = AgoraRtcVideoCanvas()
        canvas.view = videoView
        canvas.uid = uid
        canvas.renderMode = .render_Hidden
        /// 切换到当前id
        nowDefaultVideoId = uid
        agoraKit.setupRemoteVideo(canvas)
        
        lensBtn.isEnabled = true
    }
    
    /// 切换视频到直播界面
    func swichVideoChannerlToLive() -> () {
        /// 首次切换，清空ID
        liveVideoIds.removeAll()
        
        agoraKit.leaveChannel { (starts) in
            print("在进入前，先离开上一个房间")
        }
        
        agoraKit.setChannelProfile(AgoraRtcChannelProfile.channelProfile_LiveBroadcasting)
        
        let code = agoraKit.joinChannel(byKey: nil, channelName: "test4", info: nil, uid: 878, joinSuccess: nil)
        
        if code != 0 {
            DispatchQueue.main.async(execute: {
                print("Join channel failed: \(code)")
            })
        }else {
            print("进入房间成功:\(code)")
            isLive = true
        }
    }
    
    
}

extension PlayViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit!, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        // 初始化成功
        print("成功\(uid)")
        if isLive {
            liveVideoIds.append(uid)
            /// 对当前镜头id进行赋值
            nowLiveVideoId = uid
        }else {
            /// 对当前的镜头id进行赋值
            nowDefaultVideoId = uid
            defaultVideoIds.append(uid)
        }
        agoraKit.setupRemoteVideo(nil)
        let canvas = AgoraRtcVideoCanvas()
        canvas.view = videoView
        canvas.uid = uid
        canvas.renderMode = .render_Hidden
        
        agoraKit.setRemoteVideoStream(UInt(uid), type: .videoStream_High)
        agoraKit.setupRemoteVideo(canvas)

    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit!, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didOfflineOfUid uid: UInt, reason: AgoraRtcUserOfflineReason) {
    
    }
    
    
    
}


// MARK: - 观看人数和排队人数
extension PlayViewController{

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

// MARK: - 进入和退出房间
extension PlayViewController{
    
    /// 进入房间
    fileprivate func enter(){
        var params = NetWorkUtils.createBaseParams()
        params["deviceid"] = deviceId
        
        Alamofire.request(Constants.Network.Machine.ENTER_WATCH, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(data: response.data!)
                self.setupInfo(resultData:json)
            }
        }
    }
    
    /// 装载数据
    fileprivate func setupInfo(resultData:JSON) -> () {
        if let watchNumber = resultData["data"]["waitWatchCount"].int {
            playNumber.text = String(watchNumber) + "人观看"
        }
        
        if let queue = resultData["data"]["waitCtlCount"].int {
            queueNumber.text = String(queue) + "人等待"
        }
        print("result:\(resultData)")
        gemLabel.text = String(Constants.User.diamondsCount)
    }
    
    /// 退出房间
    fileprivate func out(deviceId:String){
        endQueue(deviceId: deviceId)
        
        var params = NetWorkUtils.createBaseParams()
        params["deviceid"] = deviceId
        Alamofire.request(Constants.Network.Machine.OUT_WATCH, method: .post, parameters: params).responseJSON { (response) in
            if response.error == nil && response.data != nil {
                print("result_退出房间:\(response.result.value ?? "")")
            }
        }
    }
    
    /// 取消预约
    fileprivate func endQueue(deviceId:String){
        var params = NetWorkUtils.createBaseParams()
        params["deviceid"] = deviceId
        Alamofire.request(Constants.Network.Machine.END_PALY, method: .post, parameters: params).responseJSON { (response) in
            if response.error == nil && response.data != nil {
                print("result_取消预约:\(response.result.value ?? "")")
            }
        }
    }
    
}

// MARK: - 游戏操作界面
extension PlayViewController{
    
    /// 创建操作界面
    func createPlayControllerView() -> () {
        let topHeight = videoView.bounds.height + startBtnBackgroundView.bounds.height
        
        playGroupView.frame = CGRect(x: 0, y: topHeight, width: self.view.bounds.width, height: self.view.bounds.height - topHeight)
        playGroupView.backgroundColor = UIColor.clear
        view.addSubview(playGroupView)
        
        /// 背景图片
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "play_game_background")
        backgroundImage.frame.size = CGSize(width: self.view.bounds.width, height: self.view.bounds.height - topHeight)
        playGroupView.addSubview(backgroundImage)
        
        let controllerSize = 50
        
        
        /// 上
        controllerUp = CustomerControllerButton(frame: CGRect.zero, controllerDown: { [weak self] (button)  in
            self?.controllerPathDown(sender: button)
        }, controllerUp: { [weak self] (button) in
            self?.controllerPathUp(sender: button)
        }, controllerMove:{[weak self] (button) in
            self?.controllerMove(sender: button)
        })
        controllerUp.setImage(UIImage(named: "controller_up"), for: .normal)
        controllerUp.setImage(UIImage(named: "controller_up_disabled"), for: .disabled)
        controllerUp.sizeToFit()
        playGroupView.addSubview(controllerUp)
        
//        controllerUp.addTarget(self, action: #selector(controllerPathDown(sender:)), for: .)
//        controllerUp.addTarget(self, action: #selector(controllerPathUp(sender:)), for: .touchUpOutside)
        
        controllerUp.snp.makeConstraints { (make) in
            make.width.equalTo(controllerSize)
            make.height.equalTo(controllerSize)
            make.left.equalTo(self.view).offset(20 + controllerSize)
            make.top.equalTo(playGroupView).offset(30)
        }
        
        /// 左
        controllerLeft = CustomerControllerButton(frame: CGRect.zero, controllerDown: {[weak self] (button) in
            self?.controllerPathDown(sender: button)
        }, controllerUp: {[weak self] (button) in
            self?.controllerPathUp(sender: button)
        }, controllerMove:{[weak self] (button) in
            self?.controllerMove(sender: button)
        })
        controllerLeft.setImage(UIImage(named: "controller_left"), for: .normal)
        controllerLeft.setImage(UIImage(named: "controller_left_disabled"), for: .disabled)
        controllerLeft.sizeToFit()
        playGroupView.addSubview(controllerLeft)
        
        controllerLeft.snp.makeConstraints { (make) in
            make.width.equalTo(controllerSize)
            make.height.equalTo(controllerSize)
            make.right.equalTo(controllerUp).offset(-(controllerSize))
            make.top.equalTo(controllerUp).offset(controllerSize + 5)
        }
        
//        controllerLeft.addTarget(self, action: #selector(controllerPathDown(sender:)), for: .touchUpInside)
//        controllerLeft.addTarget(self, action: #selector(controllerPathUp(sender:)), for: .touchUpOutside)
        
        /// 右
        controllerRight = CustomerControllerButton(frame: CGRect.zero, controllerDown: {[weak self] (button) in
            self?.controllerPathDown(sender: button)
        }, controllerUp: {[weak self] (button) in
            self?.controllerPathUp(sender: button)
        }, controllerMove:{[weak self] (button) in
            self?.controllerMove(sender: button)
        })
        controllerRight.setImage(UIImage(named: "controller_right"), for: .normal)
        controllerRight.setImage(UIImage(named: "controller_right_disabled"), for: .disabled)
        controllerRight.sizeToFit()
        playGroupView.addSubview(controllerRight)
        
        controllerRight.snp.makeConstraints { (make) in
            make.width.equalTo(controllerSize)
            make.height.equalTo(controllerSize)
            make.left.equalTo(controllerUp).offset(controllerSize)
            make.centerY.equalTo(controllerLeft)
        }
        
        controllerRight.addTarget(self, action: #selector(controllerPathDown(sender:)), for: .touchUpInside)
        controllerRight.addTarget(self, action: #selector(controllerPathUp(sender:)), for: .touchUpOutside)
        
        /// 下
        controllerDown = CustomerControllerButton(frame: CGRect.zero, controllerDown: {[weak self] (button) in
            self?.controllerPathDown(sender: button)
        }, controllerUp: {[weak self] (button) in
            self?.controllerPathUp(sender: button)
        }, controllerMove:{[weak self] (button) in
            self?.controllerMove(sender: button)
        })
        controllerDown.setImage(UIImage(named: "controller_down"), for: .normal)
        controllerDown.setImage(UIImage(named: "controller_down_disabled"), for: .disabled)
        controllerDown.sizeToFit()
        playGroupView.addSubview(controllerDown)
        
        controllerDown.snp.makeConstraints { (make) in
            make.width.equalTo(controllerSize)
            make.height.equalTo(controllerSize)
            make.centerX.equalTo(controllerUp)
            make.top.equalTo(controllerLeft).offset(controllerSize + 5)
        }
        
        controllerDown.addTarget(self, action: #selector(controllerPathDown(sender:)), for: .touchUpInside)
        controllerDown.addTarget(self, action: #selector(controllerPathUp(sender:)), for: .touchUpOutside)
        
        /// 下爪
        grabBtn.setImage(UIImage(named: "controller_grab"), for: .normal)
        grabBtn.setImage(UIImage(named: "controller_grab_disabled"), for: .disabled)
        grabBtn.sizeToFit()
        playGroupView.addSubview(grabBtn)
        
        grabBtn.snp.makeConstraints { (make) in
            make.width.equalTo(86)
            make.height.equalTo(86)
            make.centerY.equalTo(controllerRight)
            make.right.equalTo(self.view).offset(-20)
        }
        
        grabBtn.addTarget(self, action: #selector(controllerGrap), for: .touchUpInside)
        
        
        /// 倒计时
        playTime.outLineWidth = 1
        playTime.outTextColor = UIColor.white
        playTime.outLienTextColor = UIColor.gray
        playTime.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(20))
        playTime.text = "0:30"
        playTime.sizeToFit()
        playTime.textAlignment = .center
        playGroupView.addSubview(playTime)
        
        playTime.snp.makeConstraints { (make) in
            make.centerX.equalTo(grabBtn)
            make.top.equalTo(grabBtn).offset(86 + 5)
            make.width.equalTo(100)
        }
        
        playGroupView.isHidden = true
    }
    
    /// 展示游戏界面
    func showPlayGroup() -> () {
        playGroupView.isHidden = false
        isGrab = false
        isCounting = true
        /// 切换到另一个房间
        switchVideoChannelToDefault()
        
        isGameing = true
        
        startPlayBtn.isEnabled = false
        disableControllerBtns(isEnbled: true)
        
        resetReplayInfo()
        
        //振动
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func hidePlayGroup() -> () {
//        startPlayBtn.isEnabled = true
        playGroupView.isHidden = true
        countdownTimer?.invalidate()
        countdownTimer = nil
        disableControllerBtns(isEnbled: false)
        /// 开始进行再来一局的倒计时
        
        isGameing = false
    }
    
    @objc func updateTime() {
        remainingSeconds -= 1
    }
    
    @objc func updateReplayTime(){
        replaySeconds -= 1
    }
    
    /// 开始游戏
    func startPlay() -> () {
        if isStartClick {
            return
        }
        isStartClick = true
        print("开始游戏")
        var params = NetWorkUtils.createBaseParams()
        params["deviceid"] = deviceId
        
        Alamofire.request(Constants.Network.Machine.START_PLAY, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                print("开始游戏回调:\(String(describing: response.result.value))")
                self.showPlayGroup()
                let json = JSON(response.result.value!)
                self.gemLabel.text = String(json["data"]["diamondsCount"].int!)
                Constants.User.diamondsCount = json["data"]["diamondsCount"].intValue
                self.wardCode = json["data"]["gTradeNo"].string!
            }else {
                print("error:\(String(describing: response.error))")
            }
            self.isStartClick = false
        }
    }
    
    /// 开始预约
    func waitQueue(){
        ToastUtils.showLoadingToast(msg: "请稍后……")
        
        var params = NetWorkUtils.createBaseParams()
        params["deviceid"] = deviceId
        
        Alamofire.request(Constants.Network.Machine.WAIT_QUEUE, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print("result:\(String(describing: response.result.value)),error:\(String(describing: response.error))")
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(data: response.data!)
                if json["data"]["tryLock"].bool! == true {
                    // 可以开始游戏了
                    self.startPlay()
                }else{
                    print("已经有\(String(describing: json["data"]["waitCtlCount"].int!))人在游戏中，请等候")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                        self.waitQueue()
                    })
                }
            }else{
                /// 当数据data为空的时候，报告异常
            }
            ToastUtils.hide()
        }
    }
    
    ///  按下操作方向
    func controllerPathDown(sender:CustomerControllerButton ) -> () {
        if isGrab {
            // 如果是下爪的过程中，不能操作
            return
        }
        if sender == controllerUp {
            // 上
//            print("按下，上")
            controllerNetworkPath(path:"3", status: "1")
        }else if sender == controllerDown {
            // 下
//            print("按下，下")
            controllerNetworkPath(path:"2", status: "1")
        }else if sender == controllerLeft {
            // 左
//            print("按下，左")
            controllerNetworkPath(path:"0", status: "1")
        }else if sender == controllerRight {
            // 右
            controllerNetworkPath(path:"1", status: "1")
        }
    }
    
    func controllerPathUp(sender:CustomerControllerButton ) -> () {
        isControoler = false
        if isGrab {
            // 如果是下爪的过程中，不能操作
            return
        }
        if sender == controllerUp {
            // 上
            controllerNetworkPath(path:"3", status: "0")
        }else if sender == controllerDown {
            // 下
            controllerNetworkPath(path:"2", status: "0")
        }else if sender == controllerLeft {
            // 左
            controllerNetworkPath(path:"0", status: "0")
        }else if sender == controllerRight {
            // 右
            controllerNetworkPath(path:"1", status: "0")
        }
    }
    
    func controllerMove(sender:CustomerControllerButton) -> () {

    }
    
    /// 通过网络操作机器臂的方向
    func controllerNetworkPath(path:String, status:String) -> () {
        print("status:\(status)")
        var params = NetWorkUtils.createBaseParams()
        params["deviceid"] = deviceId
        params["direction"] = path
        params["status"] = status
        
        Alamofire.request(Constants.Network.Machine.DIECTION_CONTROLLER, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                print("result:\(String(describing: response.result.value))")
            }else {
                print("error:\(String(describing: response.error)),response:\(String(describing: response.response))")
            }
        }
    }
    
    /// 下爪
    func controllerGrap() -> () {
        isGrab = true
        var params = NetWorkUtils.createBaseParams()
        params["deviceid"] = deviceId
        
        Alamofire.request(Constants.Network.Machine.CONTROLLER_CATCH, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                print("下爪成功")
                self.hidePlayGroup()
                self.getWard()
            }else{
                print("response:\(response)")
                self.hidePlayGroup()
            }
        }
    }
    
    func disableControllerBtns(isEnbled:Bool) -> () {
        controllerUp.isEnabled = isEnbled
        controllerLeft.isEnabled = isEnbled
        controllerRight.isEnabled = isEnbled
        controllerDown.isEnabled = isEnbled
        grabBtn.isEnabled = isEnbled
    }
    
    /// 获取中奖信息
    func getWard() -> () {
        if wardCode == "" {
            return
        }
        
        /// 调用接口超过5次，默认失败
        if getWardCodeNumber >= 5 {
            getWardCodeNumber = 0
            wardCode = ""
            playResultDialog.isSuccess = false
            playResultDialog.createView()
            playResultDialog.show()
            self.playGrapFail()
            hidePlayGroup()
            /// 展示再来一局的界面
            showRePlayInfo()
            return
        }
        
        var params = NetWorkUtils.createBaseParams()
        params["gtradeno"] = wardCode
        
        Alamofire.request(Constants.Network.Machine.GET_WARD, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(response.result.value!)
                if json["data"]["drawable"].bool! == true {
                    self.getWardCodeNumber = 0
                    print("抓取成功")
                    self.wardCode = ""
                    self.playResultDialog.isSuccess = true
                    self.playResultDialog.createView()
                    self.playResultDialog.show()
                    self.playGrapSuccess()
                    self.hidePlayGroup()
                    /// 展示再来一局的界面
                    self.showRePlayInfo()
                    if self.playSuccess != nil {
                        self.playSuccess!()
                    }
                }else {
                    print("抓取失败")
                    self.getWardCodeNumber = self.getWardCodeNumber + 1
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { 
                        self.getWard()
                    })
                }
            }else{
                print("抓取失败")
                self.getWardCodeNumber = self.getWardCodeNumber + 1
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    self.getWard()
                })
            }
        }
    }
}

// MARK: - 再玩一次的逻辑
extension PlayViewController{
    
    /// 创建倒计时的时间文字
    func createReStartTimeLabel() -> () {
        rePlayGameTimeLabel = MainCustomerLabel()
        rePlayGameTimeLabel.text = "0:15"
        rePlayGameTimeLabel.outTextColor = UIColor.white
        rePlayGameTimeLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        rePlayGameTimeLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        rePlayGameTimeLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(16))
        rePlayGameTimeLabel.sizeToFit()
        view.addSubview(rePlayGameTimeLabel)
        
        rePlayGameTimeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(startPlayBtn)
            make.top.equalTo(startPlayBtn).offset(startPlayBtn.bounds.height + 2)
        }
        
        rePlayGameTimeLabel.isHidden = true
        
        createReStartBtn()
    }
    
    /// 创建重新游戏的按钮
    func createReStartBtn() -> () {
        rePlayGameBtn = UIButton(type: .custom)
        rePlayGameBtn.setImage(UIImage(named: "replay_start_game"), for: .normal)
        rePlayGameBtn.sizeToFit()
        view.addSubview(rePlayGameBtn)
        
        rePlayGameBtn.snp.makeConstraints { (make) in
            make.center.equalTo(startPlayBtn)
        }
        
        rePlayGameBtn.addTarget(self, action: #selector(replayGame), for: .touchUpInside)
        
        rePlayGameBtn.isHidden = true
    }
    
    /// 再来一局
    func replayGame() -> () {
        startPlay()
    }
    
    /// 游戏结束，开始进行倒计时15秒
    func reStartCreateTime() -> () {
        isReplayCounting = true
    }
    
    /// 重置再来一局的相关设置
    func resetReplayInfo() -> () {
        /// 结束倒计时
        isReplayCounting = false
        /// 倒计时信息复原
        rePlayGameTimeLabel.text = "0:15"
        rePlayGameTimeLabel.isHidden = true
        /// 隐藏倒计时按钮
        rePlayGameBtn.isHidden = true
        
        replayCountdownTimer?.invalidate()
        replayCountdownTimer = nil
    }
    
    /// 展示再来一局的信息
    func showRePlayInfo() -> () {
        /// 展示界面
        rePlayGameBtn.isHidden = false
        rePlayGameTimeLabel.isHidden = false
        /// 开始倒计时
        reStartCreateTime()
    }
    
    // 隐藏再玩一次的界面
    func hideReplayView() -> () {
        resetReplayInfo()
        
        startPlayBtn.isEnabled = true
        
    }
    
}


// MARK: - 当前页面播放声音
extension PlayViewController{
    
    /// 播放背景声音
    func playBackgroundMusic() -> () {
        
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch _ {
        }
        //获取bg.mp3文件地址
        let bgMusicURL =  Bundle.main.path(forResource: "background_music", ofType: "mp3")!
        //地址转换
        let baseURL = URL(fileURLWithPath: bgMusicURL)
        //根据背景音乐地址生成播放器
        try? bgMusicPlayer = AVAudioPlayer(contentsOf: baseURL)
        bgMusicPlayer.volume = 10.0
        //设置为循环播放
        bgMusicPlayer.numberOfLoops = -1
        //准备播放音乐
        bgMusicPlayer.prepareToPlay()
        //播放音乐
        bgMusicPlayer.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseSong(notification:)), name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playSong(notification:)), name:NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        isCloseMusic = false
    }
    
    func pauseSong(notification : NSNotification) {
        bgMusicPlayer.pause()
    }
    
    func playSong(notification : NSNotification) {
        if !isCloseMusic {
            bgMusicPlayer.play()
        }
    }
    
    /// 播放开始游戏的音效
    func playStartGame() -> () {
        if isCloseMusic {
            return
        }
        //建立的SystemSoundID对象
        var soundID:SystemSoundID = 0
        //获取声音地址
        let path = Bundle.main.path(forResource: "游戏开始_音效", ofType: "wav")
        //地址转换
        let baseURL = NSURL(fileURLWithPath: path!)
        //赋值
        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        //提醒（同上面唯一的一个区别）
        AudioServicesPlayAlertSound(soundID)
    }
    
    /// 播放抓取成功的音效
    func playGrapSuccess() -> () {
        if isCloseMusic {
            return
        }
        //建立的SystemSoundID对象
        var soundID:SystemSoundID = 1
        //获取声音地址
        let path = Bundle.main.path(forResource: "抓取成功_音效", ofType: "wav")
        //地址转换
        let baseURL = NSURL(fileURLWithPath: path!)
        //赋值
        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        //提醒（同上面唯一的一个区别）
        AudioServicesPlayAlertSound(soundID)
    }
    
    /// 播放抓取失败的音效
    func playGrapFail() -> () {
        if isCloseMusic {
            return
        }
        //建立的SystemSoundID对象
        var soundID:SystemSoundID = 2
        //获取声音地址
        let path = Bundle.main.path(forResource: "抓取失败_音效", ofType: "wav")
        //地址转换
        let baseURL = NSURL(fileURLWithPath: path!)
        //赋值
        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        //提醒（同上面唯一的一个区别）
        AudioServicesPlayAlertSound(soundID)
    }
    
    /// 播放切换镜头的音效
    func playSwitchMusic() -> () {
        if isCloseMusic {
            return
        }
        //建立的SystemSoundID对象
        var soundID:SystemSoundID = 3
        //获取声音地址
        let path = Bundle.main.path(forResource: "镜头切换_音效", ofType: "wav")
        //地址转换
        let baseURL = NSURL(fileURLWithPath: path!)
        //赋值
        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        //提醒（同上面唯一的一个区别）
        AudioServicesPlayAlertSound(soundID)
    }
    
    /// 关掉声音
    func closeMusic() -> () {
        isCloseMusic = true
        bgMusicPlayer.pause()
    }
}








