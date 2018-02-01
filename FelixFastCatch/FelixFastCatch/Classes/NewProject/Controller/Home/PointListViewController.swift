//
//  PointListViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/2/1.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class PointListViewController: BaseActionBarViewController {

    /// 加载url
    private var webview:UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actionTitleLabel.text = "积分记录"
        
        webview = UIWebView(frame: CGRect(x: 0, y: headView.bounds.height + 1, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (headView.bounds.height) - 1))
        webview.backgroundColor = UIColor.white
        view.addSubview(webview)
        
        webview.loadRequest(URLRequest(url: URL(string: "https://api.mz.meidaojia.com/html/market/record.html")!))
    }

}
