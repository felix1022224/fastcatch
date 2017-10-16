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
    func enterRoom(index:Int)
}

@objc class webJsModel: NSObject, webJsDelegate {
    
    var mainVC:MainViewController!

    var webVC:WebViewController!
    
    func payList() {
        let payListDialog = PayListDialog(frame: UIScreen.main.bounds)
        payListDialog.createView()
        payListDialog.show()
    }
    
    func enterRoom(index: Int) {
        print("213123123123:\(index)")
        if mainVC == nil {
            return
        }
        if mainVC.mainListData.count <= 0 {
            return
        }
        mainVC.itemClick(index: index)
        //        let playView =  mainVC.getPlayVC(index: index)
//        if playView == nil {
//            return
//        }
//        webVC.present(playView!, animated: true, completion: nil)
//        webVC.navigationController?.pushViewController(playView!, animated: true)
    }
    
}

class WebViewController: UIViewController, UIWebViewDelegate {

    var mainVC:MainViewController!
    
    /// 要跳转的url地址
    var link:String!
    
    /// 加载url
    private var webview:UIWebView!
    
    var actionTitle: String?
    
    lazy var actionTitleLabel = UILabel()
    
    var jsContext:JSContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
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
        
        let shardBtn = UIImageView(image: UIImage(named: "banner_more"))
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
        view.addSubview(webview)
        
        self.jsContext = webview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        let model = webJsModel()
        model.webVC = self
        if mainVC != nil {
            model.mainVC = mainVC
        }
        
        self.jsContext.setObject(model, forKeyedSubscript: "miaozhuaApp" as NSCopying & NSObjectProtocol)
        self.jsContext.exceptionHandler = { (context, exception) in
            print("exception \(exception)")
        }
        
//        let curUrl = webview.request?.URL?.absoluteString    //WebView当前访问页面的链接 可动态注册
//        self.jsContext.evaluateScript(try? String(contentsOfURL: NSURL(string: curUrl!)!, encoding: NSUTF8StringEncoding))
//
//        self.jsContext.exceptionHandler = { (context, exception) in
//            print("exception：", exception)
//        }
        
        webview.loadRequest(URLRequest(url: URL(string: link)!))
        
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
        sharedView.show()
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
