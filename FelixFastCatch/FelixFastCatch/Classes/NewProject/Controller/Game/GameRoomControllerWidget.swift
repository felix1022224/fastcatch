//
//  GameRoomControllerWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/22.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// 操作界面的一些控件
extension GameRoomViewController {
    
    /// 初始化游戏操作界面的UI
    func initGameControllerUI() {
        gameControllerGroupView.frame = CGRect(x: 0, y: liveView.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.6 - liveView.bounds.height * 0.15)
        rootView.addSubview(gameControllerGroupView)
        
        startGameBtn.setBackgroundImage(UIImage.init(named: "开始游戏啦"), for: UIControlState.normal)
        startGameBtn.setBackgroundImage(UIImage.init(named: "开始游戏啦不可点击"), for: UIControlState.disabled)
        startGameBtn.sizeToFit()
        startGameBtn.frame.origin = CGPoint(x: UIScreen.main.bounds.width/2 - startGameBtn.bounds.width/2, y: gameControllerGroupView.bounds.height/2 - startGameBtn.bounds.height/2)
        gameControllerGroupView.addSubview(startGameBtn)
        
        startGameNumberLabel.text = "0币/次"
        startGameNumberLabel.font = UIFont.systemFont(ofSize: 12)
        startGameNumberLabel.textColor = UIColor.white
        startGameNumberLabel.frame = CGRect.init(x: startGameBtn.frame.origin.x + startGameBtn.bounds.width * 0.15, y: startGameBtn.frame.origin.y + startGameBtn.bounds.height * 0.55, width: startGameBtn.bounds.width * 0.6, height: 20)
        gameControllerGroupView.addSubview(startGameNumberLabel)
        
        startGameBtn.addTarget(self, action: #selector(clickStatrBtn), for: UIControlEvents.touchUpInside)
        
        queueCancelBtn.setBackgroundImage(UIImage.init(named: "游戏界面取消排队"), for: UIControlState.normal)
        queueCancelBtn.sizeToFit()
        gameControllerGroupView.addSubview(queueCancelBtn)
        
        queueCancelBtn.frame.origin = CGPoint(x: UIScreen.main.bounds.width/2 - queueCancelBtn.bounds.width/2, y: gameControllerGroupView.bounds.height/2 - queueCancelBtn.bounds.height/2)
        
        queueIndexLabel.frame = CGRect.init(x: queueCancelBtn.frame.origin.x + queueCancelBtn.bounds.width * 0.15, y: queueCancelBtn.frame.origin.y + queueCancelBtn.bounds.height * 0.55, width: queueCancelBtn.bounds.width * 0.6, height: 20)
        queueIndexLabel.textColor = UIColor.init(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        queueIndexLabel.font = UIFont.systemFont(ofSize: 12)
        gameControllerGroupView.addSubview(queueIndexLabel)
        
        let attrText = NSMutableAttributedString.init(string: "您是第 \(6) 位哦")
        attrText.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold), range: NSRange(location: 4, length:1))
        attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location: 4, length:1))
        queueIndexLabel.attributedText = attrText
        
        queueCancelBtn.addTarget(self, action: #selector(cancelQueue), for: UIControlEvents.touchUpInside)
        
        switchQueueStatus(isQueue: false)
        
        createOperationPanel()
    }
    
    /// 取消排队
    @objc func cancelQueue() {
        switchQueueStatus(isQueue: false)
        gameRoomNetworkController.quitQueue(isShowToast: true)
    }
    
    func switchQueueStatus(isQueue:Bool) {
        if isQueue {
            queueCancelBtn.isHidden = false
            queueIndexLabel.isHidden = false
        }else{
            queueCancelBtn.isHidden = true
            queueIndexLabel.isHidden = true
        }
    }
    
    func updateQueueNumber(number:Int) {
        let attrText = NSMutableAttributedString.init(string: "您是第 \(number) 位哦")
        attrText.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold), range: NSRange(location: 4, length:String(number).count))
        attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location: 4, length:String(number).count))
        queueIndexLabel.attributedText = attrText
    }
    
    @objc func clickStatrBtn() {
        startGameClick(isAgain: false)
    }
    
    func startGameClick(isAgain:Bool) {
        if Constants.User.USER_ID == "" {
            /// 需要登录
            LoginViewController.showLoginVC()
            return
        }
        
        if Constants.User.diamondsCount < gameRoomData["perDiamondsCount"].intValue  {
            /// 代币不足，请充值
            ToastUtils.showErrorToast(msg: "代币不足，请充值")
            return
        }
        
        if isStartClick {
            return
        }
        isStartClick = true
        
        self.wardCode = ""
        
        if isAgain {
            startGame()
        }else{
            if gameRoomNetworkController != nil {
                gameRoomNetworkController.enterGameQueue()
            }
        }
        
        startGameBtn.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            if self.isStartClick != false {
                self.isStartClick = false
                self.startGameBtn.isEnabled = true
            }
        }
    }
    
    /// 开始游戏，进行扣币等操作
    func startGame() {
        self.startGameBtn.isEnabled = true
        
        print("开始游戏")
        var params = NetWorkUtils.createBaseParams()
        params["deviceid"] = deviceId
        
        Alamofire.request(Constants.Network.Machine.START_PLAY, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                print("开始游戏回调:\(String(describing: response.result.value))")
                let json = JSON(response.result.value!)
                if json["data"]["errcode"].intValue == 0 {
                    self.switchGameStatus(isGame: true)
                    self.wardCode = json["data"]["gTradeNo"].stringValue
                    /// 播放音效
                    self.playStartGame()
                    
                    Constants.User.diamondsCount = json["data"]["diamondsCount"].intValue
                    self.updateGoldNumberView()
                    
                }else {
                    self.switchGameStatus(isGame: false)
                }
            }
            self.isStartClick = false
        }
    }
    
    /// 创建操作面板
    func createOperationPanel() {
        /// 上
        controllerUp = CustomerControllerButton(frame: CGRect.zero, controllerDown: { [weak self] (button)  in
            self?.controllerPathDown(sender: button)
            }, controllerUp: { [weak self] (button) in
                self?.controllerPathUp(sender: button)
            }, controllerMove:{[weak self] (button) in
                self?.controllerMove(sender: button)
        })
        controllerUp.setImage(UIImage(named: "上操作按钮"), for: .normal)
        controllerUp.setImage(UIImage(named: "上按钮不可点击"), for: .disabled)
        controllerUp.sizeToFit()
        gameControllerGroupView.addSubview(controllerUp)
        
        /// 下
        controllerDown = CustomerControllerButton(frame: CGRect.zero, controllerDown: { [weak self] (button)  in
            self?.controllerPathDown(sender: button)
            }, controllerUp: { [weak self] (button) in
                self?.controllerPathUp(sender: button)
            }, controllerMove:{[weak self] (button) in
                self?.controllerMove(sender: button)
        })
        controllerDown.setImage(UIImage(named: "下操作按钮"), for: .normal)
        controllerDown.setImage(UIImage(named: "下按钮不可点击"), for: .disabled)
        controllerDown.sizeToFit()
        gameControllerGroupView.addSubview(controllerDown)
        
        /// 左
        controllerLeft = CustomerControllerButton(frame: CGRect.zero, controllerDown: { [weak self] (button)  in
            self?.controllerPathDown(sender: button)
            }, controllerUp: { [weak self] (button) in
                self?.controllerPathUp(sender: button)
            }, controllerMove:{[weak self] (button) in
                self?.controllerMove(sender: button)
        })
        controllerLeft.setImage(UIImage(named: "左操作按钮"), for: .normal)
        controllerLeft.setImage(UIImage(named: "左按钮不可点击"), for: .disabled)
        controllerLeft.sizeToFit()
        gameControllerGroupView.addSubview(controllerLeft)
        
        /// 右
        controllerRight = CustomerControllerButton(frame: CGRect.zero, controllerDown: { [weak self] (button)  in
            self?.controllerPathDown(sender: button)
            }, controllerUp: { [weak self] (button) in
                self?.controllerPathUp(sender: button)
            }, controllerMove:{[weak self] (button) in
                self?.controllerMove(sender: button)
        })
        controllerRight.setImage(UIImage(named: "右操作按钮"), for: .normal)
        controllerRight.setImage(UIImage(named: "右按钮不可点击"), for: .disabled)
        controllerRight.sizeToFit()
        gameControllerGroupView.addSubview(controllerRight)
        
        controllerUp.frame.origin = CGPoint(x: controllerLeft.bounds.width + 5, y: 15)
        controllerDown.frame.origin = CGPoint(x: controllerDown.bounds.width + 5, y: 15 + controllerUp.bounds.height)
        controllerLeft.frame.origin = CGPoint(x: 20, y: 15 + controllerUp.bounds.height/2)
        controllerRight.frame.origin = CGPoint(x: controllerDown.bounds.width * 1.8 + 5, y: 15 + controllerUp.bounds.height/2)
        
        /// 下爪
        grabBtn.setImage(UIImage(named: "抓娃娃"), for: .normal)
        grabBtn.setImage(UIImage(named: "抓娃娃按钮不可点击"), for: .highlighted)
        grabBtn.sizeToFit()
        gameControllerGroupView.addSubview(grabBtn)
        
        grabBtn.frame = CGRect.init(x: UIScreen.main.bounds.width - 20 - grabBtn.bounds.width, y: controllerLeft.frame.origin.y + controllerLeft.bounds.height/2 - grabBtn.bounds.height/2, width: grabBtn.bounds.width, height: grabBtn.bounds.height)
        
        grabBtn.addTarget(self, action: #selector(controllerGrap), for: UIControlEvents.touchUpInside)
        
        gameTimerLabel.font = UIFont.systemFont(ofSize: 14)
        gameTimerLabel.textColor = UIColor.white
        gameTimerLabel.text = "0:30"
        gameTimerLabel.sizeToFit()
        gameControllerGroupView.addSubview(gameTimerLabel)
        
        gameTimerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(grabBtn).offset(grabBtn.bounds.height)
            make.centerX.equalTo(grabBtn)
        }
        
        switchGameStatus(isGame: false)
    }
    
    func switchGameStatus(isGame:Bool) {
        if isGame {
            disableControllerBtns(isEnbled: true)
            
            /// 游戏中
            controllerUp.isHidden = false
            controllerDown.isHidden = false
            controllerLeft.isHidden = false
            controllerRight.isHidden = false
            grabBtn.isHidden = false
            
            startGameBtn.isHidden = true
            startGameNumberLabel.isHidden = true
            
            /// 开始倒计时
            isCounting = true
            
            gameTimerLabel.isHidden = false
            
            isGameing = true
            
            /// 切换到游戏模式
            self.switchGameMode()
        }else{
            disableControllerBtns(isEnbled: false)
            
            /// 非游戏中
            controllerUp.isHidden = true
            controllerDown.isHidden = true
            controllerLeft.isHidden = true
            controllerRight.isHidden = true
            grabBtn.isHidden = true
            
            startGameBtn.isHidden = false
            startGameNumberLabel.isHidden = false
            
            /// 结束倒计时
            isCounting = false
            
            gameTimerLabel.isHidden = true
            
            isStartClick = false
            
            isGameing = false
            
            /// 切换到非游戏模式
            self.switchNotGameMode()
            
            startGameBtn.isEnabled = true
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
        gameRoomNetworkController.controllerPath(path: path, status: status)
    }
    
    /// 下爪
    @objc func controllerGrap() -> () {
        isGrab = true
        gameRoomNetworkController.controllerGrap()
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
        if self.wardCode == "" {
            self.switchGameStatus(isGame: false)
            ToastUtils.hide()
            return
        }
        
        if getWardCodeNumber == 3 {
            ToastUtils.showLoadingToast(msg: "等待游戏结果")
        }
        
        /// 调用接口超过8次，默认失败
        if getWardCodeNumber >= 6 {
            getWardCodeNumber = 0
            self.switchGameStatus(isGame: false)
            /// 隐藏loading
            ToastUtils.hide()
            
            /// 弹出失败的弹窗
            showGameFailDialog()
            
            /// 抓取失败的音效
            playGrapFail()
            return
        }
        
        var params = NetWorkUtils.createBaseParams()
        params["gtradeno"] = wardCode
        
        Alamofire.request(Constants.Network.Machine.GET_WARD, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(response.result.value!)
                if json["data"]["drawable"].bool! == true {
                    /// 隐藏loading
                    ToastUtils.hide()
                    
                    self.getWardCodeNumber = 0
                    /// 显示再来一局的界面
                    self.showGameVictoryDialog()
                    
                    /// 抓取成功的音效
                    self.playGrapSuccess()
                }else{
                    /// 抓取失败
                    self.getWardCodeNumber = self.getWardCodeNumber + 1
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: { [weak self] in
                        self?.getWard()
                    })
                }
            }else{
                /// 异常，也认为抓取失败
                self.getWardCodeNumber = self.getWardCodeNumber + 1
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: { [weak self] in
                    self?.getWard()
                })
            }
        }
    }
    
    /// 显示失败的弹窗
    func showGameFailDialog() {
        /// 修改下爪状态
        isGrab = false
        
        gameFailDialog.createView()
        gameFailDialog.cancelCallback = {
            /// 退出队列
            self.gameRoomNetworkController.quitQueue(isShowToast: false)
            
            /// 切换到非游戏模式
            self.switchGameStatus(isGame: false)
        }
        gameVictoryDialog.againCallback = {
            self.startGameClick(isAgain: true)
        }
        gameFailDialog.show()
    }
    
    /// 显示游戏胜利的弹窗
    func showGameVictoryDialog() {
        /// 修改下爪状态
        isGrab = false
        
        if gameVictoryDialog == nil {
            gameVictoryDialog = GameVictoryDialog(frame: UIScreen.main.bounds)
        }
        
        gameVictoryDialog.createView()
        gameVictoryDialog.cancenCallback = {
            /// 退出队列
            self.gameRoomNetworkController.quitQueue(isShowToast: false)
            
            /// 切换到非游戏模式
            self.switchGameStatus(isGame: false)
        }
        gameVictoryDialog.againCallback = {
            self.startGameClick(isAgain: true)
        }
        gameVictoryDialog.welfareCallback = {
            /// 退出队列
            self.gameRoomNetworkController.quitQueue(isShowToast: false)
            
            /// 切换到非游戏模式
            self.switchGameStatus(isGame: false)
            
            self.sendWelfare()
        }
        gameVictoryDialog.show()
    }
    
    /// 显示排队到了弹窗
    func showQueuedDialog() {
        /// 退出排队状态
        switchQueueStatus(isQueue: false)
        
        startGameBtn.isEnabled = false
        
        queuedUpDialog.createView()
        queuedUpDialog.cancelCallback = {
            /// 退出队列
            self.gameRoomNetworkController.quitQueue(isShowToast: true)
            
            /// 切换到非游戏模式
            self.switchGameStatus(isGame: false)
            
            self.startGameBtn.isEnabled = true
        }
        queuedUpDialog.startGameCallback = {
            /// 开始游戏
            self.startGame()
        }
        queuedUpDialog.show()
    }
    
    /// 发红包
    func sendWelfare() {
        ToastUtils.showLoadingToast(msg: "正在准备红包")
        var params = NetWorkUtils.createBaseParams()
//        params["gTradeNo"] = wardCode
        params["gTradeNo"] = "503381701554561"
        
        Alamofire.request(Constants.Network.User.SEND_RED_BAG, method: HTTPMethod.post, parameters: params).responseJSON { (dataResponse) in
            ToastUtils.hide()
            if NetWorkUtils.checkReponse(response: dataResponse) {
                let resultJson = JSON.init(data: dataResponse.data!)
                print("resultJson:\(resultJson)")
                
//                let shareDialog = SharedViewDialog()
//                shareDialog.createView()
//                shareDialog.show()
            }
        }
    }
    
}
