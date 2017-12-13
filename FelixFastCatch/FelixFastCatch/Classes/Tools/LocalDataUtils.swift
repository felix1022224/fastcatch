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
    class func updateLocalUserData(resultData:JSON, _ dataResponse:DataResponse<Any>?){
        
        UserDefaults.standard.set(resultData["data"]["nick"].stringValue, forKey: Constants.User.USER_NICK_NAME_KEY)
        UserDefaults.standard.set(String(resultData["data"]["uid"].intValue), forKey: Constants.User.USER_ID_KEY)
        UserDefaults.standard.set(resultData["data"]["avatar"].stringValue, forKey: Constants.User.USER_FACE_IMAGE_KEY)
        UserDefaults.standard.set(String(resultData["data"]["gender"].intValue), forKey: Constants.User.USER_SEX_KEY)
        UserDefaults.standard.set(resultData["data"]["birthday"].stringValue, forKey: Constants.User.USER_BRITHDAY_KEY)
        UserDefaults.standard.set(resultData["data"]["tag"].stringValue, forKey: Constants.User.USER_TAG_KEY)
        UserDefaults.standard.set(String(resultData["data"]["id"].intValue), forKey: Constants.User.ID_KEY)
        
        if dataResponse != nil {
            let headerFields = dataResponse?.response?.allHeaderFields as! [String: String]
            let url = dataResponse?.request?.url
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
            print("cookies:\(String(describing: UserDefaults.standard.array(forKey: Constants.User.USER_SESSION_KEY)))")
        }
        
        
        Constants.User.checkDays = resultData["data"]["checkDays"].intValue
        Constants.User.diamondsCount = resultData["data"]["diamondsCount"].intValue
        Constants.User.todayChecked = resultData["data"]["todayChecked"].boolValue
        
        Constants.User.addrName = resultData["data"]["pav"]["name"].stringValue
        Constants.User.addrPhone = resultData["data"]["pav"]["phone"].stringValue
        Constants.User.addr = resultData["data"]["pav"]["addr"].stringValue
        Constants.User.addressId = String(resultData["data"]["pav"]["id"].intValue)
        
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
        
        // 用户ID
        let id = UserDefaults.standard.string(forKey: Constants.User.ID_KEY)
        if id == nil {
            Constants.User.ID = ""
        }else {
            Constants.User.ID = id!
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
        
        // 用户生日
        let userBrithday = UserDefaults.standard.string(forKey: Constants.User.USER_BRITHDAY_KEY)
        if userBrithday == nil {
            Constants.User.USER_BRITHDAY = ""
        }else {
            Constants.User.USER_BRITHDAY = userBrithday!
        }
        
        // 用户邀请码
        let userTag = UserDefaults.standard.string(forKey: Constants.User.USER_TAG_KEY)
        if userTag == nil {
            Constants.User.USER_TAG = ""
        }else {
            Constants.User.USER_TAG = userTag!
        }
    }
    
    
    /// 清除数据
    class func clearLoaclData() -> () {
        UserDefaults.standard.removeObject(forKey: Constants.User.USER_ID_KEY)
        UserDefaults.standard.removeObject(forKey: Constants.User.USER_SESSION_KEY)
        UserDefaults.standard.removeObject(forKey: Constants.User.USER_FACE_IMAGE_KEY)
        UserDefaults.standard.removeObject(forKey: Constants.User.USER_NICK_NAME_KEY)
        UserDefaults.standard.removeObject(forKey: Constants.User.USER_SEX_KEY)
        UserDefaults.standard.removeObject(forKey: Constants.User.USER_BRITHDAY)
        UserDefaults.standard.removeObject(forKey: Constants.User.USER_TAG_KEY)
        
        Constants.User.USER_NICK_NAME = ""
        Constants.User.USER_ID = ""
        Constants.User.USER_FACE_IMAGE = ""
        Constants.User.USER_SEX = ""
        Constants.User.USER_BRITHDAY = ""
        Constants.User.USER_TAG = ""
        
        ///清除存储的所有的cookie
        let cookieArray = HTTPCookieStorage.shared.cookies
        for httpCookie in cookieArray! {
            HTTPCookieStorage.shared.deleteCookie(httpCookie)
        }
    }
    
}
