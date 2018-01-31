//
//  QAWebViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/31.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class QAWebViewController: BaseActionBarViewController {

    /// 加载url
    var webview:UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionTitleLabel.text = "常见问题"
        
        webview = UIWebView(frame: CGRect(x: 0, y: headView.bounds.height + 1, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - headView.bounds.height))
        webview.backgroundColor = UIColor.white
        view.addSubview(webview)
        
        webview.loadRequest(URLRequest(url: URL(string: "https://meizhe.meidaojia.com/makeup/activity/activity_banner/view_815")!))
    }

}
