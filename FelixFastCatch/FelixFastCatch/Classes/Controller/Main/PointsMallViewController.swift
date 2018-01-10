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
}

@objc class pointsJsModel: NSObject, pointsJsDelegate {
    
    var vc:PointsMallViewController!
    
    func finish() -> () {
        if vc != nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {[weak self] in
//                self?.vc.dismiss(animated: true, completion: nil)
                self?.vc.navigationController?.popViewController(animated: true)
                self?.vc.webview = nil
            })
        }
    }
    
}

/// 积分商城
class PointsMallViewController: UIViewController , UIWebViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    /// 加载url
    var webview:UIWebView!
    
    var jsContext:JSContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        webview = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        webview.delegate = self
        view.addSubview(webview)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.jsContext = webview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        let model = pointsJsModel()
        model.vc = self
        
        self.jsContext.setObject(model, forKeyedSubscript: "miaozhuaApp" as NSCopying & NSObjectProtocol)
        self.jsContext.exceptionHandler = { (context, exception) in
            print("exception \(String(describing: exception))")
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
        
        webview.loadRequest(URLRequest(url: URL(string: "https://api.mz.meidaojia.com/market/score.html")!))
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
            print("exception \(String(describing: exception))")
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
    
    deinit {
        print("points,deinit")
    }
    
}
