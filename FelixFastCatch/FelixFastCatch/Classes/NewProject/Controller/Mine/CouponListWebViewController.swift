
//
//  CouponListWebViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/2/3.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class CouponListWebViewController: BaseActionBarViewController {

    /// 加载url
    private var webview:UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        actionTitleLabel.text = "优惠券"
        
        webview = UIWebView(frame: CGRect(x: 0, y: headView.bounds.height + 1, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (headView.bounds.height) - 1))
        webview.backgroundColor = UIColor.white
        view.addSubview(webview)
        
        if let cookieArray = UserDefaults.standard.array(forKey: Constants.User.USER_SESSION_KEY) {
            for cookieData in cookieArray {
                if let dict = cookieData as? [HTTPCookiePropertyKey : Any] {
                    if let cookie = HTTPCookie.init(properties : dict) {
                        if cookie.name == "SESSION" {
                            var cookieProperties =  [HTTPCookiePropertyKey : Any]()
                            cookieProperties[HTTPCookiePropertyKey.name] = cookie.name
                            cookieProperties[HTTPCookiePropertyKey.value] = cookie.value
                            cookieProperties[HTTPCookiePropertyKey.domain] = "api.mz.meidaojia.com"
                            cookieProperties[HTTPCookiePropertyKey.originURL] = "http://api.mz.meidaojia.com"
                            cookieProperties[HTTPCookiePropertyKey.path] = "/"
                            cookieProperties[HTTPCookiePropertyKey.version] = "0"
                            
                            let cookie = HTTPCookie(properties: cookieProperties)
                            HTTPCookieStorage.shared.setCookie(cookie!)
                        }
                    }
                }
            }
        }
        
        webview.loadRequest(URLRequest(url: URL(string: "https://api.mz.meidaojia.com/html/market/coupon.html?org=0?date=\(Constants.getTime())")!))
    }

}
