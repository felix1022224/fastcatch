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
    
    /// socket io
    let socket = SocketIOClient(socketURL: URL(string: "http://101.201.68.47:9130")!, config: [.log(false), .compress])
    
    init(playViewController:PlayViewController, deviceId:String) {
        self.playViewController = playViewController
        self.deviceId = deviceId
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
        
        var params = [String :Any]()
        params["deviceid"] = self.deviceId
        params["state"] = "1"
        
        socket.on("enterSuccess") { [weak self] (data, ack) in
            self?.enterRoomSuccess()
        }
        
        socket.emit("room", params)
    }
    
    /// 关闭连接
    func disconnect() -> () {
        print("离开房间")
        /// 离开房间
        var params = [String :Any]()
        params["deviceid"] = self.deviceId
        params["state"] = "0"
        
        socket.emit("room", params)
        
        socket.disconnect()
    }
        
}

extension GameSceneController{
    
    /// 加入房间成功
    func enterRoomSuccess() -> () {
        print("加入房间成功")
        ToastUtils.hide()
        
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
        print("data:\(data)")
        print("ack:\(ack)")
        
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
        print("award:\(data)")
        
        let resultData = JSON(data[0])
        self.playViewController?.darwCountLabel.text = "游戏" + String(resultData["awardDrawCount"].intValue) + "次   抓中" + String(resultData["awardWinningCount"].intValue) + "次"
        self.playViewController?.updateAwardUI()
    }
    
}

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














