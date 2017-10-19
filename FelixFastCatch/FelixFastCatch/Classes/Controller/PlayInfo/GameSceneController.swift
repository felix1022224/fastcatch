//
//  GameSceneController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/9/26.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON

class GameSceneController: NSObject {

    /// 游戏房间的viewcontroller
    private var playViewController:PlayViewController?
    
    /// 房间号
    private var deviceId:String = ""
    
    /// socket 连接
    var socket:SocketIOClient!
    
    init(playViewController:PlayViewController, deviceId:String) {
        self.playViewController = playViewController
        self.deviceId = deviceId
        // 中间测试
//        socket = SocketIOClient(socketURL: URL(string: "http://47.92.72.158:9130?room=" + deviceId)!, config: [.log(false), .compress])
        // 本地测试
//        socket = SocketIOClient(socketURL: URL(string: "http://192.168.1.162:9130?room=" + deviceId)!, config: [.log(false), .compress])
        // 线上正式
        socket = SocketIOClient(socketURL: URL(string: "http://101.201.68.47:9130?room=" + deviceId)!, config: [.log(false), .compress])
    }
    
}

/// 系统连接
extension GameSceneController{
    
    func connectSocket() -> () {
        /// 连接成功
        socket.on(clientEvent: SocketClientEvent.connect) { [weak self] (data, ack) in
            self?.onConnectSuccess(data: data, ack: ack)
        }
        socket.reconnects = true
        socket.connect()
    }
    
    /// 连接成功
    func onConnectSuccess(data:[Any], ack:SocketAckEmitter) -> () {
        print("connect success")
        ToastUtils.showLoadingToast(msg: "加入房间中")
        
        socket.on("updateGameNumber") { [weak self] (data, ack) in
            self?.updateGameNumber(data: data, ack: ack)
        }
        
        socket.on("awardCount") { [weak self] (data, ack) in
            self?.updateAwardNumber(data: data)
        }
        
        /// 加入房间
        var params = [String :Any]()
        params["deviceid"] = self.deviceId
        params["state"] = "1"
        
        /// 加入房间的回调监听
        socket.on("enterSuccess") { [weak self] (data, ack) in
            self?.enterRoomSuccess()
        }
        
        socket.emit("room", params)
    }
    
    /// 关闭连接
    func disconnect() -> () {
        print("离开房间")
        
//        /// 离开房间
//        var params = [String :Any]()
//        params["deviceid"] = self.deviceId
//        params["state"] = "0"
//
//        socket.emit("room", params)
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
//            print("断开连接")
//
//        }
        self.socket.disconnect()
    }
        
}

extension GameSceneController{
    
    /// 加入房间成功
    func enterRoomSuccess() -> () {
        print("加入房间成功")
        ToastUtils.hide()
        
        socket.on("maintain") { [weak self] (data, ack) in
            ToastUtils.showErrorToast(msg: "维护中，请稍后")
            self?.playViewController?.backBtnClick()
        }
        
        socket.on("gameUserInfo") { [weak self] (data, ack) in
            self?.updateGameUser(data: data)
        }
        
        if Constants.User.ID != "" {
            socket.on("loginSuccess", callback: { [weak self] (data, ack) in
                self?.loginSuccess()
            })
            
            print("id:\(Constants.User.ID)")
            
            //登录
            socket.emit("login", Constants.User.ID)
            
            /// 监听用户重复登录的情况
            self.socket.on("repeatLogin") { [weak self] (data, ack) in
                self?.repeatLogin()
            }
        }
    }
    
    /// 登录成功
    func loginSuccess() -> () {
        print("登录成功")
    }
    
    /// 有另外一台设备登录，强制用户下线
    func repeatLogin() -> () {
        print("被踢下线")
        self.playViewController?.isGameing = false
        self.playViewController?.needLogin?()
        self.playViewController?.backBtnClick()
    }
    
}

// MARK: - 游戏房间人数发生变化
extension GameSceneController{
    
    /// 更新人数
    func updateGameNumber(data:[Any], ack:SocketAckEmitter) -> () {
        print("updateGameNumber:\(data)")
        
        let resultData = JSON(data[0])
        if let watchNumber = resultData["waitWatchCount"].int {
            self.playViewController?.playNumber.text = String(watchNumber) + "人观看"
        }
        
        if let queue = resultData["waitCtlCount"].int {
            self.playViewController?.queueNumber.text = String(queue) + "人等待"
        }
    }
    
    /// 更新抓取次数
    func updateAwardNumber(data:[Any]) -> () {
        print("updateAwardNumber:\(data)")
        
        let resultData = JSON(data[0])
        self.playViewController?.darwCountLabel.text = "游戏" + String(resultData["awardDrawCount"].intValue) + "次"
        self.playViewController?.updateAwardUI()
    }
    
}

// MARK: - 游戏的相关
extension GameSceneController{
    
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
        self.playViewController?.hidePlayGroup()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {[weak self] in
            self?.playViewController?.getWard()
        }
        
    }
    
}

// MARK: - 排队相关
extension GameSceneController{
    
    /// 加入游戏排队队列
    func enterGameQueue() -> () {
        
        /// 等待排队
        socket.on("waitqueue") { [weak self] (data, ack) in
            self?.waitQueue(data: data)
        }
        
        var params = [String: Any]()
        params["deviceid"] = deviceId
        
        /// 加入队列
        socket.emit("waitqueue", params)
    }
    
    /// 等待排队
    func waitQueue(data:[Any]) -> () {
        let json = JSON(data[0])
        print("waitQueue:\(json["tryLock"].bool!)")
        if json["canGame"].boolValue == false {
            ToastUtils.showErrorToast(msg: "代币不足")
            return
        }
        if json["tryLock"].bool! == true {
            print("可以开始游戏了")
            // 可以开始游戏了
            self.playViewController?.startPlay()
            self.playViewController?.playQueueNumberStatus.isHidden = true
        }else{
            print("已经有\(String(describing: json["waitCtlCount"].intValue))人在游戏中，请等候,\(json)")
            
            self.playViewController?.startPlayBtn.isEnabled = false
            
            self.playViewController?.playQueueStausNumber.text = "预约第\(json["waitCtlIndex"].intValue)位"
            self.playViewController?.queueNumber.text = String(json["waitCtlCount"].intValue) + "人等待"
            
            self.playViewController?.playQueueNumberStatus.isHidden = false
        }
    }
    
    /// 退出队列
    func quitQueue() -> () {
        /// 退出队列
        var params = [String: Any]()
        params["deviceid"] = self.deviceId
        socket.emit("quitqueue", params)
    }
    
}

// MARK: - 游戏中的用户信息
extension GameSceneController{
    
    func updateGameUser(data:[Any]) -> () {
        let resultJson = JSON(data[0])
        print("updateGameUser\(data[0])")
        if resultJson["id"].intValue != 0 {
            self.playViewController?.gameUserInfo = resultJson
            self.playViewController?.updateGameUserInfoWidget(userFaceImage: resultJson["avatar"].stringValue, userNickName: resultJson["nick"].stringValue)
        }else{
            self.playViewController?.gameUserInfo = nil
            self.playViewController?.removeGameUserInfo()
        }
    }
    
}










