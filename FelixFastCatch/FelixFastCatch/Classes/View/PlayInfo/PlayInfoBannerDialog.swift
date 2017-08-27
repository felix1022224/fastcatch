//
//  PlayInfoBannerDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/27.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class PlayInfoBannerDialog: BaseDialog {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var webview:UIWebView!
    
    override func createView() {
        createBackgroundImage(imageName: "抓中了背景")
        
        backgroundImage.frame.size = CGSize(width: 298, height: 366)
        backgroundImage.center = self.center
        
        createCloseBtn()
        
        webview = UIWebView()
        webview.frame.size = CGSize(width: backgroundImage.bounds.width * 0.8, height: backgroundImage.bounds.height * 0.8)
        webview.center = backgroundImage.center
        addSubview(webview)
        
        
        addDialogToWindow()
    }

    func showUrl(link:String) -> () {
        webview.loadRequest(URLRequest(url: URL(string: link)!))
        show()
    }
    
}
