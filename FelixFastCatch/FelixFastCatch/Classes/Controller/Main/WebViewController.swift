//
//  WebViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/26.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    /// 要跳转的url地址
    var link:String!
    
    /// 加载url
    private var webview:UIWebView!
    
    var actionTitle: String?
    
    lazy var actionTitleLabel = UILabel()
    
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

    func back() -> () {
        dismiss(animated: true, completion: nil)
    }
    
    func shared() -> () {
        WeChatShared.shareURL(link, title: actionTitle, description: actionTitle, thumbImg: UIImage(named: "shared_logo"), to: LDWechatScene.Timeline) { (isSuccess, info) in
            if isSuccess {
                ToastUtils.showSuccessToast(msg: "分享成功")
            }else{
                ToastUtils.showErrorToast(msg: "分享失败")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
