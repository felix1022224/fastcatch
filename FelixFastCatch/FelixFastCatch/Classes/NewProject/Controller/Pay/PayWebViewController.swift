//
//  PayWebViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/31.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class PayWebViewController: UIViewController, UIWebViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    static func showPayWebVC(isShowBack:Bool){
        let payWebViewVC = PayWebViewController()
        payWebViewVC.isShowBack = isShowBack
        UIApplication.shared.keyWindow?.rootViewController?.present(payWebViewVC, animated: true, completion: nil)
    }
    
    var isShowBack = false
    
    lazy var actionTitleLabel = UILabel()
    
    /// 加载url
    var webview:UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        let backImageView = UIImageView(image: UIImage(named: "back"))
        backImageView.sizeToFit()
        backImageView.frame = CGRect(x: 15, y: UIApplication.shared.statusBarFrame.height + 45/2 - backImageView.bounds.height*1.1/2, width: backImageView.bounds.width*1.1, height: backImageView.bounds.height*1.1)
        
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height + 45))
        headView.backgroundColor = UIColor.white
        view.addSubview(headView)
        
        /////设置允许交互属性
        backImageView.isUserInteractionEnabled = true
        /////添加tapGuestureRecognizer手势
        let tapGR = UITapGestureRecognizer(target: self, action:#selector(back))
        backImageView.addGestureRecognizer(tapGR)
        headView.addSubview(backImageView)
        
        if isShowBack {
            backImageView.isHidden = false
        }else{
            backImageView.isHidden = true
        }
        
        /// title
        actionTitleLabel.font = UIFont.systemFont(ofSize: 16)
        actionTitleLabel.text = "充值"
        actionTitleLabel.textColor = UIColor.black
        headView.addSubview(actionTitleLabel)
        actionTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backImageView)
            make.centerX.equalTo(headView)
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: headView.bounds.height, width: UIScreen.main.bounds.width, height: 0.5))
        lineView.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.8)
        view.addSubview(lineView)
        
        if isShowBack {
            /// 不是首页
            webview = UIWebView(frame: CGRect(x: 0, y: headView.bounds.height + lineView.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - headView.bounds.height))
        }else{
            /// 是首页
            webview = UIWebView(frame: CGRect(x: 0, y: headView.bounds.height + lineView.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - headView.bounds.height - MainTabsViewController.tabHeight))
        }
        webview.backgroundColor = UIColor.white
        webview.delegate = self
        view.addSubview(webview)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
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
        
        webview.loadRequest(URLRequest(url: URL(string: "https://api.mz.meidaojia.com/html/market/pay.html")!))
        
    }
    
    @objc func back(){
        if isShowBack {
            if webview.canGoBack {
                webview.goBack()
                return
            }
            self.dismiss(animated: true, completion: nil)
        }else{
            
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        self.jsContext = webview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
//        let model = pointsJsModel()
//        model.vc = self
//
//        self.jsContext.setObject(model, forKeyedSubscript: "miaozhuaApp" as NSCopying & NSObjectProtocol)
//        self.jsContext.exceptionHandler = { (context, exception) in
//        }
        
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

}
