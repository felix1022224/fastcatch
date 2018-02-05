//
//  GameRoomNetworkController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/23.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON

class GameRoomNetworkController: NSObject {
    
    /// 房间号
    private var deviceId:String = ""
    
    /// socket 连接
    var socket:SocketIOClient!
    
    /// 是否加入过队列
    var isEnterQueue = false
    
    var gameRoomVC : GameRoomViewController!
    
    init(grvc:GameRoomViewController, deviceId:String) {
        self.gameRoomVC = grvc
        self.deviceId = deviceId
        
        if Constants.Network.nService == Constants.Network.MZService.Debug {
            //测试服务器 "http://47.92.72.158:9130?room=" + deviceId + "&id=" + Constants.User.ID
            let url = URL(string: "http://47.92.72.158:9130?room=" + deviceId + "&id=" + Constants.User.ID)!
            socket = SocketIOClient(socketURL: url, config: [.log(false), .compress])
        }else if Constants.Network.nService == Constants.Network.MZService.Test {
            //本地测试服务器
            socket = SocketIOClient(socketURL: URL(string: "http://192.168.2.174:9130?room=" + deviceId + "&id=" + Constants.User.ID)!, config: [.log(false), .compress])
        }else if Constants.Network.nService == Constants.Network.MZService.Release {
            print("link:\("http://101.201.68.47:9130?room=" + deviceId + "&id=" + Constants.User.ID)")
            ///线上正式
            socket = SocketIOClient(socketURL: URL(string: "http://101.201.68.47:9130?room=" + deviceId + "&id=" + Constants.User.ID)!, config: [.log(false), .compress])
        }
    }
    
    func connectSocket() -> () {
        /// 连接成功
        socket.on(clientEvent: SocketClientEvent.connect) { [weak self] (data, ack) in
            print("连接socket")
            self?.onConnectSuccess(data: data, ack: ack)
        }
        
        /// 等待排队
        socket.on("waitqueue") { [weak self] (data, ack) in
            self?.waitQueue(data: data)
        }
        
        /// 更新游戏人数
        socket.on("updateGameNumber") { [weak self] (data, ack) in
            self?.updateGameNumber(data: data, ack: ack)
        }
        
        /// 更新游戏次数
        socket.on("awardCount") { [weak self] (data, ack) in
            self?.updateAwardNumber(data: data)
        }
        
        /// 加入房间的回调监听
        socket.on("enterSuccess") { [weak self] (data, ack) in
            self?.enterRoomSuccess()
        }
        
        /// 设备维护
        socket.on("maintain") { [weak self] (data, ack) in
//            ToastUtils.showErrorToast(msg: "维护中，请稍后")
            self?.gameRoomVC.navigationController?.popViewController(animated: true)
        }
        
        /// 刷新正在游戏中的玩家信息
        socket.on("gameUserInfo") { [weak self] (data, ack) in
            self?.updateGameUser(data: data)
        }
        
        /// 监听用户重复登录的情况
        self.socket.on("repeatLogin") { [weak self] (data, ack) in
            self?.repeatLogin()
        }
        
        /// 登录成功
        socket.on("loginSuccess", callback: { [weak self] (data, ack) in
            self?.loginSuccess()
        })
        
        socket.connect()
    }
    
    /// 连接成功
    func onConnectSuccess(data:[Any], ack:SocketAckEmitter) -> () {
        print("connect success")
        
        /// 加入房间
        var params = [String :Any]()
        params["deviceid"] = self.deviceId
        params["state"] = "1"
        
        socket.emit("room", params)
    }
    
    /// 关闭连接
    func disconnect() -> () {
        print("离开房间")
        
        self.socket.disconnect()
    }
    
    /// 加入房间成功
    func enterRoomSuccess() -> () {
        print("加入房间成功")
        
        if Constants.User.ID != "" {
            print("id:\(Constants.User.ID)")
            
            //登录
            socket.emit("login", Constants.User.ID)
        }
    }
    
    /// 登录成功
    func loginSuccess() -> () {
        print("登录成功")
    }
    
    /// 有另外一台设备登录，强制用户下线
    func repeatLogin() -> () {
        print("被踢下线")
//        self.playViewController?.isGameing = false
//        self.playViewController?.needLogin?()
//        self.playViewController?.backBtnClick()
        
    }
    
    /// 更新人数
    func updateGameNumber(data:[Any], ack:SocketAckEmitter) -> () {
        let resultData = JSON(data[0])
        print("更新人数")
        self.gameRoomVC.updateGameRoomNumbers(watchNumberStr: String(resultData["waitWatchCount"].intValue) + "人", queueNumberStr: String(resultData["waitCtlCount"].intValue) + "人")
        self.gameRoomVC.updateGameNumber(gameNumberStr: "共\(resultData["awardDrawCount"].intValue)次")
    }
    
    /// 更新抓取次数
    func updateAwardNumber(data:[Any]) -> () {
        let resultData = JSON(data[0])
        self.gameRoomVC.updateGameNumber(gameNumberStr: "共\(resultData["awardDrawCount"].intValue)次")
    }
    
    /// 移动手臂
    func controllerPath(path:String, status:String) -> () {
        var params = [String: Any]()
        params["deviceid"] = deviceId
        params["direction"] = path
        params["status"] = status
        
        socket.emit("directionctl", params)
    }
    
    /// 下爪
    func controllerGrap() -> () {
        var params = [String: Any]()
        params["deviceid"] = deviceId
        
        socket.emit("catchpress", params)
        gameRoomVC.disableControllerBtns(isEnbled: false)
        
        /// 延时两秒钟后获取中奖数据
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {[weak self] in
            self?.gameRoomVC.isCounting = false
            self?.gameRoomVC?.getWard()
        }
    }
    
    /// 加入游戏排队队列
    func enterGameQueue() -> () {
        var params = [String: Any]()
        params["deviceid"] = deviceId
        
        print("加入队列")
        
        /// 加入队列
        socket.emit("waitqueue", params)
    }
    
    /// 等待排队
    func waitQueue(data:[Any]) -> () {
        let json = JSON(data[0])
        print("jsonjsonjson\(json)")
        if json["tryLock"].bool! == true {
            /// 可以开始游戏
            if isEnterQueue {
                /// 进入过队列，显示排队排到了的界面
                self.gameRoomVC.showQueuedDialog()
            }else{
                /// 没进入过队列，直接开始游戏
                self.gameRoomVC.startGame()
            }
            isEnterQueue = false
        }else{
            /// 进入排队状态
            isEnterQueue = true
            
            self.gameRoomVC.updateQueueNumber(number: json["waitCtlIndex"].intValue)
            self.gameRoomVC.switchQueueStatus(isQueue: true)
        }
    }
    
    /// 退出队列
    func quitQueue(isShowToast:Bool) -> () {
        /// 退出队列
        var params = [String: Any]()
        params["deviceid"] = self.deviceId
        socket.emit("quitqueue", params)
        
        isEnterQueue = false
        
        if isShowToast {
            ToastUtils.showInfoToast(msg: "成功退出队列，5秒钟后才可再次预约哦")
        }
    }
    
    func updateGameUser(data:[Any]) -> () {
        let resultJson = JSON(data[0])
        if resultJson["id"].intValue != 0 {
            self.gameRoomVC.gameUserDataSource = resultJson
            self.gameRoomVC.updateGameUserInfo(userName: resultJson["nick"].stringValue, userAvater: resultJson["avatar"].stringValue)
        }else{
            self.gameRoomVC.hideGameUserView()
        }
    }
    
}
