//
//  WebViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/26.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol webJsDelegate:JSExport {
    func payList()
    func enterRoom(deviceId:String)
    func closeWB()
    func needLogin()
    func openUrl(url:String)
}

@objc class webJsModel: NSObject, webJsDelegate {

    var webVC:WebViewController!
    
    ///需要登录
    func needLogin() {
        LoginViewController.showLoginVC()
    }
    
    ///打开外部链接
    func openUrl(url: String) {
        if url == "" {
            return
        }
        //跳转到外部链接
        if let url = URL(string: url) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],completionHandler: {(success) in })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func payList() {
        if Constants.User.USER_ID == "" {
            needLogin()
            return
        }
        DispatchQueue.main.async {[weak self] in
            let payWebVC = PayWebViewController()
            payWebVC.isShowBack = true
            self?.webVC.navigationController?.pushViewController(payWebVC, animated: true)
        }
    }
    
    func enterRoom(deviceId: String) {
        let gameRoomVC = GameRoomViewController()
        gameRoomVC.deviceId = deviceId
        self.webVC.navigationController?.pushViewController(gameRoomVC, animated: true)
    }
    
    func closeWB() {
        DispatchQueue.main.async {[weak self] in
            self?.webVC.navigationController?.popViewController(animated: true)
            self?.webVC.dismiss(animated: true, completion: nil)
        }
    }
    
}

class WebViewController: UIViewController, UIWebViewDelegate {
    
    /// 要跳转的url地址
    var link:String!
    
    /// 加载url
    private var webview:UIWebView!
    
    var actionTitle: String?
    
    lazy var actionTitleLabel = UILabel()
    
    var jsContext:JSContext!
    
    var shareTitle:String!
    
    var shareInfo:String!
    
    var thumbShareImage:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let backImageView = UIButton.init(type: UIButtonType.custom)
        backImageView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + 45/2 - 45/2, width: 45, height: 45)
        backImageView.setImage(UIImage.init(named: "back"), for: UIControlState.normal)
        backImageView.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height + 45))
        headView.backgroundColor = UIColor.white
        view.addSubview(headView)
        
        headView.addSubview(backImageView)
        
        let shardBtn = UIImageView(image: UIImage(named: "share_icon"))
        shardBtn.sizeToFit()
        headView.addSubview(shardBtn)
        
        shardBtn.isUserInteractionEnabled = true
        let tapMore = UITapGestureRecognizer(target: self, action:#selector(shared))
        shardBtn.addGestureRecognizer(tapMore)
        
        shardBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(backImageView)
            make.right.equalTo(headView).offset(-15)
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: headView.bounds.height, width: UIScreen.main.bounds.width, height: 0.5))
        lineView.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.8)
        view.addSubview(lineView)
        
        webview = UIWebView(frame: CGRect(x: 0, y: headView.bounds.height + lineView.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (headView.bounds.height) - lineView.bounds.height))
        webview.delegate = self
        webview.backgroundColor = UIColor.white
        view.addSubview(webview)
        
        self.jsContext = webview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        let model = webJsModel()
        model.webVC = self

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
                            cookieProperties[HTTPCookiePropertyKey.domain] = "meizhe.meidaojia.com"
                            cookieProperties[HTTPCookiePropertyKey.originURL] = "meizhe.meidaojia.com"
                            cookieProperties[HTTPCookiePropertyKey.path] = "/"
                            cookieProperties[HTTPCookiePropertyKey.version] = "0"

                            let cookie = HTTPCookie(properties: cookieProperties)
                            HTTPCookieStorage.shared.setCookie(cookie!)
                        }
                    }
                }
            }
        }

        webview.loadRequest(URLRequest(url: URL(string: link + "?date=\(Constants.getTime())")!))
        
        /// title
        actionTitleLabel.font = UIFont.systemFont(ofSize: 16)
        actionTitleLabel.text = actionTitle
        actionTitleLabel.textColor = UIColor.black
        headView.addSubview(actionTitleLabel)
        actionTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backImageView)
            make.centerX.equalTo(headView)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
//        self.jsContext = webview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
//        let model = webJsModel()
//        model.webVC = self
//
//        self.jsContext.setObject(model, forKeyedSubscript: "miaozhuaApp" as NSCopying & NSObjectProtocol)
//        self.jsContext.exceptionHandler = { (context, exception) in
//            print("exception \(String(describing: exception))")
//        }
//
//        /// 重新load一遍
//        if webview != nil {
//            if let cookieArray = UserDefaults.standard.array(forKey: Constants.User.USER_SESSION_KEY) {
//                for cookieData in cookieArray {
//                    if let dict = cookieData as? [HTTPCookiePropertyKey : Any] {
//                        if let cookie = HTTPCookie.init(properties : dict) {
//                            if cookie.name == "SESSION" {
//                                var cookieProperties =  [HTTPCookiePropertyKey : Any]()
//                                cookieProperties[HTTPCookiePropertyKey.name] = cookie.name
//                                cookieProperties[HTTPCookiePropertyKey.value] = cookie.value
//                                cookieProperties[HTTPCookiePropertyKey.domain] = "meizhe.meidaojia.com"
//                                cookieProperties[HTTPCookiePropertyKey.originURL] = "meizhe.meidaojia.com"
//                                cookieProperties[HTTPCookiePropertyKey.path] = "/"
//                                cookieProperties[HTTPCookiePropertyKey.version] = "0"
//
//                                let cookie = HTTPCookie(properties: cookieProperties)
//                                HTTPCookieStorage.shared.setCookie(cookie!)
//                            }
//                        }
//                    }
//                }
//            }
//
//            webview.loadRequest(URLRequest(url: URL(string: link + "?date=\(Constants.getTime())")!))
//        }
    }
    
    @objc func back() -> () {
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func shared() -> () {
        if WeChatShared.isInstall() == false {
            ToastUtils.showErrorToast(msg: "暂时无法分享")
            return
        }
        
        let sharedView = SharedViewDialog(frame: UIScreen.main.bounds)
        sharedView.createView()
        sharedView.scheme = link
        sharedView.shareTitle = shareTitle
        sharedView.shareInfo = shareInfo
        sharedView.thumbShareImage = thumbShareImage
        sharedView.show()
    }
}
