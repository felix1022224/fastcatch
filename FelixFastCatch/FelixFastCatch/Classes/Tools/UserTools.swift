//
//  UserTools.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/6.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserTools: NSObject {

    /// 获取用户信息，刷新本地数据
    class func getUserInfo() -> () {
        Alamofire.request(Constants.Network.User.GET_USER_INFO, method: .post, parameters: NetWorkUtils.createBaseParams(), encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print("result:\(String(describing: response.result.value))")
            if NetWorkUtils.checkReponse(response: response) {
                /// 更新用户信息
                let json = JSON(response.result.value!)
                Constants.User.addrName = json["data"]["pav"]["name"].stringValue
                Constants.User.addr = json["data"]["pav"]["addr"].stringValue
                Constants.User.addrPhone = json["data"]["pav"]["phone"].stringValue
                Constants.User.addressId = json["data"]["pav"]["id"].stringValue
                
                Constants.User.USER_BRITHDAY = json["data"]["birthday"].stringValue
                
                Constants.User.checkDays = json["data"]["checkDays"].intValue
                if json["data"]["todayChecked"].intValue == 1 {
                    Constants.User.todayChecked = true
                }else{
                    Constants.User.todayChecked = false
                }
                
                Constants.User.diamondsCount = json["data"]["diamondsCount"].intValue
            }
            print("result:\(String(describing: response.result.value))")
        }
    }
    
}
