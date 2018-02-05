//
//  PointsMallViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/11/9.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol pointsJsDelegate:JSExport {
    func finish()
    func showBack()
}

@objc class pointsJsModel: NSObject, pointsJsDelegate {
    
    var vc:PointsMallViewController!
    
    func showBack() {
        if vc != nil {
            DispatchQueue.main.async {
                self.vc.backImageView.isHidden = false
            }
        }
    }
    
    func finish() -> () {
        if vc != nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {[weak self] in
                self?.vc.navigationController?.popViewController(animated: true)
                self?.vc.webview = nil
            })
        }
    }
    
}

/// 积分商城
class PointsMallViewController: BaseActionBarViewController , UIWebViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    /// 加载url
    var webview:UIWebView!
    
    var jsContext:JSContext!
    
    /// 积分记录
    let pointListButton = UIButton.init(type: UIButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        actionTitleLabel.text = "积分商城"
        
        backImageView.isHidden = true
        
        webview = UIWebView(frame: CGRect(x: 0, y: headView.bounds.height + 1, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - headView.bounds.height - MainTabsViewController.tabHeight))
        webview.delegate = self
        view.addSubview(webview)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
//        self.jsContext = webview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
//        let model = pointsJsModel()
//        model.vc = self
//
//        self.jsContext.setObject(model, forKeyedSubscript: "miaozhuaApp" as NSCopying & NSObjectProtocol)
//        self.jsContext.exceptionHandler = { (context, exception) in
//        }
//
//        if let cookieArray = UserDefaults.standard.array(forKey: Constants.User.USER_SESSION_KEY) {
//            for cookieData in cookieArray {
//                if let dict = cookieData as? [HTTPCookiePropertyKey : Any] {
//                    if let cookie = HTTPCookie.init(properties : dict) {
//                        if cookie.name == "SESSION" {
//                            var cookieProperties =  [HTTPCookiePropertyKey : Any]()
//                            cookieProperties[HTTPCookiePropertyKey.name] = cookie.name
//                            cookieProperties[HTTPCookiePropertyKey.value] = cookie.value
//                            cookieProperties[HTTPCookiePropertyKey.domain] = "api.mz.meidaojia.com"
//                            cookieProperties[HTTPCookiePropertyKey.originURL] = "http://api.mz.meidaojia.com"
//                            cookieProperties[HTTPCookiePropertyKey.path] = "/"
//                            cookieProperties[HTTPCookiePropertyKey.version] = "0"
//
//                            let cookie = HTTPCookie(properties: cookieProperties)
//                            HTTPCookieStorage.shared.setCookie(cookie!)
//                        }
//                    }
//                }
//            }
//        }
//
//        webview.loadRequest(URLRequest(url: URL(string: "https://api.mz.meidaojia.com/html/score/score.html")!))
        
        pointListButton.setTitle("积分记录", for: UIControlState.normal)
        pointListButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        pointListButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        pointListButton.sizeToFit()
        headView.addSubview(pointListButton)
        
        pointListButton.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - pointListButton.bounds.width - 15, y: backImageView.frame.origin.y + backImageView.bounds.height/2 - pointListButton.bounds.height/2)
        
        pointListButton.addTarget(self, action: #selector(showPointList), for: UIControlEvents.touchUpInside)
        
        pointListButton.isHidden = true
    }

    @objc func showPointList() {
        self.navigationController?.pushViewController(PointListViewController(), animated: true)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.jsContext = webview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        let model = pointsJsModel()
        model.vc = self
        
        self.jsContext.setObject(model, forKeyedSubscript: "miaozhuaApp" as NSCopying & NSObjectProtocol)
        self.jsContext.exceptionHandler = { (context, exception) in
        }
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.jsContext = webview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        let model = pointsJsModel()
        model.vc = self
        
        self.jsContext.setObject(model, forKeyedSubscript: "miaozhuaApp" as NSCopying & NSObjectProtocol)
        self.jsContext.exceptionHandler = { (context, exception) in
        }
        
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
        
        let now = NSDate()
        
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        
        let timeStamp = Int(timeInterval)
        
        webview.loadRequest(URLRequest(url: URL(string: "https://api.mz.meidaojia.com/html/score/score.html?date=\(timeStamp)")!))
        
        backImageView.isHidden = true
        
        actionTitleLabel.text = "积分商城"
    }
    
    deinit {
        
    }
    
    @objc override func back() -> () {
        if webview.canGoBack {
            webview.goBack()
            backImageView.isHidden = true
        }else{
            backImageView.isHidden = false
        }
    }
    
}
