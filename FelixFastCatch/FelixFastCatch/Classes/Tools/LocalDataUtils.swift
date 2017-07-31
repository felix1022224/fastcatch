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
        UserDefaults.standard.set(resultData["data"]["avatar"].string, forKey: Constants.User.USER_FACE_IMAGE_KEY)
        UserDefaults.standard.set(String(resultData["data"]["gender"].int!), forKey: Constants.User.USER_SEX_KEY)
        
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
        
        // 用户头像
        let userFaceImage = UserDefaults.standard.string(forKey: Constants.User.USER_FACE_IMAGE_KEY)
        if userFaceImage == nil {
            Constants.User.USER_FACE_IMAGE = ""
        }else {
            Constants.User.USER_FACE_IMAGE = userFaceImage!
        }
        
        // 用户性别
        let userSex = UserDefaults.standard.string(forKey: Constants.User.USER_SEX_KEY)
        if userSex == nil {
            Constants.User.USER_SEX = ""
        }else {
            Constants.User.USER_SEX = userSex!
        }
    }
    
    
    /// 清除数据
    class func clearLoaclData() -> () {
        UserDefaults.standard.removeObject(forKey: Constants.User.USER_ID_KEY)
        UserDefaults.standard.removeObject(forKey: Constants.User.USER_SESSION_KEY)
        UserDefaults.standard.removeObject(forKey: Constants.User.USER_FACE_IMAGE_KEY)
        UserDefaults.standard.removeObject(forKey: Constants.User.USER_NICK_NAME_KEY)
        UserDefaults.standard.removeObject(forKey: Constants.User.USER_SEX_KEY)
        
        Constants.User.USER_NICK_NAME = ""
        Constants.User.USER_ID = ""
        Constants.User.USER_FACE_IMAGE = ""
        Constants.User.USER_SEX = ""
    }
    
}
