//
//  HorizontalGameSceneViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/11/30.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import AVFoundation

/// 横屏模式下的游戏界面
class HorizontalGameSceneViewController: UIViewController {

    let appleDelegate = UIApplication.shared.delegate as? AppDelegate
    
    /// 直播的view
    var liveView = UIView()
    
    /// 直播view的集合
    var liveGroupView = UIView()
    
    // 当前设备ID
    var deviceId:String = ""
    
    /// 1是正面 2是侧面
    var nowCamareDirection = 1
    
    /// 直播kit
    weak var agoraKit: AgoraRtcEngineKit!
    
    lazy var lensBtn = UIButton(type: UIButtonType.custom)
    
    /// 音频按钮
    var audioBtn:UIButton!
    
    /// 是否关掉了声音
    var isCloseMusic:Bool = false
    
    /// 播放声音
    
    var bgMusicPlayer:AVAudioPlayer!
    
    /// 播放音效
    var soundEffect:AVAudioPlayer!
    
    /// 下爪按钮
    lazy var grabBtn = UIButton()
    
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
    lazy var isGrab:Bool = false
    
    /// 是否正在操作
    lazy var isControoler:Bool = false
    
    /// 是否杜蕾斯风格的样式
    var isDurexTheme = true
    
    /// 游戏页面
    var gameSceneVC:GameSceneViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        UIApplication.shared.isIdleTimerDisabled = true //禁止息屏
        
        appleDelegate?.allowRotation = 1 //设置支持横屏
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;   //禁用侧滑手势
        
        setupUI()
        
        playBackgroundMusic()
        
        /// 开始倒计时
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {[weak self] in
            self?.countdownTimer?.invalidate()
            self?.countdownTimer = nil
            
            self?.isCounting = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("value:\(UIInterfaceOrientation.portrait.rawValue)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        appleDelegate?.allowRotation = 0 //恢复竖屏

        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    /// 游戏倒计时
    var countdownTimer: Timer?
    
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
    
    @objc func updateTime() {
        remainingSeconds -= 1
    }

}
