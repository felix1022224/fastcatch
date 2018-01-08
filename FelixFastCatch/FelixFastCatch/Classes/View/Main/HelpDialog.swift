//
//  HelpDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/9/3.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class HelpDialog: BaseDialog {
    
    private var link:String = "https://meizhe.meidaojia.com/makeup/activity/activity_banner/view_815"
    
    private var webview:UIWebView!
    
    override func createView() {
        createBackgroundImage(imageName: "商品详情背景")
        
        backgroundImage.frame.size = CGSize(width: 298, height: 366)
        backgroundImage.center = self.center
        
        // 关闭按钮
        closeBtn = UIButton(type: .custom)
        let closeImage = UIImage(named: "icon_close")
        closeBtn.setBackgroundImage(closeImage, for: .normal)
        closeBtn.frame = CGRect(x: self.bounds.width/2 + backgroundImage.bounds.width/2 - 18, y: self.bounds.height/2 - backgroundImage.bounds.height/2 - 5, width:27, height: 27)
        addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        webview = UIWebView()
        webview.frame.size = CGSize(width: backgroundImage.bounds.width * 0.85, height: backgroundImage.bounds.height * 0.88)
        webview.center = backgroundImage.center
        webview.layer.masksToBounds = true
        webview.isOpaque = false
        webview.backgroundColor = UIColor.clear
        webview.layer.cornerRadius = 5
        addSubview(webview)
        
        webview.loadRequest(URLRequest(url: URL(string: link)!))
        
        addDialogToWindow()
    }
    
    func createViewByLink(link:String) {
        self.link = link
        createView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hide()
    }

}
