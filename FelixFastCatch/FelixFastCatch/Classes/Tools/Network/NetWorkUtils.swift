//
//  NetWorkUtils.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/26.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import CoreLocation

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
}
