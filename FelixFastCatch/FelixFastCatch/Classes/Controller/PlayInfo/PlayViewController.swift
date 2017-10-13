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
    lazy var gemBackground:UIImageView = UIImageView()
    
    /// 钻石数量
    lazy var gemLabel:MainCustomerLabel = MainCustomerLabel()
    
    /// 视屏view
    fileprivate lazy var videoView:UIView = UIView()
    
    /// 游戏开始的按钮
    fileprivate lazy var startPlayBtn:UIButton = UIButton()

    /// 观看人数
    var playNumber:MainCustomerLabel!
    
    /// 排队人数
    var queueNumber:MainCustomerLabel!
    
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
    
    /// 当前游戏中的视频id
    var nowVideoId:UInt = UInt(2)
    
    /// 当前直播模式下的镜头id
    var nowLiveVideoId:UInt!
    
    /// 摄像头按钮
    lazy var lensBtn:UIButton = UIButton(type: UIButtonType.custom)
    
    /// 游戏结果
    fileprivate var playResultDialog:PlayResultDialog!
    
    /// 播放声音
    var bgMusicPlayer = AVAudioPlayer()
    
    /// 播放音效
    var soundEffect = AVAudioPlayer()
    
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
    
//    var playSuccess:((_ deviceId:String)->())? = nil
    
    /// 需要登录
    var needLogin:(()->())? = nil
    
    /// 底部的view
    var bottomGroupView:UIView!
    
    /// 底部奖品的card
    var bottomAwardCard:UIView!
    
    /// 底部的banner的card
    var bottomBannerCard:UIView!
    
    var bottomAwardCardImagePath:String!
    var bottomAwardCardScheme:String!
    var bootomAwardDescription:String!
    var bottomAwardTitle:String!
    
    var bootomBannerCardImagePath:String!
    var bottomBannerCardScheme:String!
    
    /// banner详情
    var bottomBannerDialog:PlayInfoBannerDialog!
    
    /// 奖品详情
    var bottomAwardDialog:PlayInfoAwardDialog!
    
    /// 正在排队中的view
    var playQueueNumberStatus:UIView!
    var playQueueStausNumber:MainCustomerLabel!
    
    /// 被抓取的次数
    var darwCount = 0
    
    /// 被抓去次数的label
    var darwCountLabel:UILabel!
    
    /// 抓取次数的背景view
    let darwCountBgView = UIView()
    
    /// 音频按钮
    var audioBtn:UIButton!
    
    /// 是否显示了反馈页面
    var isShowFeedbackView = false
    
    /// 支付的dialog
    var payDialog:PayListDialog!
    
    /// 主页
    var mainVC:MainViewController!
    
    /// 是否抓中了
    var isGameWinner:Bool = false
    
    /// 分享战绩
    private var showOffRecordDialog:ShowOffRecordDialog!
    
    /// 游戏房间的控制器
    private var gameSceneController:GameSceneController!
    
    /// 切换镜头
    private var playSwitchGuid:MainBeginnerGuidPlaySwitchView!
    
    /// 正在游戏的用户集合
    lazy var gameUserGroup:UIView = UIView()
    
    /// 正在游戏的用户头像
    lazy var gameUserImage = UIImageView()
    
    /// 正在游戏的用户昵称
    lazy var gameUserNickName = MainCustomerLabel()
    
    /// 正在游戏的用户昵称背景
    lazy var gameUserNickNameBackground = UIView()
    
    /// 游戏中的弹窗
    var gameUserInfoDialog:GameUserInfoDialog!
    
    var gameUserInfo:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameUserInfoDialog = GameUserInfoDialog(frame: UIScreen.main.bounds)
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        outGameDialog = OutGameDialog(frame: UIScreen.main.bounds)
        
        playResultDialog = PlayResultDialog(frame: UIScreen.main.bounds)
        
        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = UIColor.white
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;   //禁用侧滑手势
        
        setupUI()
        
        createPlayUserInfo()
        
        let infoTap = UITapGestureRecognizer(target: self, action: #selector(showGameUserInfo))
        infoTap.numberOfTapsRequired = 1
        gameUserImage.isUserInteractionEnabled = true
        gameUserGroup.isUserInteractionEnabled = true
        gameUserImage.isMultipleTouchEnabled = true
        view.isUserInteractionEnabled = true
        
        gameUserImage.addGestureRecognizer(infoTap)
        
        /// 播放背景音乐
        playBackgroundMusic()
        
        ToastUtils.showLoadingToast(msg: "正在加入房间")
        
        /// 初始化
        gameSceneController = GameSceneController(playViewController: self, deviceId: deviceId)
        gameSceneController.connectSocket()
        
        if UserDefaults.standard.bool(forKey: Constants.IS_FIRST_OPEN_PLAY) == false {
            playSwitchGuid = MainBeginnerGuidPlaySwitchView(frame: UIScreen.main.bounds)
            playSwitchGuid.createView2(playViewController: self)
            playSwitchGuid.show2()
            UserDefaults.standard.set(true, forKey: Constants.IS_FIRST_OPEN_PLAY)
        }
        
    }

    @objc func showGameUserInfo() -> () {
        if gameUserInfo == nil {
            return
        }
        gameUserInfoDialog.dataSources = gameUserInfo
        gameUserInfoDialog.createView()
        gameUserInfoDialog.show()
    }
    
    deinit {
        UIApplication.shared.isIdleTimerDisabled = false
//        out(deviceId: deviceId)
        agoraKit.leaveChannel { (starts) in
            //离开直播间
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
        bgMusicPlayer.stop()
        wardCode = ""
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
}


// MARK: - 装载与游戏相关的控件
extension PlayViewController{
    
    /// 加载UI
    func setupUI() -> () {
        createBackground()
        
        createVideo()
        
        createBtns()
        
        /// 创建底部展示的奖品
        createBottomGroup()
        
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
        
        let playGameBackgroundImage = UIImageView(image: UIImage(named: "play_game_background_blue"))
        playGameBackgroundImage.sizeToFit()
        playGameBackgroundImage.frame = CGRect(x: 0, y: UIScreen.main.bounds.height/2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
        view.addSubview(playGameBackgroundImage)
        
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
    
    /// 创建游戏相关按钮
    func createVideoBtns() -> () {
        /// 教程按钮
        let helpBtn = UIButton(type: .custom)
        helpBtn.setImage(UIImage(named: "icon_qa"), for: .normal)
        helpBtn.sizeToFit()
        view.addSubview(helpBtn)
        
        helpBtn.addTarget(self, action: #selector(showFeecbackView), for: .touchUpInside)
        
        helpBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(videoView).offset(-40)
            make.left.equalTo(self.view).offset(10)
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
        
        lensBtn.setImage(UIImage(named: "icon_lens"), for: .normal)
        lensBtn.sizeToFit()
        view.addSubview(lensBtn)
        
        lensBtn.addTarget(self, action: #selector(changeLens(sender:)), for: .touchUpInside)
        
        lensBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(helpBtn)
            make.right.equalTo(self.view).offset(-10)
        }
        
        lensBtn.isHidden = true
        
        darwCountLabel = UILabel()
        darwCountLabel.text = "游戏0次   抓中0次"
        darwCountLabel.textColor = UIColor.white
        darwCountLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        darwCountLabel.sizeToFit()
        
        darwCountBgView.frame.size = CGSize(width: darwCountLabel.bounds.width * 2, height: darwCountLabel.bounds.height * 1.5)
        darwCountBgView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
        darwCountBgView.layer.cornerRadius = (darwCountLabel.bounds.height * 1.5)/2
        darwCountBgView.layer.masksToBounds = true
        view.addSubview(darwCountBgView)
    
        view.addSubview(darwCountLabel)
        
        darwCountBgView.frame = CGRect(x: self.view.bounds.width - darwCountBgView.bounds.width - 10, y: videoView.bounds.height - darwCountBgView.bounds.height - 5, width: darwCountBgView.bounds.width, height: darwCountBgView.bounds.height)
        
        darwCountLabel.center = darwCountBgView.center
        
    }

    func updateAwardUI() -> () {
        darwCountLabel.sizeToFit()
        darwCountBgView.frame.size = CGSize(width: darwCountLabel.bounds.width * 1.5, height: darwCountLabel.bounds.height * 1.5)
        darwCountBgView.frame = CGRect(x: self.view.bounds.width - darwCountBgView.bounds.width - 10, y: videoView.bounds.height - darwCountBgView.bounds.height - 5, width: darwCountBgView.bounds.width, height: darwCountBgView.bounds.height)
        
        darwCountLabel.center = darwCountBgView.center
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
    
    @objc func showFeecbackView() -> () {
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
    
    /// 创建开始游戏的按钮
    func createStartBtn() -> () {
        let startBtnImage = UIImage(named: "icon_start")
//        startBtnBackgroundView.backgroundColor = UIColor(red: 91/255.0, green: 177/255.0, blue: 228/255.0, alpha: 1.0)
        startBtnBackgroundView.frame = CGRect(x: 0, y: videoView.bounds.height, width: self.view.bounds.width, height: startBtnImage!.size.height * 1.5 + 25)
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
    
    /// 关闭当前页面
    @objc func backBtnClick() -> () {
        if isGameing {
            /// 游戏中点击返回键
            outGameDialog.createView()
            outGameDialog.show2 {[weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            return
        }
        UIApplication.shared.isIdleTimerDisabled = false
        /// 取消再来一次的倒计时
        isReplayCounting = false
        
        /// 退出游戏队列
        gameSceneController.quitQueue()
        
        /// 断开socket连接
        gameSceneController.disconnect()
        gameSceneController = nil
        
        out(deviceId: deviceId)
        self.navigationController?.popViewController(animated: true)
        ToastUtils.hide()
        
//        if isGameWinner {
//            
//        }
    }
}


// MARK: - 创建直播视屏的view
extension PlayViewController{
    
    /// 创建video 的view
    func createVideo() -> () {
        videoView.backgroundColor = UIColor.white
        videoView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 0.5 + UIApplication.shared.statusBarFrame.height)
        view.addSubview(videoView)
        
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "a61c87d429a748cfbdae28178e082289", delegate: self)
        
        /// 默认是直播模式
        agoraKit.setChannelProfile(AgoraRtcChannelProfile.channelProfile_LiveBroadcasting)
        agoraKit.enableDualStreamMode(true)
        
        agoraKit.disableAudio()
        
        agoraKit.enableLocalVideo(false)
        agoraKit.enableVideo()
        
        agoraKit.setVideoProfile(._VideoProfile_480P_3, swapWidthAndHeight: false)
        agoraKit.setClientRole(AgoraRtcClientRole.clientRole_Audience, withKey: nil)
        
//        agoraKit.muteAllRemoteAudioStreams(true)
        
//        let hostingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        hostingView.translatesAutoresizingMaskIntoConstraints = false
        
        let code = agoraKit.joinChannel(byKey: nil, channelName: deviceId + "live", info: nil, uid: 878, joinSuccess: nil)
        
        if code != 0 {
            DispatchQueue.main.async(execute: {
                print("Join channel failed: \(code)")
            })
        }else {
            isLive = true
            print("进入直播房间成功:\(code)")
        }
        
        // 在没有游戏时，隐藏摄像头的按钮
        lensBtn.isHidden = true
    }
    
    /// 切换视频的房间到一对一聊天界面
    func switchVideoChannelToDefault() -> () {
        
        if !isLive {
            /// 已经是游戏中了，直接展示游戏界面
            showPlayGroup()
            return
        }
        
        bgMusicPlayer.pause()
        ToastUtils.showLoadingToast(msg: "进入游戏房间")
        
        /// 首次切换，清空ID
        defaultVideoIds.removeAll()
        
        isLive = false
        
        agoraKit.leaveChannel { (starts) in
            print("在进入前，先离开上一个房间")
        }
        
        agoraKit.setChannelProfile(AgoraRtcChannelProfile.channelProfile_Communication)
        
        let code = agoraKit.joinChannel(byKey: nil, channelName: deviceId + "", info: nil, uid: 0, joinSuccess: nil)
        
        if code != 0 {
            DispatchQueue.main.async(execute: {
                print("Join channel failed: \(code)")
            })
        }else {
            print("进入房间成功:\(code)")
            
            if !isCloseMusic{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: { [weak self] in
                    self?.playStartGame()
                })
            }
        }
        
        agoraKit.setupRemoteVideo(nil)
        let canvas = AgoraRtcVideoCanvas()
        canvas.view = videoView
        canvas.uid = 2
        canvas.renderMode = .render_Hidden
        
        nowVideoId = 2
        
        agoraKit.setRemoteVideoStream(UInt(2), type: .videoStream_High)
        agoraKit.setupRemoteVideo(canvas)
    }
    
    // 切换镜头
    @objc func changeLens(sender:UIButton) -> () {
        if !isLive {
            lensBtn.isEnabled = false
            //不是直播模式，就是在游戏中
//            for item in defaultVideoIds {
//                if item != nowDefaultVideoId {
//                    switchLens(uid: item)
//                    break
//                }
//            }
            /// 判断一下镜头
            if nowVideoId == 2 {
                switchLens(uid: 1)
                nowVideoId = 1
            }else{
                switchLens(uid: 2)
                nowVideoId = 2
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
        
        bgMusicPlayer.pause()
        ToastUtils.showLoadingToast(msg: "退出游戏房间")
        
        /// 把video的id切回去
        nowVideoId = UInt(1)
        
        /// 首次切换，清空ID
        liveVideoIds.removeAll()
        
        agoraKit.leaveChannel { (starts) in
            print("在进入前，先离开上一个房间")
        }
        
        agoraKit.setChannelProfile(AgoraRtcChannelProfile.channelProfile_LiveBroadcasting)
        
        let code = agoraKit.joinChannel(byKey: nil, channelName: deviceId + "live", info: nil, uid: 0, joinSuccess: nil)
        
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
        print("到这里了")
        // 初始化成功
        if isLive {
            agoraKit.setupRemoteVideo(nil)
            let canvas = AgoraRtcVideoCanvas()
            canvas.view = videoView
            canvas.uid = uid
            canvas.renderMode = .render_Hidden
            
            agoraKit.setRemoteVideoStream(UInt(uid), type: .videoStream_High)
            agoraKit.setupRemoteVideo(canvas)
        }else{
            
        }
        ToastUtils.hide()
        if !isCloseMusic {
            bgMusicPlayer.play()
        }
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
    
//    /// 进入房间
//    fileprivate func enter(){
//        if Constants.User.USER_ID == "" {
//            return
//        }
//
//        var params = NetWorkUtils.createBaseParams()
//        params["deviceid"] = deviceId
//
//        Alamofire.request(Constants.Network.Machine.ENTER_WATCH, method: .post, parameters: params).responseJSON { (response) in
//            if NetWorkUtils.checkReponse(response: response) {
//                let json = JSON(data: response.data!)
//                self.setupInfo(resultData:json)
//            }
//        }
//    }
//
//    /// 装载数据
//    fileprivate func setupInfo(resultData:JSON) -> () {
//        if let watchNumber = resultData["data"]["waitWatchCount"].int {
//            playNumber.text = String(watchNumber) + "人观看"
//        }
//
//        if let queue = resultData["data"]["waitCtlCount"].int {
//            queueNumber.text = String(queue) + "人等待"
//        }
//        gemLabel.text = String(Constants.User.diamondsCount)
//    }
    
    /// 退出房间
    fileprivate func out(deviceId:String){
        if Constants.User.USER_ID == "" {
            return
        }
        if gameSceneController != nil {
            gameSceneController.quitQueue()
        }
//        endQueue(deviceId: deviceId)
        
//        var params = NetWorkUtils.createBaseParams()
//        params["deviceid"] = deviceId
//        Alamofire.request(Constants.Network.Machine.OUT_WATCH, method: .post, parameters: params).responseJSON { (response) in
//            if response.error == nil && response.data != nil {
//                print("result_退出房间:\(response.result.value ?? "")")
//            }
//        }
    }
    
    /// 取消预约
//    fileprivate func endQueue(deviceId:String){
//        var params = NetWorkUtils.createBaseParams()
//        params["deviceid"] = deviceId
//        Alamofire.request(Constants.Network.Machine.END_PALY, method: .post, parameters: params).responseJSON { (response) in
//            if response.error == nil && response.data != nil {
//                print("result_取消预约:\(response.result.value ?? "")")
//            }
//        }
//    }
    
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
        
        let controllerSize = UIScreen.main.bounds.width * 0.12
        
        /// 上
        controllerUp = CustomerControllerButton(frame: CGRect.zero, controllerDown: { [weak self] (button)  in
            self?.controllerPathDown(sender: button)
        }, controllerUp: { [weak self] (button) in
            self?.controllerPathUp(sender: button)
        }, controllerMove:{[weak self] (button) in
            self?.controllerMove(sender: button)
        })
        controllerUp.setImage(UIImage(named: "controller_up"), for: .normal)
        controllerUp.setImage(UIImage(named: "controller_up_h"), for: .highlighted)
        controllerUp.setImage(UIImage(named: "controller_up_disabled"), for: .disabled)
        controllerUp.sizeToFit()
        playGroupView.addSubview(controllerUp)
        
        /// 左
        controllerLeft = CustomerControllerButton(frame: CGRect.zero, controllerDown: {[weak self] (button) in
            self?.controllerPathDown(sender: button)
        }, controllerUp: {[weak self] (button) in
            self?.controllerPathUp(sender: button)
        }, controllerMove:{[weak self] (button) in
            self?.controllerMove(sender: button)
        })
        controllerLeft.setImage(UIImage(named: "controller_left"), for: .normal)
        controllerLeft.setImage(UIImage(named: "controller_left_h"), for: .highlighted)
        controllerLeft.setImage(UIImage(named: "controller_left_disabled"), for: .disabled)
        controllerLeft.sizeToFit()
        playGroupView.addSubview(controllerLeft)
        
        controllerLeft.snp.makeConstraints { (make) in
            make.width.equalTo(controllerSize)
            make.height.equalTo(controllerSize)
            make.right.equalTo(controllerUp).offset(-(controllerSize))
            make.centerY.equalTo(playGroupView)
        }
    
        /// 右
        controllerRight = CustomerControllerButton(frame: CGRect.zero, controllerDown: {[weak self] (button) in
            self?.controllerPathDown(sender: button)
        }, controllerUp: {[weak self] (button) in
            self?.controllerPathUp(sender: button)
        }, controllerMove:{[weak self] (button) in
            self?.controllerMove(sender: button)
        })
        controllerRight.setImage(UIImage(named: "controller_right"), for: .normal)
        controllerRight.setImage(UIImage(named: "controller_right_h"), for: .highlighted)
        controllerRight.setImage(UIImage(named: "controller_right_disabled"), for: .disabled)
        controllerRight.sizeToFit()
        playGroupView.addSubview(controllerRight)
        
        controllerRight.snp.makeConstraints { (make) in
            make.width.equalTo(controllerSize)
            make.height.equalTo(controllerSize)
            make.left.equalTo(controllerUp).offset(controllerSize)
            make.centerY.equalTo(playGroupView)
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
        controllerDown.setImage(UIImage(named: "controller_down_h"), for: .highlighted)
        controllerDown.setImage(UIImage(named: "controller_down_disabled"), for: .disabled)
        controllerDown.sizeToFit()
        playGroupView.addSubview(controllerDown)
        
        controllerUp.snp.makeConstraints { (make) in
            make.width.equalTo(controllerSize)
            make.height.equalTo(controllerSize)
            make.left.equalTo(self.view).offset(20 + controllerSize)
            make.bottom.equalTo(controllerLeft).offset(-controllerSize)
        }
        
        controllerDown.snp.makeConstraints { (make) in
            make.width.equalTo(controllerSize)
            make.height.equalTo(controllerSize)
            make.centerX.equalTo(controllerUp)
            make.top.equalTo(controllerLeft).offset(controllerSize)
        }
        
        controllerDown.addTarget(self, action: #selector(controllerPathDown(sender:)), for: .touchUpInside)
        controllerDown.addTarget(self, action: #selector(controllerPathUp(sender:)), for: .touchUpOutside)
        
        /// 下爪
        grabBtn.setImage(UIImage(named: "controller_grab"), for: .normal)
        grabBtn.setImage(UIImage(named: "controller_grab_h"), for: .highlighted)
        grabBtn.setImage(UIImage(named: "controller_grab_disabled"), for: .disabled)
        grabBtn.sizeToFit()
        playGroupView.addSubview(grabBtn)
        
        grabBtn.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width * 0.21)
            make.height.equalTo(UIScreen.main.bounds.width * 0.21)
            make.centerY.equalTo(playGroupView)
            make.right.equalTo(self.view).offset(-20)
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
        playGroupView.addSubview(playTime)
        
        playTime.snp.makeConstraints { (make) in
            make.centerX.equalTo(grabBtn)
            make.top.equalTo(grabBtn).offset(UIScreen.main.bounds.width * 0.21 + 2.5)
            make.width.equalTo(100)
        }
        
        playGroupView.isHidden = true
    }
    
    /// 展示游戏界面
    func showPlayGroup() -> () {
        
        playGroupView.isHidden = false
        isGrab = false
        
        resetReplayInfo()
        
        isGameing = true
        
        startPlayBtn.isEnabled = false
        disableControllerBtns(isEnbled: true)
        
        lensBtn.isHidden = false
        
        //振动
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        countdownTimer?.invalidate()
        countdownTimer = nil
        
        isCounting = true
    }
    
    func hidePlayGroup() -> () {
//        startPlayBtn.isEnabled = true
        playGroupView.isHidden = true
        countdownTimer?.invalidate()
        countdownTimer = nil
        disableControllerBtns(isEnbled: false)
        /// 开始进行再来一局的倒计时
        
        lensBtn.isHidden = true
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
        
        Alamofire.request(Constants.Network.Machine.START_PLAY, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                print("开始游戏回调:\(String(describing: response.result.value))")
                let json = JSON(response.result.value!)
                
                if json["data"]["errcode"].intValue == 0 {
                    /// 切换到另一个房间
                    self.switchVideoChannelToDefault()
                    
                    ///成功
                    self.showPlayGroup()
                    
                    self.gemLabel.text = String(json["data"]["diamondsCount"].int!)
                    Constants.User.diamondsCount = json["data"]["diamondsCount"].intValue
                    self.wardCode = json["data"]["gTradeNo"].string!
                }else if json["data"]["errcode"].intValue == 2 {
                    ///钻石不足
                    ToastUtils.showErrorToast(msg: "代币不足")
                }
                
            }else {
                print("error:\(String(describing: response.error))")
            }
            self.isStartClick = false
        }
    }
    
    /// 开始预约
    @objc func waitQueue(){
        if Constants.User.USER_ID == "" {
            needLogin?()
            backBtnClick()
            return
        }
        
        gameSceneController.enterGameQueue()
//        ToastUtils.showLoadingToast(msg: "请稍后……")
        
//        var params = NetWorkUtils.createBaseParams()
//        params["deviceid"] = deviceId
//
//        Alamofire.request(Constants.Network.Machine.WAIT_QUEUE, method: .post, parameters: params).responseJSON { (response) in
//            print("开始预约的回调:\(String(describing: response.result.value)),error:\(String(describing: response.error))")
//            if NetWorkUtils.checkReponse(response: response) {
//                let json = JSON(data: response.data!)
//                if json["data"]["tryLock"].bool! == true {
//                    print("进来了")
//                    // 可以开始游戏了
//                    self.startPlay()
//                    self.playQueueNumberStatus.isHidden = true
//                }else{
//                    print("已经有\(String(describing: json["data"]["waitCtlCount"].int!))人在游戏中，请等候")
//
//                    self.playQueueStausNumber.text = "预约第\(json["data"]["waitCtlIndex"].intValue)位"
//                    self.queueNumber.text = String(json["data"]["waitCtlCount"].intValue) + "人等待"
//
//                    self.playQueueNumberStatus.isHidden = false
//
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {[weak self] in
//                        self?.waitQueue()
//                    })
//                }
//            }else{
//                let json = JSON(data: response.data!)
//                if json["code"].intValue == -520 {
////                    self.endQueue(deviceId: self.deviceId)
//                    if self.gameSceneController != nil {
//                        self.gameSceneController.quitQueue()
//                    }
//                    ToastUtils.showErrorToast(msg: "设备维护中")
//                }
//                /// 当数据data为空的时候，报告异常
//            }
//            ToastUtils.hide()
//        }
    }
    
    ///  按下操作方向
    @objc func controllerPathDown(sender:CustomerControllerButton ) -> () {
        if isGrab {
            // 如果是下爪的过程中，不能操作
            return
        }
        if sender == controllerUp {
            // 上
            if nowVideoId == 2 {
                controllerNetworkPath(path:"3", status: "1")
            }else{
                controllerNetworkPath(path:"0", status: "1")
            }
        }else if sender == controllerDown {
            // 下
            if nowVideoId == 2 {
                controllerNetworkPath(path:"2", status: "1")
            }else{
                controllerNetworkPath(path:"1", status: "1")
            }
        }else if sender == controllerLeft {
            // 左
            if nowVideoId == 2 {
                controllerNetworkPath(path:"0", status: "1")
            }else{
                controllerNetworkPath(path:"2", status: "1")
            }
        }else if sender == controllerRight {
            // 右
            if nowVideoId == 2 {
                controllerNetworkPath(path:"1", status: "1")
            }else{
                controllerNetworkPath(path:"3", status: "1")
            }
        }
    }
    
    @objc func controllerPathUp(sender:CustomerControllerButton ) -> () {
        isControoler = false
        if isGrab {
            // 如果是下爪的过程中，不能操作
            return
        }
        if sender == controllerUp {
            // 上
            if nowVideoId == 2 {
                controllerNetworkPath(path:"3", status: "0")
            }else{
                controllerNetworkPath(path:"0", status: "0")
            }
        }else if sender == controllerDown {
            // 下
            if nowVideoId == 2 {
                controllerNetworkPath(path:"2", status: "0")
            }else{
                controllerNetworkPath(path:"1", status: "0")
            }
        }else if sender == controllerLeft {
            // 左
            if nowVideoId == 2 {
                controllerNetworkPath(path:"0", status: "0")
            }else{
                controllerNetworkPath(path:"2", status: "0")
            }
        }else if sender == controllerRight {
            // 右
            if nowVideoId == 2 {
                controllerNetworkPath(path:"1", status: "0")
            }else{
                controllerNetworkPath(path:"3", status: "0")
            }
        }
    }
    
    func controllerMove(sender:CustomerControllerButton) -> () {

    }
    
    /// 通过网络操作机器臂的方向
    func controllerNetworkPath(path:String, status:String) -> () {
        print("status:\(status)")
        
        gameSceneController.controllerPath(path: path, status: status)
        
//        var params = NetWorkUtils.createBaseParams()
//        params["deviceid"] = deviceId
//        params["direction"] = path
//        params["status"] = status
//
//        Alamofire.request(Constants.Network.Machine.DIECTION_CONTROLLER, method: .post, parameters: params).responseJSON { (response) in
//            if NetWorkUtils.checkReponse(response: response) {
//                print("result:\(String(describing: response.result.value))")
//            }else {
//                print("error:\(String(describing: response.error)),response:\(String(describing: response.response))")
//            }
//        }
    }
    
    /// 下爪
    @objc func controllerGrap() -> () {
        isGrab = true
        gameSceneController.controllerGrap()
//        var params = NetWorkUtils.createBaseParams()
//        params["deviceid"] = deviceId
//
//        Alamofire.request(Constants.Network.Machine.CONTROLLER_CATCH, method: .post, parameters: params).responseJSON { (response) in
//            if NetWorkUtils.checkReponse(response: response) {
//                print("下爪成功")
//                self.hidePlayGroup()
//                self.getWard()
//            }else{
//                print("response:\(response)")
//                self.hidePlayGroup()
//            }
//        }
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
//            playResultDialog.isSuccess = false
//            playResultDialog.createView()
//            playResultDialog.show()
            self.playGrapFail()
            hidePlayGroup()
            /// 展示再来一局的界面
            showRePlayInfo()
            return
        }
        
        var params = NetWorkUtils.createBaseParams()
        params["gtradeno"] = wardCode
        
        Alamofire.request(Constants.Network.Machine.GET_WARD, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(response.result.value!)
                if json["data"]["drawable"].bool! == true {
                    self.getWardCodeNumber = 0
                    print("抓取成功")
                    self.wardCode = ""
//                    self.playResultDialog.isSuccess = true
//                    self.playResultDialog.createView()
//                    self.playResultDialog.show()
                    self.playGrapSuccess()
                    self.hidePlayGroup()
                    /// 展示再来一局的界面
                    self.showRePlayInfo()
//                    self.isGameWinner = true
//                    if self.playSuccess != nil {
//                        self.playSuccess!(self.deviceId)
//                    }
                    self.showShardRecordDialog(deviceId: self.deviceId)
                }else {
                    print("抓取失败")
                    self.getWardCodeNumber = self.getWardCodeNumber + 1
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { [weak self] in
                        self?.getWard()
                    })
                }
            }else{
                print("抓取失败")
                self.getWardCodeNumber = self.getWardCodeNumber + 1
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { [weak self] in
                    self?.getWard()
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
        rePlayGameBtn.setImage(UIImage(named: "replay_start_game_h"), for: .highlighted)
        rePlayGameBtn.sizeToFit()
        view.addSubview(rePlayGameBtn)
        
        rePlayGameBtn.snp.makeConstraints { (make) in
            make.center.equalTo(startPlayBtn)
        }
        
        rePlayGameBtn.addTarget(self, action: #selector(replayGame), for: .touchUpInside)
        
        rePlayGameBtn.isHidden = true
    }
    
    /// 再来一局
    @objc func replayGame() -> () {
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
        
        isGameing = false
    }
    
    /// 展示再来一局的信息
    func showRePlayInfo() -> () {
        /// 展示界面
        rePlayGameBtn.isHidden = false
        rePlayGameTimeLabel.isHidden = false
        /// 开始倒计时
        reStartCreateTime()
        
        isGameing = false
    }
    
    // 隐藏再玩一次的界面
    func hideReplayView() -> () {
        resetReplayInfo()
        
        startPlayBtn.isEnabled = true
        
        isLive = true
        
        /// 把直播的镜头切回去
        swichVideoChannerlToLive()
        
        if gameSceneController != nil {
            gameSceneController.quitQueue()
        }
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
        
        if !isCloseMusic {
            //播放音乐
            bgMusicPlayer.play()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseSong(notification:)), name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playSong(notification:)), name:NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc func pauseSong(notification : NSNotification) {
        bgMusicPlayer.pause()
    }
    
    @objc func playSong(notification : NSNotification) {
        if !isCloseMusic {
            bgMusicPlayer.play()
        }
    }
    
    /// 播放开始游戏的音效
    func playStartGame() -> () {
        if isCloseMusic {
            return
        }
        
        // 建立播放器
        let soundPath = Bundle.main.path(forResource: "游戏开始_音效", ofType: "wav")
        do {
            soundEffect = try AVAudioPlayer(
                contentsOf: NSURL.fileURL(withPath: soundPath!))
            
            // 重複播放次數 設為 0 則是只播放一次 不重複
            soundEffect.numberOfLoops = 0
            
            soundEffect.play()
        } catch {
            print("开始音效，error")
        }
        
//        //建立的SystemSoundID对象
//        var soundID:SystemSoundID = 0
//        //获取声音地址
//        let path = Bundle.main.path(forResource: "游戏开始_音效", ofType: "wav")
//        //地址转换
//        let baseURL = NSURL(fileURLWithPath: path!)
//        //赋值
//        AudioServicesCreateSystemSoundID(baseURL, &soundID)
//        //提醒（同上面唯一的一个区别）
//        AudioServicesPlayAlertSound(soundID)
    }
    
    /// 播放抓取成功的音效
    func playGrapSuccess() -> () {
        if isCloseMusic {
            return
        }
        
        // 建立播放器
        let soundPath = Bundle.main.path(forResource: "抓取成功_音效", ofType: "wav")
        do {
            soundEffect = try AVAudioPlayer(
                contentsOf: NSURL.fileURL(withPath: soundPath!))
            
            // 重複播放次數 設為 0 則是只播放一次 不重複
            soundEffect.numberOfLoops = 0
            
            soundEffect.play()
        } catch {
            print("抓取成功音效，error")
        }
        
//        //建立的SystemSoundID对象
//        var soundID:SystemSoundID = 1
//        //获取声音地址
//        let path = Bundle.main.path(forResource: "抓取成功_音效", ofType: "wav")
//        //地址转换
//        let baseURL = NSURL(fileURLWithPath: path!)
//        //赋值
//        AudioServicesCreateSystemSoundID(baseURL, &soundID)
//        //提醒（同上面唯一的一个区别）
//        AudioServicesPlayAlertSound(soundID)
    }
    
    /// 播放抓取失败的音效
    func playGrapFail() -> () {
        if isCloseMusic {
            return
        }
        
        // 建立播放器
        let soundPath = Bundle.main.path(forResource: "抓取失败_音效", ofType: "wav")
        do {
            soundEffect = try AVAudioPlayer(
                contentsOf: NSURL.fileURL(withPath: soundPath!))
            
            // 重複播放次數 設為 0 則是只播放一次 不重複
            soundEffect.numberOfLoops = 0
            
            soundEffect.play()
        } catch {
            print("抓取失败音效，error")
        }
        
//        //建立的SystemSoundID对象
//        var soundID:SystemSoundID = 2
//        //获取声音地址
//        let path = Bundle.main.path(forResource: "抓取失败_音效", ofType: "wav")
//        //地址转换
//        let baseURL = NSURL(fileURLWithPath: path!)
//        //赋值
//        AudioServicesCreateSystemSoundID(baseURL, &soundID)
//        //提醒（同上面唯一的一个区别）
//        AudioServicesPlayAlertSound(soundID)
    }
    
    /// 播放切换镜头的音效
    func playSwitchMusic() -> () {
        if isCloseMusic {
            return
        }
        
        // 建立播放器
        let soundPath = Bundle.main.path(forResource: "镜头切换_音效", ofType: "wav")
        do {
            soundEffect = try AVAudioPlayer(
                contentsOf: NSURL.fileURL(withPath: soundPath!))
            
            // 重複播放次數 設為 0 則是只播放一次 不重複
            soundEffect.numberOfLoops = 0
            
            soundEffect.play()
        } catch {
            print("镜头切换音效，error")
        }
        
//        //建立的SystemSoundID对象
//        var soundID:SystemSoundID = 3
//        //获取声音地址
//        let path = Bundle.main.path(forResource: "镜头切换_音效", ofType: "wav")
//        //地址转换
//        let baseURL = NSURL(fileURLWithPath: path!)
//        //赋值
//        AudioServicesCreateSystemSoundID(baseURL, &soundID)
//        //提醒（同上面唯一的一个区别）
//        AudioServicesPlayAlertSound(soundID)
    }
    
    /// 关掉声音
    func closeMusic() -> () {
        isCloseMusic = true
        bgMusicPlayer.pause()
    }
}

/// 底部介绍
extension PlayViewController{
    
    /// 底部展示奖品的view
    func createBottomGroup() -> () {
        let topHeight = videoView.bounds.height + startBtnBackgroundView.bounds.height
        bottomGroupView = UIView(frame: CGRect(x: 0, y: topHeight, width: self.view.bounds.width, height: self.view.bounds.height - topHeight))
        view.addSubview(bottomGroupView)
        
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
        view.addSubview(bottomBannerCard)
        
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

//支付相关
extension PlayViewController{
    
    @objc func showPayDialog() -> () {
        if payDialog == nil {
            payDialog = PayListDialog(frame: UIScreen.main.bounds)
        }
        
//        if WeChatShared.isInstall() == false {
//            ToastUtils.showErrorToast(msg: "充值支付出错，您还没有安装微信")
//            return
//        }
        
        payDialog.createView()
        if mainVC != nil {
            payDialog.show2(mainViewController: mainVC)
        }else{
            payDialog.show()
        }
        payDialog.paySuccessCallback = {[weak self] in
            self?.getsUserInfo()
        }
    }
    
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
    
}

extension PlayViewController{
    /// 显示分享战绩的dialog
    func showShardRecordDialog(deviceId:String) -> () {
        if showOffRecordDialog == nil {
            /// 分享战绩
            showOffRecordDialog = ShowOffRecordDialog(frame: UIScreen.main.bounds)
        }
        showOffRecordDialog.createView()
        showOffRecordDialog.show2(deviceId: deviceId)
    }
}







