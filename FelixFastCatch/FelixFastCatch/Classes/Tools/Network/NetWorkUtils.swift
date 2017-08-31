//
//  NetWorkUtils.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/26.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class NetWorkUtils: NSObject , CLLocationManagerDelegate{
    
    
    /// 请求网络时的基础参数
    ///
    /// - Returns: 每个接口都需要的基础参数
    class func createBaseParams() -> [String: String]{
        var baseParams = [String: String]()
    
        let infoDictionary = Bundle.main.infoDictionary!
        baseParams["channel"] = "iOS"
        baseParams["deviceModel"] = UIDevice.current.modelName.rawValue
        baseParams["osVersion"] = UIDevice.current.systemVersion
        baseParams["appVersion"] = infoDictionary["CFBundleShortVersionString"] as? String
        // 经度
        baseParams["lng"] = Constants.Tools.LNG
        //维度
        baseParams["lat"] = Constants.Tools.LAT
        
        return baseParams
    }
    
    
    /// 检查返回的数据是否是正确的
    ///
    /// - Parameter response: 服务器返回的数据
    /// - Returns: 是否code == 0
    class func checkReponse(response:DataResponse<Any>) -> Bool{
        if response.error == nil && response.data != nil {
            let jsonData = JSON(data: response.data!)
            if jsonData["code"].int! == 0 {
                 return true
            }else if jsonData["code"].int! == -302 {
                print("用户身份异常，重新登录")
                if !Constants.isFastLoginShow {
                    let loginDialog = FastLoginDialog(frame: UIScreen.main.bounds)
                    loginDialog.createView()
                    loginDialog.show()
                }
                LocalDataUtils.clearLoaclData()
                return false
            }
            return false
        }else{
            print("error:\(String(describing: response.error))")
            return false
        }
    }
}
