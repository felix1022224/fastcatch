//
//  GameRoomViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/22.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AVFoundation

class GameRoomViewController: UIViewController {

    var deviceId = ""
    
    /// 根布局
    var rootView = UIScrollView()
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    let backBtn = UIButton(type: UIButtonType.custom)
    
    /// 该房间的数据
    var gameRoomData:JSON!
    
    /// 直播的view
    var liveView = UIView()
    
    /// 状态栏的高度
    var statusHeight = UIDevice.current.isX() ? 44 : 20
    
    /// 游戏操作界面的view
    var gameControllerGroupView = UIView()
    
    /// 金币的数量
    var goldNumber = UILabel()
    
    /// 金币集合的view
    var goldGroupView = UIView()
    
    /// 金币前面的icon
    var goldIcon = UIImageView()
    
    /// 充值按钮
    var payButton = UIButton()
    
    /// 直播kit
    var agoraKit: AgoraRtcEngineKit!
    
    /// 1是正面 2是侧面
    var nowCamareDirection = 1
    
    /// 切换镜头按钮
    var switchCamareBtn = UIButton()
    
    /// 景品详细信息介绍
    var productInfoGroupView = UIView()
    
    /// 商品名称
    var productNameLabel = UILabel()
    
    /// 商品介绍
    var productInfoLabel = UILabel()
    
    /// 商品图片
    var productImage = UIImageView()
    
    /// 开始游戏按钮
    var startGameBtn = UIButton(type: UIButtonType.custom)
    
    /// 开始游戏需要的金币个数
    let startGameNumberLabel = UILabel()
    
    /// 帮助按钮
    let helpBtn = UIButton(type: UIButtonType.custom)
    
    /// 是否显示了反馈页面
    var isShowFeedbackView = false
    
    /***** audio *****/
    /// 播放声音
    
    var bgMusicPlayer:AVAudioPlayer!
    
    /// 播放音效
    var soundEffect:AVAudioPlayer!
    
    /// 是否关掉了声音
    var isCloseMusic:Bool = false
    
    /// 音频按钮
    var audioBtn:UIButton = UIButton.init(type: UIButtonType.custom)
    
    /// 游戏房间内需要显示的数字的集合view
    var gameRoomNumberGroupView = UIView()
    
    /// 观看人数
    var watchNumber = UIImageView()
    var watchNumberLabel = UILabel()
    
    /// 等待游戏人数
    var queueNumber = UIImageView()
    var queueNumberLabel = UILabel()
    
    /// 游戏次数
    var gameNumber = UIImageView()
    var gameNumberLabel = UILabel()
    
    /// 下爪按钮
    var grabBtn = UIButton()
    
    /// controller up
    var controllerUp:CustomerControllerButton!
    
    /// play time
    lazy var playTime:MainCustomerLabel = MainCustomerLabel()
    
    /// controller down
    var controllerDown:CustomerControllerButton!
    
    /// controller left
    var controllerLeft:CustomerControllerButton!
    
    /// controller right
    var controllerRight:CustomerControllerButton!
    
    /// 是否已经下爪
    var isGrab:Bool = false
    
    /// 是否正在操作
    var isControoler:Bool = false
    
    /// 是否调用了开始游戏
    var isStartClick:Bool = false
    
    /// 游戏房间socket操作
    var gameRoomNetworkController:GameRoomNetworkController!
    
    /// 游戏过程中的label
    var gameTimerLabel = UILabel()
    
    /// 获取中奖信息的次数
    var getWardCodeNumber = 0
    
    /// 中奖信息的code
    var wardCode = ""
    
    /// 游戏失败的弹窗
    var gameFailDialog:GameFailDialog!
    
    /// 游戏胜利的弹窗
    var gameVictoryDialog:GameVictoryDialog!
    
    /// 排队到了的弹窗
    var queuedUpDialog:GameQueuedUpDialog!
    
    /// 游戏中的用户信息集合
    var gameUserGroupView = UIView()
    
    /// 游戏中的用户名称
    var gameUserNickName = UILabel()
    
    /// 游戏中的用户头像
    var gameUserAvatar = UIImageView()
    
    /// 是否排队中
    var isQueue = false
    
    /// 取消排队
    var queueCancelBtn = UIButton.init(type: UIButtonType.custom)
    
    /// 排在第几位
    var queueIndexLabel = UILabel()
    
    /// 是否游戏中
    var isGameing = false
    
    let vipView = UIImageView()
    
    /// 游戏中的用户dialog
    var playingGameDialog:PlayingGameDialog!
    
    /// 正在游戏中的用户信息
    var playingGameDataSource:JSON!
    
    /// 广告
    var bannerGroupView = UIView()
    
    /// 0元抓的弹窗
    var zeroCatchSuccessDialog:ZeroCatchSuccessDialog!
    
    /// 红包
    var redBagNumber = UILabel()
    
    var redBagDialog = RedBagDialog.init(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if deviceId == "" {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        initView()
        
        initGameRoomData()
        
        self.playBackgroundMusic() //播放背景音乐
        
        playingGameDialog = PlayingGameDialog(frame: UIScreen.main.bounds)
    }
    
    /// 初始化游戏房间数据
    func initGameRoomData() {
        ToastUtils.showLoadingToast(msg: "请稍后……")
        var params = NetWorkUtils.createBaseParams()
        params["deviceids"] = deviceId
        
        Alamofire.request(Constants.Network.REFRESH_LIST_STATUS, method: .post, parameters: params).responseJSON { (dataResponse) in
            ToastUtils.hide()
            if NetWorkUtils.checkReponse(response: dataResponse) {
                let json = JSON(data: dataResponse.data!)
                if json["data"]["content"].arrayValue.count != 0 {
                    self.gameRoomData = json["data"]["content"].arrayValue[0]
                    
                    self.updateViewData()
                }else{
                    ToastUtils.showLoadingToast(msg: "发生异常")
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                ToastUtils.showLoadingToast(msg: "发生异常")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    /// 初始化view
    func initView() {
        rootView.frame = CGRect(x: 0, y: CGFloat(-statusHeight), width: screenWidth, height: screenHeight + CGFloat(statusHeight))
        rootView.backgroundColor = UIColor.init(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        view.addSubview(rootView)
        
        rootView.showsVerticalScrollIndicator = false
        rootView.showsHorizontalScrollIndicator = false
        
        /// 初始化直播的view
        initLiveView()
        
        /// 初始化游戏操作界面
        initGameControllerUI()
    }
    
    /// 更新一下页面上面的数据
    func updateViewData() {
        print("gemd:\(gameRoomData)")
        productNameLabel.text = gameRoomData["award"]["title"].stringValue
        productInfoLabel.text = gameRoomData["award"]["description"].stringValue
        productImage.kf.setImage(with: URL.init(string: gameRoomData["award"]["img"].stringValue))
        
        startGameNumberLabel.text = gameRoomData["perDiamondsCount"].stringValue + "币/次"
        
        if gameRoomData["activity"]["advertiseImg"].stringValue != "" {
            createBannerView()
        }
        
        createBottomGroupView()
        
//        showZeroCatchSuccessDialog()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if bgMusicPlayer != nil {
            bgMusicPlayer.stop()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /// 隐藏自带的navigationBar
        self.navigationController?.isNavigationBarHidden = true
        
        gameFailDialog = GameFailDialog(frame: UIScreen.main.bounds)
        gameVictoryDialog = GameVictoryDialog(frame: UIScreen.main.bounds)
        queuedUpDialog = GameQueuedUpDialog(frame: UIScreen.main.bounds)
        
        self.updateGoldNumberView()
        if gameRoomNetworkController != nil {
            gameRoomNetworkController.disconnect()
            gameRoomNetworkController = nil
        }
        
        gameRoomNetworkController = GameRoomNetworkController.init(grvc: self, deviceId: deviceId)
        gameRoomNetworkController.connectSocket()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
    }

    /// 游戏倒计时
    var countdownTimer: Timer?
    
    fileprivate var remainingSeconds: Int = 0 {
        willSet {
            if newValue < 10 {
                gameTimerLabel.text = "0:0\(newValue)"
            }else {
                gameTimerLabel.text = "0:\(newValue)"
            }
            
            if newValue <= 0 {
                gameTimerLabel.text = "0:30"
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
    
    @objc func updateTime() {
        remainingSeconds -= 1
    }
    
    deinit {
        print("GameSceneDeinit")
    }
    
    /// 显示0元抓抓中了的弹窗
    func showZeroCatchSuccessDialog() {
        if gameRoomData == nil {
            return
        }
        if zeroCatchSuccessDialog == nil {
            zeroCatchSuccessDialog = ZeroCatchSuccessDialog(frame: UIScreen.main.bounds)
        }
        zeroCatchSuccessDialog.dataSources = gameRoomData["award"]
        zeroCatchSuccessDialog.createView()
        zeroCatchSuccessDialog.show()
    }
    
}




















