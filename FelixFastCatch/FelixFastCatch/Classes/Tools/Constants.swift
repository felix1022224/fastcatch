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
        
        /// 正式地址
//        static let BASE_URL = "http://101.201.68.47:9125/"
        
        /// 测试地址
        static let BASE_URL = "http://192.168.1.162:9125/"
        
//        static let BASE_URL = "http://47.92.72.158:9125/"
        
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
        
        /// 获取支付列表
        static let GET_PAY_LIST = BASE_URL + "rp/list"
        
        /// 获取系统版本号
        static let GET_SYS_INFO_VERSION = BASE_URL + "/app/config/version"
        
        /// 苹果内购服务器验证
        static let APPLE_PAY_CHECK = BASE_URL + "trade/applePayOrder"
        
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
            
            /// 取消预约
            static let END_PALY = BASE_URL + "machine/quitqueue"
            
            /// 获取开屏页
            static let GET_OPEN_ADV = BASE_URL + "advertise/list?showPage=0"
            
            
        }
        
        /// 礼物相关
        struct Gift {
            
            /// 获取未邮寄的列表
            static let GET_TOBE_MAILED_GIFT_LIST = BASE_URL + "draworder/unpostagelist"
            
            /// 创建邮寄订单
            static let CREATE_POSTAGE = BASE_URL + "draworder/createpostage"
            
            /// 获取用户的地址信息
            static let GET_USER_ADDRESS = BASE_URL + "postage/get"
            
            /// 保存用户地址信息
            static let SAVE_USER_ADDRESS = BASE_URL + "user/pscreate"
            
            /// 获取已邮寄列表
            static let GET_MAILED_GIFT_LIST = BASE_URL + "draworder/postagedlist"
            
        }
        
        /// 用户相关
        struct User {
            
            /// 微信登录
            static let WECHAT_LOGIN = BASE_URL + "user/wechatlogin"
            
            /// qq登录
            static let QQ_LOGIN = BASE_URL + "user/qqlogin"
            
            /// 退出登录
            static let LOGOUT_URL = BASE_URL + "user/logout"
            
            /// 更新用户信息
            static let UPDATE_USER_INFO = BASE_URL + "user/update"
            
            /// 获取用户数据
            static let GET_USER_INFO = BASE_URL + "user/get"
            
            /// 用户签到
            static let USER_CHECKIN = BASE_URL + "user/checkin"
            
            /// 邀请码
            static let USER_INVITE = BASE_URL + "user/invreg"
            
            /// 使用兑换码
            static let USER_EXCHANGE_CODE = BASE_URL + "user/exchange"
            
            /// 获取邀请好友列表
            static let GET_INVITE_LIST = BASE_URL + "user/invreglist"
            
            /// 游戏记录
            static let GET_GAME_HISTORY = BASE_URL + "award/list"
            
            /// 代币记录
            static let GET_TOKEN_HISTORY = BASE_URL + "cr/list"
            
            /// 获取免邮次数
            static let GET_FREE_POST_NUMBER = BASE_URL + "app/config/freepostnum"
            
            /// 获取成就列表
            static let GET_USER_TITLES_LIST = BASE_URL + "user/achievement"
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
        static let OUT_LINE_WIDTH:CGFloat = 2
        
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
        
        static var ID = ""
        
        /// 用户头像
        static var USER_FACE_IMAGE = ""
        
        /// 用户邀请码
        static var USER_TAG = ""
        
        static let ID_KEY = "user_id"
        static let USER_SESSION_KEY = "userSessionId"
        static let USER_NICK_NAME_KEY = "userNickName"
        static let USER_SEX_KEY = "userSex"
        static let USER_BRITHDAY_KEY = "userBrithday"
        static let USER_ID_KEY = "userId"
        static let USER_FACE_IMAGE_KEY = "userFaceImage"
        static let USER_TAG_KEY = "userTag"
        
        /// 钻石数
        static var diamondsCount = 0
        
        /// 今天是否签到了
        static var todayChecked = false
        
        /// 连续签到天数
        static var checkDays = 0
        
        /// 地址收件人
        static var addrName = ""
        
        /// 收件人手机号
        static var addrPhone = ""
        
        /// 地址详情
        static var addr = ""
        
        /// 地址ID
        static var addressId = ""
        
        /// 音频开关设置
        static let USER_AUDIO_SETTING = "userAudioSetting"
    }
    
    ///是否显示了login界面
    public static var isFastLoginShow = false
    
    /// app当前版本号
    public static var app_release_version = ""
    
    /// 是否显示支付页面
    public static var isShowPay = true
    
    /// 是否第一次打开啊首页
    public static var IS_FIRST_OPEN_MAIN = "isFirstOpenMain"
    
    /// 是否第一次打开游戏界面
    public static var IS_FIRST_OPEN_PLAY = "isFirstOpenPlay"
}
