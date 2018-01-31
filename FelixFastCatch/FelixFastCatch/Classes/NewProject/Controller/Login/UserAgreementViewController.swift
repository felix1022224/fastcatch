//
//  UserAgreementViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/25.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class UserAgreementViewController: BaseActionBarViewController {

    /// 加载url
    private var webview:UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actionTitleLabel.text = "秒抓APP用户协议"
        self.view.backgroundColor = UIColor.white
        
        webview = UIWebView(frame: CGRect(x: 0, y: headView.bounds.height + 1, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (headView.bounds.height) - 1))
        webview.backgroundColor = UIColor.white
        view.addSubview(webview)
        
        webview.loadRequest(URLRequest(url: URL(string: "https://meizhe.meidaojia.com/makeup/activity/activity_banner/view_816")!))
    }
}
