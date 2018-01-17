//
//  GameSceneViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/11/2.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import Kingfisher
import SwiftyJSON

class GameSceneViewController: UIViewController {

    /***** UI *****/
    
    // 顶部的view
    let topGroupView = UIView()
    
    // 底部的view
    var bottomGroupView:UIView!
    
    // 直播的view
    let liveView = UIView()
    
    /// 直播kit
    weak var agoraKit: AgoraRtcEngineKit!
    
    /// 抓取次数的背景view
    let darwCountBgView = UIView()
    
    /// 抓取次数
    let darwCountLabel = UILabel()
    
    /// 是否显示了反馈页面
    var isShowFeedbackView = false
    
    /// 摄像头按钮
    lazy var lensBtn:UIButton = UIButton(type: UIButtonType.custom)
    
    /// 钻石背景
    lazy var gemBackground:UIImageView = UIImageView()
    
    /// 钻石数量
    lazy var gemLabel:MainCustomerLabel = MainCustomerLabel()
    
    /// 支付的dialog
    var payDialog:PayListDialog!
    
    /// 游戏开始的按钮
    lazy var startPlayBtn:UIButton = UIButton()
    
    /// 观看人数
    var playNumber:MainCustomerLabel!
    
    /// 排队人数
    var queueNumber:MainCustomerLabel!
    
    /// 操作group
    var startBtnBackgroundView = UIView()
    
    /// 正在排队中的view
    var playQueueNumberStatus:UIView!
    var playQueueStausNumber:MainCustomerLabel!
    
    /// 游戏group
    var playGroupView:UIView = UIView()
    
    /// 背景view
    lazy var backgroundView:UIView = UIView()
    
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
    
    /***** UI *****/
    
    /***** audio *****/
    /// 播放声音
    
    var bgMusicPlayer:AVAudioPlayer!
    
    /// 播放音效
    var soundEffect:AVAudioPlayer!
    
    /// 是否关掉了声音
    var isCloseMusic:Bool = false
    
    /// 音频按钮
    var audioBtn:UIButton!
    
    /// 1是正面 2是侧面
    var nowCamareDirection = 1
    
    /***** audio *****/
    
    // 当前设备ID
    var deviceId:String = ""
    
    /// 控制整个长连接
    var gameSceneController:GameSceneController!
    
    /// 是否正在游戏中
    var isGameing = false
    
    /// 切换镜头
    private var playSwitchGuid:MainBeginnerGuidPlaySwitchView!
    
    /// 中奖信息的code
    var wardCode = ""
    
    /// 获取中奖信息的次数
    fileprivate var getWardCodeNumber = 0
    
    /// 再玩一次
    var rePlayGameBtn:UIButton!
    
    /// 再玩一次的倒计时
    var rePlayGameTimeLabel:MainCustomerLabel!
    
    /// 退出游戏的询问框
    var outGameDialog:OutGameDialog!
    
    /// 需要登录
    var needLogin:(()->())? = nil
    
    /// 分享战绩
    private var showOffRecordDialog:ShowOffRecordDialog!
    
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
    
    let gameUserBtn = UIButton(type: UIButtonType.custom)
    
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
    var bottomBannerCardTitle:String!
    
    /// banner详情
    var bottomBannerDialog:PlayInfoBannerDialog!
    
    /// 奖品详情
    var bottomAwardDialog:PlayInfoAwardDialog!
    
    /// 此次游戏需要扣的金币
    var coinNumber = UIView()
    
    var coinNumberLabel = MainCustomerLabel()
    
    /// 开始游戏需要扣掉的金币，由前一个页面传入
    var startCoinNumber = 0
    
    /// 取消排队的按钮
    let quitBtn = UIButton(type: UIButtonType.custom)
    
    /**** dialog ****/
    
    /// 排队到了的dialog
    var queueArriveDialog:QueueArriveDialog!
    
    /**** dialog ****/
    
    var isShowQueueArriveDialog = false
    
    ///游戏失败的弹窗
    var gameFailedDialog:GameFailedDialog!
    
    ///滚动的view
    var rootView:UIScrollView = UIScrollView()
    
    /// 底部详情
    let productBackgroundView = UIImageView()
    
    let productBottomGroup = UIView()
    
    var countdownDialog = StartGameCountdownDialog(frame: UIScreen.main.bounds)
    
    /// 横屏游戏界面
    var horizontalGameScene:HorizontalGameSceneViewController!
    
    /// 是否横屏游戏模式
    var isHorizontalGameStuts = true
    
    /// 是否是杜蕾斯模式
    var isDurexTheme = true
    
    /// 底部的活动集合
    var bottomActivityGroup:UIView = UIView()
    
    /// 活动图片
    var advertiseImg:String = ""
    
    var redirectType:Int = 0
    
    /// 分享的数据
    var shareTitle:String!
    var shareInfo:String!
    var thumbShareImage:String!
    
    /// 商品的信息
    var awardDataSource:JSON!
    
    /// 0元抓的view
    var zeroCatchView:ZeroCatchView!
    
    /// 支付结算的view
    var settlementView:SettlementView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;   //禁用侧滑手势
        
        gameUserInfoDialog = GameUserInfoDialog(frame: UIScreen.main.bounds)
        
        outGameDialog = OutGameDialog(frame: UIScreen.main.bounds)
        
        /// 装载UI控件
        setupUI()
        
        playBackgroundMusic() //播放背景音乐
        
        /// 初始化
        gameSceneController = GameSceneController(playViewController: self, deviceId: deviceId)
        gameSceneController.connectSocket()
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if bgMusicPlayer != nil {
            bgMusicPlayer.stop()
        }
    }
    
    deinit {
        print("GameSceneDeinit")
    }
    
    /// 隐藏当前页面的状态栏
    override open var prefersStatusBarHidden: Bool{
        if UIDevice.current.isX() {
            ///如果是iPhone X不隐藏
            return false
        }
        return true
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
    
    @objc func showGameUserInfo() -> () {
        if gameUserInfo == nil {
            return
        }
        gameUserInfoDialog.dataSources = nil
        gameUserInfoDialog.dataSources = gameUserInfo
        gameUserInfoDialog.createView()
        gameUserInfoDialog.show()
    }
    
}

// MARK: - 排队到达的弹出框
extension GameSceneViewController{
    
    //显示排队到了的弹出框
    func showQueueArriveDialog() -> () {
        if isShowQueueArriveDialog {
            return
        }
        isShowQueueArriveDialog = true
        
        queueArriveDialog = QueueArriveDialog(frame: UIScreen.main.bounds)
        queueArriveDialog.createView()
        queueArriveDialog.show()
        
        queueArriveDialog.cancelCallback = {[weak self] in
            self?.isGameing = false
            self?.gameSceneController.quitQueue()//退出队列
            self?.queueArriveDialog = nil
            self?.isShowQueueArriveDialog = false
            
            ///隐藏排队相关
            self?.quitBtn.isHidden = true
            self?.playQueueNumberStatus.isHidden = true
        }
        
        queueArriveDialog.confirmCallback = {[weak self] in
            //开始游戏
            self?.startPlay()
            self?.quitBtn.isHidden = true
            self?.playQueueNumberStatus.isHidden = true
            self?.queueArriveDialog = nil
            self?.isShowQueueArriveDialog = false
            
            self?.rootView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + UIApplication.shared.statusBarFrame.height)
            
            UIView.animate(withDuration: 0.5) {[weak self] in
                self?.rootView.contentOffset = CGPoint(x: 0, y: -UIApplication.shared.statusBarFrame.height)
            }
        }
    }
    
}

// MARK: - 游戏操作界面
extension GameSceneViewController{
    
    /// 创建操作界面
    func createPlayControllerView() -> () {
        
        let topHeight = topGroupView.bounds.height
        
        playGroupView.frame = CGRect(x: 8, y: topHeight + 10, width: self.view.bounds.width - 16, height: self.view.bounds.height - topGroupView.bounds.height - UIApplication.shared.statusBarFrame.height - 10)
        playGroupView.backgroundColor = UIColor.clear
        rootView.addSubview(playGroupView)
        
        /// 背景图片
        let backgroundImage = UIImageView()
        if isDurexTheme {
            backgroundImage.image = UIImage(named: "杜蕾斯-游戏区底")
        }else{
            backgroundImage.image = UIImage(named: "play_game_background")
        }
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 16, height: self.view.bounds.height - topGroupView.bounds.height - UIApplication.shared.statusBarFrame.height - 10)
//        backgroundImage.frame.size = CGSize(width: self.view.bounds.width, height: self.view.bounds.height - topHeight)
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
        playGroupView.addSubview(controllerUp)
        
        /// 左
        controllerLeft = CustomerControllerButton(frame: CGRect.zero, controllerDown: {[weak self] (button) in
            self?.controllerPathDown(sender: button)
            }, controllerUp: {[weak self] (button) in
                self?.controllerPathUp(sender: button)
            }, controllerMove:{[weak self] (button) in
                self?.controllerMove(sender: button)
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
        playGroupView.addSubview(controllerRight)
        
        controllerRight.snp.makeConstraints { (make) in
            make.width.equalTo(controllerSize)
            make.height.equalTo(controllerSize)
            make.left.equalTo(controllerUp).offset(controllerSize)
            make.centerY.equalTo(playGroupView)
        }
        
        /// 下
        controllerDown = CustomerControllerButton(frame: CGRect.zero, controllerDown: {[weak self] (button) in
            self?.controllerPathDown(sender: button)
            }, controllerUp: {[weak self] (button) in
                self?.controllerPathUp(sender: button)
            }, controllerMove:{[weak self] (button) in
                self?.controllerMove(sender: button)
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
        playTime.font = UIFont.getCustomeYuanTiFont(fontSize: 18)
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
        
        /// 开始游戏之后，隐藏扣币的文字
        coinNumber.isHidden = true
        
        playGroupView.isHidden = false
        isGrab = false
        
        resetReplayInfo()
        
        isGameing = true
        
        startPlayBtn.isEnabled = false
        disableControllerBtns(isEnbled: true)
        
        //振动
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        /// 播放开始游戏的音效
        playStartGame()
        
        countdownTimer?.invalidate()
        countdownTimer = nil
        
        isCounting = true
    }
    
    /// 操作界面置灰
    func hidePlayGroup() -> () {
        countdownTimer?.invalidate()
        countdownTimer = nil
        disableControllerBtns(isEnbled: false)
        /// 开始进行再来一局的倒计时
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
                    self.wardCode = json["data"]["gTradeNo"].string!
                    if self.isHorizontalGameStuts {
                        /// 判断是否横屏，是否是杜蕾斯的样式 --- 跳转到横屏页面
                        if self.agoraKit != nil {
                            self.agoraKit.leaveChannel({ (status) in
                                self.showHorizontalGameSceneView()
                            })
                        }else{
                            self.showHorizontalGameSceneView()
                        }
                    }else{
                        /// 切换到另一个房间
                        self.switchGameMode()
                        //成功
                        self.showPlayGroup()
                        
                        self.gemLabel.text = String(json["data"]["diamondsCount"].int!)
                        Constants.User.diamondsCount = json["data"]["diamondsCount"].intValue
                        
                        self.productBottomGroup.isHidden = true
                        
                        self.bottomActivityGroup.isHidden = true
                    }
                }else if json["data"]["errcode"].intValue == 2 {
                    ///钻石不足
                    ToastUtils.showErrorToast(msg: "代币不足")

                    self.playGroupView.isHidden = true
                    
                    self.startPlayBtn.isEnabled = true
                    self.switchNotGameMode()
                    
                    if self.gameSceneController != nil {
                        self.gameSceneController.quitQueue()
                    }
                    
                    self.hidePlayGroupView()
                }else{
                    ToastUtils.showErrorToast(msg: "开始游戏错误")
                    self.playGroupView.isHidden = true
                    
                    self.startPlayBtn.isEnabled = true
                    
                    if self.gameSceneController != nil {
                        self.gameSceneController.quitQueue()
                    }
                    
                    self.hidePlayGroupView()
                }
                
            }else {
                self.hidePlayGroupView()
            }
            self.isStartClick = false
        }
    }
    
    func showHorizontalGameSceneView() -> () {
        if self.horizontalGameScene == nil {
            countdownDialog.createView()
            countdownDialog.show()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.3) {[weak self] in
                self?.horizontalGameScene = HorizontalGameSceneViewController()
                self?.horizontalGameScene.deviceId = (self?.deviceId)!
                self?.horizontalGameScene.gameSceneVC = self
                self?.horizontalGameScene.isDurexTheme = (self?.isDurexTheme)!
                self?.present((self?.horizontalGameScene)!, animated: true, completion: nil)
                
                self?.isGameing = true
                
                self?.agoraKit = nil
            }
        }else{
            self.horizontalGameScene.startGame()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {[weak self] in
            self?.countdownDialog.hide()
        }
    }
    
    /// 开始预约
    @objc func waitQueue(){
        if Constants.User.USER_ID == "" {
            needLogin?()
            backBtnClick()
            return
        }
        
        if Constants.User.diamondsCount < self.startCoinNumber {
            ToastUtils.showErrorToast(msg: "余额不足，请充值")
            return
        }
        
        gameSceneController.enterGameQueue()
    }
    
    @objc func horizontalControllerPathDown(sender:Int, nowCamareDirection:Int){
        if sender == 1 {
            // 上
            if nowCamareDirection != 2 {
                controllerNetworkPath(path:"3", status: "1")
            }else{
                controllerNetworkPath(path:"0", status: "1")
            }
        }else if sender == 2 {
            // 下
            if nowCamareDirection != 2 {
                controllerNetworkPath(path:"2", status: "1")
            }else{
                controllerNetworkPath(path:"1", status: "1")
            }
        }else if sender == 3 {
            // 左
            if nowCamareDirection != 2 {
                controllerNetworkPath(path:"0", status: "1")
            }else{
                controllerNetworkPath(path:"2", status: "1")
            }
        }else if sender == 4 {
            // 右
            if nowCamareDirection != 2 {
                controllerNetworkPath(path:"1", status: "1")
            }else{
                controllerNetworkPath(path:"3", status: "1")
            }
        }
    }
    
    @objc func horizontalControllerPathUp(sender:Int, nowCamareDirection:Int){
        if sender == 1 {
            // 上
            if nowCamareDirection != 2 {
                controllerNetworkPath(path:"3", status: "0")
            }else{
                controllerNetworkPath(path:"0", status: "0")
            }
        }else if sender == 2 {
            // 下
            if nowCamareDirection != 2 {
                controllerNetworkPath(path:"2", status: "0")
            }else{
                controllerNetworkPath(path:"1", status: "0")
            }
        }else if sender == 3 {
            // 左
            if nowCamareDirection != 2 {
                controllerNetworkPath(path:"0", status: "0")
            }else{
                controllerNetworkPath(path:"2", status: "0")
            }
        }else if sender == 4 {
            // 右
            if nowCamareDirection != 2 {
                controllerNetworkPath(path:"1", status: "0")
            }else{
                controllerNetworkPath(path:"3", status: "0")
            }
        }
    }
    
    ///  按下操作方向
    @objc func controllerPathDown(sender:CustomerControllerButton ) -> () {
        if isGrab {
            // 如果是下爪的过程中，不能操作
            return
        }
        if sender == controllerUp {
            // 上
            if nowCamareDirection != 2 {
                controllerNetworkPath(path:"3", status: "1")
            }else{
                controllerNetworkPath(path:"0", status: "1")
            }
        }else if sender == controllerDown {
            // 下
            if nowCamareDirection != 2 {
                controllerNetworkPath(path:"2", status: "1")
            }else{
                controllerNetworkPath(path:"1", status: "1")
            }
        }else if sender == controllerLeft {
            // 左
            if nowCamareDirection != 2 {
                controllerNetworkPath(path:"0", status: "1")
            }else{
                controllerNetworkPath(path:"2", status: "1")
            }
        }else if sender == controllerRight {
            // 右
            if nowCamareDirection != 2 {
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
            if nowCamareDirection != 2 {
                controllerNetworkPath(path:"3", status: "0")
            }else{
                controllerNetworkPath(path:"0", status: "0")
            }
        }else if sender == controllerDown {
            // 下
            if nowCamareDirection != 2 {
                controllerNetworkPath(path:"2", status: "0")
            }else{
                controllerNetworkPath(path:"1", status: "0")
            }
        }else if sender == controllerLeft {
            // 左
            if nowCamareDirection != 2 {
                controllerNetworkPath(path:"0", status: "0")
            }else{
                controllerNetworkPath(path:"2", status: "0")
            }
        }else if sender == controllerRight {
            // 右
            if nowCamareDirection != 2 {
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
    }
    
    /// 下爪
    @objc func controllerGrap() -> () {
        isGrab = true
        gameSceneController.controllerGrap()
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
            self.playGrapFail()
            hidePlayGroup()
            /// 展示再来一局的界面
            showGameFailedDialog()
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
                    self.playGrapSuccess()
                    self.hidePlayGroup()
                    /// 展示再来一局的界面
                    self.showShardRecordDialog(deviceId: self.deviceId)
                }else {
                    print("抓取失败")
                    self.getWardCodeNumber = self.getWardCodeNumber + 1
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: { [weak self] in
                        self?.getWard()
                    })
                }
            }else{
                print("抓取失败")
                self.getWardCodeNumber = self.getWardCodeNumber + 1
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: { [weak self] in
                    self?.getWard()
                })
            }
        }
    }
}

// MARK: - 再玩一次的逻辑
extension GameSceneViewController{
    
    /// 创建倒计时的时间文字
    func createReStartTimeLabel() -> () {
        rePlayGameTimeLabel = MainCustomerLabel()
        rePlayGameTimeLabel.text = "0:15"
        rePlayGameTimeLabel.outTextColor = UIColor.white
        rePlayGameTimeLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        rePlayGameTimeLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        rePlayGameTimeLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 16)
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
        
        playGroupView.isHidden = true
        
        startPlayBtn.isEnabled = true
        
        /// 把直播的镜头切回去
        switchNotGameMode()
        
        if gameSceneController != nil {
            gameSceneController.quitQueue()
        }
    }
}

extension GameSceneViewController{
    
    /// 显示分享战绩的dialog
    func showShardRecordDialog(deviceId:String) -> () {
        
        if startCoinNumber <= 0 {
            /// 这是个0元抓
            
            print("award:\(awardDataSource)")
            
            zeroCatchView.productImage.kf.setImage(with: URL(string: awardDataSource["img"].stringValue))
            zeroCatchView.productTitle.text = awardDataSource["title"].stringValue
            zeroCatchView.productDesc.text = awardDataSource["description"].stringValue
            zeroCatchView.updateProductPriceNumber(price: awardDataSource["buyPrice"].doubleValue, oPrice: awardDataSource["otherPrice"].stringValue)
            
            zeroCatchView.show()
            
            zeroCatchView.payButton.addTarget(self, action: #selector(payProduct), for: .touchUpInside)
            
            self.hidePlayGroupView()
            
            return
        }
        
        if showOffRecordDialog == nil {
            /// 分享战绩
            showOffRecordDialog = ShowOffRecordDialog(frame: UIScreen.main.bounds)
            showOffRecordDialog.isDurexTheme = isDurexTheme
        }
        showOffRecordDialog.createView()
        showOffRecordDialog.show2(deviceId: deviceId)
        
        showOffRecordDialog.cancelCallback = {[weak self] in
            self?.hidePlayGroupView()
        }
        
        showOffRecordDialog.confirmCallback = {[weak self] in
            if (self?.againCheckGemNumber())! {
                self?.startPlay()
            }
        }
    }
    
    /// 购买商品
    @objc func payProduct(){
        settlementView.isVip = true
        settlementView.aid = awardDataSource["id"].intValue
        settlementView.vipRP = -10
        settlementView.vipNumber = awardDataSource["buyPrice"].doubleValue
        settlementView.updateInfo()
        settlementView.show()
        
        settlementView.successCallback = {[weak self] in
            self?.zeroCatchView.hide()
        }
    }
    
}

// MARK: - 游戏失败的弹窗
extension GameSceneViewController{
    
    ///显示游戏失败的弹窗
    func showGameFailedDialog() -> () {
        gameFailedDialog = GameFailedDialog(frame: UIScreen.main.bounds)
        gameFailedDialog.isDurexTheme = isDurexTheme
        gameFailedDialog.createView()
        gameFailedDialog.show()
        
        gameFailedDialog.cancelCallback = {[weak self] in
            self?.hidePlayGroupView()
            self?.gameFailedDialog = nil
        }
        
        gameFailedDialog.confirmCallback = {[weak self] in
            if (self?.againCheckGemNumber())! {
                self?.startPlay()
                self?.gameFailedDialog = nil
            }
        }
    }
    
    /// 再来一局的地方检查用户代币够不够
    func againCheckGemNumber() -> (Bool) {
        if Constants.User.diamondsCount < self.startCoinNumber {
            ToastUtils.showErrorToast(msg: "金币不足，请充值")
            hidePlayGroup()
            return false
        }
        return true
    }
    
    /// 隐藏游戏界面
    func hidePlayGroupView() -> () {
        if self.isHorizontalGameStuts {
            self.initLive()
            self.horizontalGameScene.dismiss(animated: true, completion: nil)
            
            self.horizontalGameScene = nil
        }
        
        self.playGroupView.isHidden = true
        
        self.startPlayBtn.isEnabled = true
        
        self.isGameing = false
        
        /// 把直播的镜头切回去
        self.switchNotGameMode()
        
        /// 显示扣币文字
        self.coinNumber.isHidden = false
        
        if self.gameSceneController != nil {
            self.gameSceneController.quitQueue()
        }
        
        self.rootView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.topGroupView.bounds.height + self.startBtnBackgroundView.bounds.height + self.productBackgroundView.bounds.height + self.bottomActivityGroup.bounds.height)
        
        self.productBottomGroup.isHidden = false
        
        self.bottomActivityGroup.isHidden = false
    }
}

extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
}








