//
//  PayWebViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/31.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import JavaScriptCore
import SwiftyJSON
import Alamofire

@objc protocol payWebDelegate:JSExport {
    func showBack()
    func pay(payType:Int, payRp:String, couponId:String)
}

@objc class PayJsModel: NSObject, payWebDelegate {
    
    var payVC:PayWebViewController!
    
    func showBack() {
        if payVC != nil {
            DispatchQueue.main.async {
                self.payVC.backImageView.isHidden = false
            }
        }
    }
    
    func pay(payType: Int, payRp: String, couponId: String) {
        if payVC != nil {
            self.payVC.pay(payType: payType, rp: payRp, couponId: couponId)
        }
    }
    
}

class PayWebViewController: UIViewController, UIWebViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    static func showPayWebVC(isShowBack:Bool){
        let payWebViewVC = PayWebViewController()
        payWebViewVC.isShowBack = isShowBack
        UIApplication.shared.keyWindow?.rootViewController?.present(payWebViewVC, animated: true, completion: nil)
    }
    
    var jsContext:JSContext!
    
    var isShowBack = false
    
    lazy var actionTitleLabel = UILabel()
    
    let backImageView = UIButton.init(type: UIButtonType.custom)
    
    /// 加载url
    var webview:UIWebView!
    
    /// 兑换码
    let exchangeButton = UIButton.init(type: UIButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        backImageView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + 45/2 - 45/2, width: 45, height: 45)
        backImageView.setBackgroundImage(UIImage.init(named: "back"), for: UIControlState.normal)
        
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height + 45))
        headView.backgroundColor = UIColor.white
        view.addSubview(headView)

        backImageView.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
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
        
        self.jsContext = webview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        let model = PayJsModel()
        model.payVC = self
        
        self.jsContext.setObject(model, forKeyedSubscript: "miaozhuaApp" as NSCopying & NSObjectProtocol)
        self.jsContext.exceptionHandler = { (context, exception) in
            print("exception \(String(describing: exception))")
        }
        
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
        
        exchangeButton.setTitle("兑换码", for: UIControlState.normal)
        exchangeButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        exchangeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        exchangeButton.sizeToFit()
        headView.addSubview(exchangeButton)
        
        exchangeButton.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - exchangeButton.bounds.width - 15, y: backImageView.frame.origin.y + backImageView.bounds.height/2 - exchangeButton.bounds.height/2)
        
        exchangeButton.addTarget(self, action: #selector(showExchangeDialog), for: UIControlEvents.touchUpInside)
    
//        hideShowExchangeBtn()
    }
    
    @objc func back(){
        if isShowBack {
            if webview.canGoBack {
                webview.goBack()
                return
            }
            self.dismiss(animated: true, completion: nil)
        }else{
            if webview.canGoBack {
                webview.goBack()
                backImageView.isHidden = true
            }else{
                backImageView.isHidden = false
            }
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.jsContext = webview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        let model = PayJsModel()
        model.payVC = self
        
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
    
    @objc func pay(payType:Int, rp:String, couponId:String){
        if payType == 0 {
            // 微信
            wechatPay(rp: rp, couponId: couponId)
        }else if payType == 1 {
            // 支付宝
            aliPay(rp: rp, couponId: couponId)
        }
    }
    
    /// 微信支付
    func wechatPay(rp:String,couponId:String) -> () {
        if WeChatShared.isInstall() == false {
            ToastUtils.showErrorToast(msg: "暂时无法支付")
            return
        }
        
        ToastUtils.showLoadingToast(msg: "正在下单")
        var params = NetWorkUtils.createBaseParams()
        params["rp"] = rp
        if couponId != "" {
            params["cid"] = couponId
        }
        
        Alamofire.request(Constants.Network.WECHAT_PAY_URL, method: .post, parameters: params).responseJSON { (response) in
            ToastUtils.hide()
            if response.error == nil && response.data != nil {
                let jsonData = JSON(data: response.data!)
                if jsonData["code"].int! == 0 {
                    WeChatShared.pay(to: "main", jsonData["data"], resultHandle: { (result, identifier) in
                        switch(result){
                        case .Success:
                            self.paySuccessCallbackH5()
                            ToastUtils.showSuccessToast(msg: "支付成功")
                            break;
                        case .Failed:
                            ToastUtils.showErrorToast(msg: "支付失败")
                            break;
                        case .Cancel:
                            ToastUtils.showInfoToast(msg: "取消支付")
                            break;
                        }
                    })
                }else if jsonData["code"].int! == -302 {
                    print("用户身份异常，重新登录")
                    LoginViewController.showLoginVC()
                    LocalDataUtils.clearLoaclData()
                }else if jsonData["code"].int! == -101 {
                    ToastUtils.showErrorToast(msg: "您不具备首充资格，请刷新")
                }else{
                    ToastUtils.showErrorToast(msg: "错误:" + jsonData["msg"].stringValue)
                }
            }else{
                
            }
        }
    }
    
    func aliPay(rp:String,couponId:String) -> () {
        ToastUtils.showLoadingToast(msg: "正在下单……")
        var params = NetWorkUtils.createBaseParams()
        params["rp"] = String(rp)
        
        if couponId != "" {
            params["cid"] = couponId
        }
        
        Alamofire.request(Constants.Network.ALIPAY_URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            ToastUtils.hide()
            if response.error == nil && response.data != nil {
                let jsonData = JSON(data: response.data!)
                if jsonData["code"].int! == 0 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { [weak self] in
                        self?.aliPayOrder(orderBody: jsonData["data"]["orderBody"].string!)
                    })
                }else if jsonData["code"].int! == -302 {
                    print("用户身份异常，重新登录")
                    LoginViewController.showLoginVC()
                    LocalDataUtils.clearLoaclData()
                }else if jsonData["code"].int! == -101 {
                    ToastUtils.showErrorToast(msg: "您不具备首充资格，请刷新")
                }else {
                    ToastUtils.showErrorToast(msg: "错误:" + jsonData["msg"].stringValue)
                }
            }else{
                print("error:\(String(describing: response.error))")
            }
        }
    }
    
    func aliPayOrder(orderBody:String) -> () {
        AlipaySDK.defaultService().payOrder(orderBody, fromScheme: "alipay2017071707787463", callback: { (result) in
            /// 使用web支付会走到这里
            if let Alipayjson = result as NSDictionary?{
                let resultStatus = Alipayjson.value(forKey: "resultStatus") as! String
                if resultStatus == "9000"{
                    ToastUtils.showSuccessToast(msg: "支付成功")
                    self.paySuccessCallbackH5()
                }else if resultStatus == "8000" {
                    print("正在处理中")
                }else if resultStatus == "4000" {
                    print("订单支付失败");
                    ToastUtils.showErrorToast(msg: "支付失败")
                }else if resultStatus == "6001" {
                    print("用户中途取消")
                    ToastUtils.showErrorToast(msg: "支付取消")
                }else if resultStatus == "6002" {
                    print("网络连接出错")
                    ToastUtils.showErrorToast(msg: "网络出错")
                }
            }
        })
    }
    
    func paySuccessCallbackH5(){
//        self.jsContext.evaluateScript("pay.paySuccess();")
        webview.loadRequest(URLRequest(url: URL(string: "https://api.mz.meidaojia.com/html/market/pay.html")!))
    }
    
    @objc func showExchangeDialog() {
        self.jsContext.evaluateScript("pay.exchangeFunc();")
    }
    
    /// 显示或隐藏兑换码的按钮
    func hideShowExchangeBtn(){
        /// 获取版本号，来判断显不显示微信支付
        Alamofire.request(Constants.Network.GET_SYS_INFO_VERSION, method: .post, parameters: NetWorkUtils.createBaseParams()).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(data: response.data!)
                let infoDictionary = Bundle.main.infoDictionary!
                if let buildVersion = (infoDictionary["CFBundleVersion"] as? NSString)?.doubleValue {
                    if json["data"].doubleValue >= buildVersion {
                        print("正式")
                        self.exchangeButton.isHidden = false
                    }else{
                        print("提审")
                        self.exchangeButton.isHidden = true
                    }
                }else {
                    self.exchangeButton.isHidden = true
                }
            }else{
                /// 发生异常
                self.exchangeButton.isHidden = true
            }
        }
    }

}
