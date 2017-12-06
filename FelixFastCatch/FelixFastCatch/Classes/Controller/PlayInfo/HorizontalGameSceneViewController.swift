//
//  HorizontalGameSceneViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/11/30.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
        
        UIApplication.shared.isIdleTimerDisabled = true //禁止息屏
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;   //禁用侧滑手势
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appleDelegate?.allowRotation = 1 //设置支持横屏
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appleDelegate?.allowRotation = 0 //恢复竖屏
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        UIApplication.shared.isIdleTimerDisabled = false
    }

}
