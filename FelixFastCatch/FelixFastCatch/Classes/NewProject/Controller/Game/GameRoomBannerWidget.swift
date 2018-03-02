//
//  GameRoomBannerWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/26.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

extension GameRoomViewController{
    
    /// 创建banner的view
    func createBannerView() {
        bannerGroupView.frame = CGRect(x: 0, y: liveView.bounds.height + UIScreen.main.bounds.width * 0.7 - liveView.bounds.height * 0.15, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.6)
        rootView.addSubview(bannerGroupView)
        
        let titleGroupView = UIView()
        titleGroupView.frame = CGRect(x: 40, y: 0, width: UIScreen.main.bounds.width - 80, height: 50)
        bannerGroupView.addSubview(titleGroupView)
        
        let productInfoTitle = UILabel()
        productInfoTitle.text = "热门活动"
        productInfoTitle.font = UIFont.systemFont(ofSize: 14)
        productInfoTitle.sizeToFit()
        productInfoTitle.frame.origin = CGPoint(x: titleGroupView.bounds.width/2 - productInfoTitle.bounds.width/2, y: titleGroupView.bounds.height/2 - productInfoTitle.bounds.height/2)
        titleGroupView.addSubview(productInfoTitle)
        
        let leftLine = UIView()
        leftLine.backgroundColor = UIColor.init(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1.0)
        leftLine.frame = CGRect(x: 0, y: titleGroupView.bounds.height/2 - 0.5, width: titleGroupView.bounds.width / 3, height: 1)
        titleGroupView.addSubview(leftLine)
        
        let rightLine = UIView()
        rightLine.backgroundColor = UIColor.init(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1.0)
        rightLine.frame = CGRect(x: titleGroupView.bounds.width - leftLine.bounds.width, y: titleGroupView.bounds.height/2 - 0.5, width: titleGroupView.bounds.width / 3, height: 1)
        titleGroupView.addSubview(rightLine)
        
        let bannerView = UIImageView()
        bannerView.frame.size = CGSize.init(width: UIScreen.main.bounds.width - 80, height: (UIScreen.main.bounds.width - 80) * 0.4)
        bannerView.backgroundColor = UIColor.white
        bannerGroupView.addSubview(bannerView)
        
        bannerView.layer.cornerRadius = 10
        bannerView.layer.masksToBounds = true
        
        bannerView.frame.origin = CGPoint.init(x: 40, y: 50)
        
        bannerView.kf.setImage(with: URL.init(string: gameRoomData["activity"]["advertiseImg"].stringValue))
        
        bannerView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickActivityInfo))
        bannerView.addGestureRecognizer(tap)
    }
    
    /// 点击活动图
    @objc func clickActivityInfo() -> () {
        if  gameRoomData["activity"]["redirectType"].intValue == 1 {
            /// 跳转到网页
            let link = gameRoomData["activity"]["scheme"].stringValue
            // 跳转到网页
            if link == "" {
                return
            }
            let webVC = WebViewController()
            webVC.link = link
            webVC.shareTitle = gameRoomData["activity"]["shareTitle"].stringValue
            webVC.shareInfo = gameRoomData["activity"]["shareSubtitle"].stringValue
            webVC.thumbShareImage = gameRoomData["activity"]["shareImg"].stringValue
            webVC.actionTitle = gameRoomData["activity"]["shareTitle"].stringValue
            self.navigationController?.pushViewController(webVC, animated: true)
        }else if gameRoomData["activity"]["redirectType"].intValue == 3 {
            /// 打开站外链接
            //根据iOS系统版本，分别处理
            if let url = URL(string: gameRoomData["activity"]["scheme"].string!) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],completionHandler: {(success) in })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }else if gameRoomData["activity"]["redirectType"].intValue == 2{
            // 其他
            let link = Int(gameRoomData["activity"]["scheme"].stringValue)
            if link == -1 {
                if Constants.User.USER_ID == "" {
                    LoginViewController.showLoginVC()
                    return
                }
                PayWebViewController.showPayWebVC(isShowBack: true)
                return
            }
        }
    }
    
}
