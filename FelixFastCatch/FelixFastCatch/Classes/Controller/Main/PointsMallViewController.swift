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
    
    lazy var actionTitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let backImageView = UIImageView(image: UIImage(named: "web_back"))
        backImageView.sizeToFit()
        backImageView.frame = CGRect(x: 8, y: UIApplication.shared.statusBarFrame.height + 8, width: backImageView.bounds.width*1.2, height: backImageView.bounds.height*1.2)
        
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height + backImageView.bounds.height + 15))
        headView.backgroundColor = UIColor.white
        view.addSubview(headView)
        
        /////设置允许交互属性
        backImageView.isUserInteractionEnabled = true
        /////添加tapGuestureRecognizer手势
        let tapGR = UITapGestureRecognizer(target: self, action:#selector(back))
        backImageView.addGestureRecognizer(tapGR)
        headView.addSubview(backImageView)
        
        /// title
        actionTitleLabel.font = UIFont.systemFont(ofSize: 16)
        actionTitleLabel.text = "积分商城"
        actionTitleLabel.textColor = UIColor.black
        headView.addSubview(actionTitleLabel)
        actionTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backImageView)
            make.centerX.equalTo(headView)
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: headView.bounds.height, width: UIScreen.main.bounds.width, height: 0.5))
        lineView.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.8)
        view.addSubview(lineView)
        
        webview = UIWebView(frame: CGRect(x: 0, y: headView.bounds.height + lineView.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        webview.delegate = self
        view.addSubview(webview)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
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
        
    }
    
    @objc func back() -> () {
        if webview.canGoBack {
            webview.goBack()
            return
        }
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
