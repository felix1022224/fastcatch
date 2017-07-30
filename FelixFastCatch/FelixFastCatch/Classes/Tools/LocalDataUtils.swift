//
//  LocalDataUtils.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/28.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class LocalDataUtils: NSObject {

    
    /// 更新本地数据
    ///
    /// - Parameter resultData: 网络返回的用户数据
    class func updateLocalUserData(resultData:JSON, dataResponse:DataResponse<Any>){
        
        UserDefaults.standard.set(resultData["data"]["nick"].string!, forKey: Constants.User.USER_NICK_NAME_KEY)
        UserDefaults.standard.set(String(resultData["data"]["uid"].int!), forKey: Constants.User.USER_ID_KEY)
        
        let headerFields = dataResponse.response?.allHeaderFields as! [String: String]
        let url = dataResponse.request?.url
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url!)
        var cookieArray = [ [HTTPCookiePropertyKey : Any ] ]()
        for cookie in cookies {
            cookieArray.append(cookie.properties!)
        }
        UserDefaults.standard.set(cookieArray, forKey: Constants.User.USER_SESSION_KEY)
        
        // 设置到当前的cookie
        for cookieData in cookieArray {
            if let cookie = HTTPCookie.init(properties : cookieData) {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
        
        initUserInfo()
    }
    
    class func initUserInfo() -> () {
        // sessionId
        if let cookieArray = UserDefaults.standard.array(forKey: Constants.User.USER_SESSION_KEY) {
            for cookieData in cookieArray {
                if let dict = cookieData as? [HTTPCookiePropertyKey : Any] {
                    if let cookie = HTTPCookie.init(properties : dict) {
                        HTTPCookieStorage.shared.setCookie(cookie)
                    }
                }
            }
        }
        
        // 用户昵称
        let userNickName = UserDefaults.standard.string(forKey: Constants.User.USER_NICK_NAME_KEY)
        if userNickName == nil {
            Constants.User.USER_NICK_NAME = ""
        }else {
            Constants.User.USER_NICK_NAME = userNickName!
        }
        
        // 用户ID
        let userId = UserDefaults.standard.string(forKey: Constants.User.USER_ID_KEY)
        if userId == nil {
            Constants.User.USER_ID = ""
        }else {
            Constants.User.USER_ID = userId!
        }
    }
    
}
