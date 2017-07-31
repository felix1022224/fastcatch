//
//  Constants.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/25.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class Constants: NSObject {
    
    /// 网络
    struct Network {
        static let BASE_URL = "http://101.201.68.47:9125/"
        
//        static let BASE_URL = "http://192.168.1.103:9125/"
        
        /// 微信Pay支付接口
        static let WECHAT_PAY_URL =  BASE_URL +  "trade/wechatorder"
        
        /// 支付宝支付接口
        static let ALIPAY_URL = BASE_URL + "trade/alipayorder"
        
        /// 首页banner图的数据
        static let MAIN_BANNER_LIST = BASE_URL + "activity/bannerlist"
        
        /// 首页的数据
        static let MAIN_LIST = BASE_URL + "machine/list"
        
        /// 发送验证码的接口
        static let SEND_VERIFY_CODE = BASE_URL + "user/sendcode"
        
        /// 手机号登录
        static let PHONE_NUMBER_LOGIN = BASE_URL + "user/phonelogin"
        
        /// 游戏房间相关
        struct Machine {
            
            /// 进入房间
            static let ENTER_WATCH = BASE_URL + "machine/enterwatch"
            
            /// 退出房间
            static let OUT_WATCH = BASE_URL + "machine/quitwatch"
            
            /// 开始游戏
            static let START_PLAY = BASE_URL + "machine/startgame"
            
            /// 开始预约
            static let WAIT_QUEUE = BASE_URL + "machine/waitqueue"
            
            /// 操作机器臂
            static let DIECTION_CONTROLLER =  BASE_URL + "machine/directionctl"
            
            /// 下爪
            static let CONTROLLER_CATCH = BASE_URL + "machine/catchpress"
            
            /// 获取中奖信息
            static let GET_WARD = BASE_URL + "machine/getaward"
            
//            static let END_PALY = BASE_URL + ""
        }
        
        /// 用户相关
        struct User {
            
            /// 微信登录
            static let WECHAT_LOGIN = BASE_URL + "user/wechatlogin"
            
            /// qq登录
            static let QQ_LOGIN = BASE_URL + "user/qqlogin"
            
            /// 退出登录
            static let LOGOUT_URL = BASE_URL + "user/logout"
            
        }
    }
    
    /// 工具
    struct Tools {
        
        /// 经度
        static var LNG:String = "0.0"
        
        /// 经度
        static var LAT:String = "0.0"
        
    }
    
    /// 控件
    struct UI {
        /// 描边颜色
        static let OUT_LINE_COLOR:UIColor = UIColor(red: 160/255.0, green: 123/255.0, blue: 80/255.0, alpha: 1)
        
        /// 描边粗细
        static let OUT_LINE_WIDTH:CGFloat = 4
        
        /// 钻石数量的文字颜色
        static let GEM_TEXT_COLOR:UIColor = UIColor(red: 255/255.0, green: 162/255.0, blue: 0.0, alpha: 1)
    }
    
    /// 用户
    struct User{
    
        /// sessionid
        static var USER_SESSIONID:String = ""
        
        /// 昵称
        static var USER_NICK_NAME = ""
        
        /// 性别
        static var USER_SEX = ""
        
        /// 生日
        static var USER_BRITHDAY = ""
        
        /// 用户ID
        static var USER_ID = ""
        
        /// 用户头像
        static var USER_FACE_IMAGE = ""
        
        static let USER_SESSION_KEY = "userSessionId"
        static let USER_NICK_NAME_KEY = "userNickName"
        static let USER_SEX_KEY = "userSex"
        static let USER_BRITHDAY_KEY = "userBrithday"
        static let USER_ID_KEY = "userId"
        static let USER_FACE_IMAGE_KEY = "userFaceImage"
    }
    
}
