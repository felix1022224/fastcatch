//
//  Constants.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/25.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class Constants: NSObject {
    
    struct Network {
        static let BASE_URL = "http://101.201.68.47:9125/"
        
        // 微信Pay支付接口
        static let WECHAT_PAY_URL =  BASE_URL +  "trade/wechatorder"
    }
    
    struct Tools {
        
    }
    
}
