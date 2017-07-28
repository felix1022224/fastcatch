//
//  Constants.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/25.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class Constants: NSObject {
    
    // 网络
    struct Network {
        static let BASE_URL = "http://101.201.68.47:9125/"
        
        // 微信Pay支付接口
        static let WECHAT_PAY_URL =  BASE_URL +  "trade/wechatorder"
        
        // 首页banner图的数据
        static let MAIN_BANNER_LIST = BASE_URL + "activity/bannerlist"
        
        // 首页的数据
        static let MAIN_LIST = BASE_URL + "machine/list"
        
        // 发送验证码的接口
        static let SEND_VERIFY_CODE = BASE_URL + "user/sendcode"
    }
    
    // 工具
    struct Tools {
        
        // 经度
        static var LNG:String = "0.0"
        
        // 经度
        static var LAT:String = "0.0"
        
    }
    
    // 控件
    struct UI {
        // 描边颜色
        static let OUT_LINE_COLOR:UIColor = UIColor(red: 160/255.0, green: 123/255.0, blue: 80/255.0, alpha: 1)
        
        // 描边粗细
        static let OUT_LINE_WIDTH:CGFloat = 4
        
        // 钻石数量的文字颜色
        static let GEM_TEXT_COLOR:UIColor = UIColor(red: 255/255.0, green: 162/255.0, blue: 0.0, alpha: 1)
    }
    
}
