//
//  TencentShared.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/24.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

typealias TencentShared_loginFailedhandle = (_ error: String) -> Void
typealias TencentShared_loginSuccessHandle = (_ info: [String: Any]) -> Void
typealias TencentShared_resultHandle = (_ isSuccess: Bool, _ description: String) -> Void
class TencentShared: NSObject {

    static var shared:TencentShared = TencentShared()
    
    fileprivate var appID: String = ""
    fileprivate var appKey: String = ""
    fileprivate var accessToken: String = ""
    
    fileprivate var tencentAuth: TencentOAuth!
    
    fileprivate var loginSuccess: TencentShared_loginSuccessHandle? = nil
    fileprivate var loginFailsure: TencentShared_loginFailedhandle? = nil
    fileprivate var shareResult: TencentShared_resultHandle? = nil
    
    private override init() { }
    
    /// 是否安装QQ客户端
    ///
    /// - Returns: true: 安装; false: 未安装
    class func isQQInstall() -> Bool {
        
        return TencentOAuth.iphoneQQInstalled()
    }

    class func registeApp(_ appID: String, appKey: String) {
        TencentShared.shared.appID = appID
        TencentShared.shared.appKey = appKey
        TencentShared.shared.tencentAuth = TencentOAuth(appId: appID, andDelegate: TencentShared.shared)
    }
    
    class func handle(_ url: URL) -> Bool {
        
        // host: qzapp ; schem: tencent1105013800
        // response_from_qq    tencent1105013800
        
        if url.host == "qzapp" {
            // QQ授权登录
            return TencentOAuth.handleOpen(url)
        } else if url.host == "response_from_qq" {
            // QQ 分享
            return QQApiInterface.handleOpen(url, delegate: TencentShared.shared)
        }
        
        return  true
    }
    
    class func login(_ success: TencentShared_loginSuccessHandle? = nil, failsure: TencentShared_loginFailedhandle? = nil) {
        
        // 需要获取的用户信息
        let permissions = [kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
        TencentShared.shared.tencentAuth.authorize(permissions)
        
        TencentShared.shared.loginSuccess = success
        TencentShared.shared.loginFailsure = failsure
    }
    
}

//    MARK: - QQApiInterfaceDelegate
extension TencentShared: QQApiInterfaceDelegate {
    
    func onReq(_ req: QQBaseReq!) {
        
    }
    
    func onResp(_ resp: QQBaseResp!) {
        
        if resp is SendMessageToQQResp {
            let rs = resp as! SendMessageToQQResp
            if rs.type == 2 {
                // QQ分享返回的回调
                if rs.result == "0" {
                    // 分享成功
                    if let rs = self.shareResult {
                        rs(true, "分享成功")
                    }
                } else if rs.result == "-4" {
                    
                    if let rs = self.shareResult {
                        rs(false, "取消分享")
                    }
                } else {
                    
                    if let rs = self.shareResult {
                        rs(false, "分享失败")
                    }
                }
            }
        }
    }
    
    func isOnlineResponse(_ response: [AnyHashable : Any]!) {
        
    }
}

extension TencentShared:TencentSessionDelegate{

    func tencentDidLogin() {
        
        self.tencentAuth.getUserInfo()
        if let accessToken = self.tencentAuth.accessToken {
            // 获取accessToken
            self.accessToken = accessToken
        }
    }
    
    func tencentDidNotNetWork() {
        if let closure = self.loginFailsure {
            closure("网络异常")
        }
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        
        if cancelled {
            // 用户取消登录
            if let closure = self.loginFailsure {
                closure("用户取消登录")
            }
        } else {
            // 登录失败
            if let closure = self.loginFailsure {
                closure("登录失败")
            }
        }
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        
        let queue = DispatchQueue(label: "aaLoginQueue")
        queue.async {
            
            if response.retCode == 0 {
                
                if let res = response.jsonResponse {
                    
                    var info: [String: Any] = [:]
                    
                    info["rawData"] = res as? Dictionary<String, Any>
                    
                    if let uid = self.tencentAuth.getUserOpenID() {
                        info["uid"] = uid
                    }
                    
                    if let name = res["nickname"] as? String {
                        info["nickName"] = name
                    }
                    
                    if let sex = res["gender"] as? String {
                        info["sex"] = sex
                    }
                    
                    if let img = res["figureurl_qq_2"] as? String {
                        info["advatarStr"] = img
                    }
                    
                    DispatchQueue.main.async {
                        if let closure = self.loginSuccess {
                            
                            closure(info)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if let closure = self.loginFailsure {
                        closure("获取授权信息异常")
                    }
                }
            }
        }
    }
    
}
