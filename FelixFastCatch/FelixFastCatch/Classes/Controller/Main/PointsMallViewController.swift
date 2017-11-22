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
class PointsMallViewController: UIViewController , UIWebViewDelegate {

    /// 加载url
    var webview:UIWebView!
    
    var jsContext:JSContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        webview = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        webview.delegate = self
        view.addSubview(webview)
        
        self.jsContext = webview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        let model = pointsJsModel()
        model.vc = self
        
        self.jsContext.setObject(model, forKeyedSubscript: "miaozhuaApp" as NSCopying & NSObjectProtocol)
        self.jsContext.exceptionHandler = { (context, exception) in
            print("exception \(String(describing: exception))")
        }
        
        webview.loadRequest(URLRequest(url: URL(string: "http://47.92.72.158:9150/market/score.html")!))
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.jsContext = webview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        let model = pointsJsModel()
        model.vc = self
        
        self.jsContext.setObject(model, forKeyedSubscript: "miaozhuaApp" as NSCopying & NSObjectProtocol)
        self.jsContext.exceptionHandler = { (context, exception) in
            print("exception \(String(describing: exception))")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 隐藏当前页面的状态栏
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    deinit {
        print("points,deinit")
    }
    
}
