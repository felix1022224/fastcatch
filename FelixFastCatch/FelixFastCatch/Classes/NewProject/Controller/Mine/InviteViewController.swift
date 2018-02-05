//
//  InviteViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/31.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol InviteWebDelegate:JSExport {
    func share(_ type:Int, _ title:String, _ shareImg:String, _ shareDesc:String, _ link:String)
}

@objc class InviteJsModel: NSObject, InviteWebDelegate {
    
    func share(_ type: Int, _ title: String, _ shareImg: String, _ shareDesc: String, _ link: String) {
        if inviteVC != nil {
            DispatchQueue.main.async {
                self.inviteVC.share(type: type, title: title, img: shareImg, desc: shareDesc, link: link)
            }
        }
    }
    
    var inviteVC:InviteViewController!
    
}

/// 邀请
class InviteViewController: UIViewController, UIWebViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    lazy var actionTitleLabel = UILabel()
    
    /// 加载url
    var webview:UIWebView!
    
    /// 兑换码
    let exchangeButton = UIButton.init(type: UIButtonType.custom)
    
    var jsContext:JSContext!
    
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
        
        /// title
        actionTitleLabel.font = UIFont.systemFont(ofSize: 16)
        actionTitleLabel.text = "邀请"
        actionTitleLabel.textColor = UIColor.black
        headView.addSubview(actionTitleLabel)
        actionTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backImageView)
            make.centerX.equalTo(headView)
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: headView.bounds.height, width: UIScreen.main.bounds.width, height: 0.5))
        lineView.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.8)
        view.addSubview(lineView)
        
        webview = UIWebView(frame: CGRect(x: 0, y: headView.bounds.height + lineView.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - headView.bounds.height))
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
        
        self.jsContext = webview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        let model = InviteJsModel()
        model.inviteVC = self
        
        self.jsContext.setObject(model, forKeyedSubscript: "miaozhuaApp" as NSCopying & NSObjectProtocol)
        self.jsContext.exceptionHandler = { (context, exception) in
            print("exception \(String(describing: exception))")
        }
        
        webview.loadRequest(URLRequest(url: URL(string: "https://api.mz.meidaojia.com/html/market/invite_awards.html?date=\(Constants.getTime())")!))
        
        exchangeButton.setTitle("输入邀请码", for: UIControlState.normal)
        exchangeButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        exchangeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        exchangeButton.sizeToFit()
        headView.addSubview(exchangeButton)
        
        exchangeButton.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - exchangeButton.bounds.width - 15, y: backImageView.frame.origin.y + backImageView.bounds.height/2 - exchangeButton.bounds.height/2)
        
        exchangeButton.addTarget(self, action: #selector(showExchangeDialog), for: UIControlEvents.touchUpInside)
    }
    
    @objc func back(){
        if webview.canGoBack {
            webview.goBack()
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
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
    
    @objc func showExchangeDialog() {
        self.jsContext.evaluateScript("invite.showInviteCodeDialog();")
    }
    
    func share(type:Int, title:String, img:String, desc:String, link: String) {
        if type == 0 || type == 1 {
            if WeChatShared.isInstall() == false {
                ToastUtils.showErrorToast(msg: "暂时无法分享")
                return
            }
        }
        ///0是微信好友，1是朋友圈
        if type == 0 {
            getDataFromUrl(url: URL(string: img)!, completion: { (data, response, error) in
                if response != nil {
                    WeChatShared.shareURL(link, title: title, description: desc, thumbImg: UIImage(data: data!), to: LDWechatScene.Session) { (isSuccess, info) in
                        if isSuccess {
                            ToastUtils.showSuccessToast(msg: "分享成功")
                        }else{
                            ToastUtils.showErrorToast(msg: "分享失败")
                        }
                    }
                }
            })
        }else{
            getDataFromUrl(url: URL(string: img)!, completion: { (data, response, error) in
                if response != nil {
                    WeChatShared.shareURL(link, title: title, description: desc, thumbImg: UIImage(data: data!), to: LDWechatScene.Timeline) { (isSuccess, info) in
                        if isSuccess {
                            ToastUtils.showSuccessToast(msg: "分享成功")
                        }else{
                            ToastUtils.showErrorToast(msg: "分享失败")
                        }
                    }
                }
            })
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }

}
