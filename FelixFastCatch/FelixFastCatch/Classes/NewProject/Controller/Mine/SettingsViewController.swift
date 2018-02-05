//
//  SettingsViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/31.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import Alamofire

/// 设置页面
class SettingsViewController: BaseActionBarViewController {
    
    /// 退出登录的callback
    var logoutCallback:(()->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actionTitleLabel.text = "设置"
        
        let centerGroupView = UIView.init()
        centerGroupView.backgroundColor = UIColor.white
        
        let qaGroupView = UIView.init()
        qaGroupView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        centerGroupView.addSubview(qaGroupView)
        
        let qaLabel = UILabel.init()
        qaLabel.text = "常见问题"
        qaLabel.font = UIFont.systemFont(ofSize: 16)
        qaLabel.sizeToFit()
        qaLabel.frame.origin = CGPoint.init(x: 15, y: qaGroupView.bounds.height/2 - qaLabel.bounds.height/2)
        qaGroupView.addSubview(qaLabel)
        
        let arrowIcon = UIImageView()
        arrowIcon.image = UIImage.init(named: "我的item箭头")
        arrowIcon.sizeToFit()
        arrowIcon.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 15 - arrowIcon.bounds.width, y: qaGroupView.bounds.height/2 - arrowIcon.bounds.height/2)
        qaGroupView.addSubview(arrowIcon)
        
        let lineView = UIView.init()
        lineView.frame = CGRect.init(x: UIScreen.main.bounds.width * 0.05, y: 50, width: UIScreen.main.bounds.width * 0.9, height: 1)
        lineView.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        centerGroupView.addSubview(lineView)
        
        let uaGroupView = UIView.init()
        uaGroupView.frame = CGRect.init(x: 0, y: 51, width: UIScreen.main.bounds.width, height: 50)
        centerGroupView.addSubview(uaGroupView)
        
        let uaLabel = UILabel.init()
        uaLabel.text = "用户协议"
        uaLabel.font = UIFont.systemFont(ofSize: 16)
        uaLabel.sizeToFit()
        uaLabel.frame.origin = CGPoint.init(x: 15, y: uaGroupView.bounds.height/2 - qaLabel.bounds.height/2)
        uaGroupView.addSubview(uaLabel)
        
        let arrowIcon2 = UIImageView()
        arrowIcon2.image = UIImage.init(named: "我的item箭头")
        arrowIcon2.sizeToFit()
        arrowIcon2.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 15 - arrowIcon.bounds.width, y: uaGroupView.bounds.height/2 - arrowIcon2.bounds.height/2)
        uaGroupView.addSubview(arrowIcon2)
        
        centerGroupView.frame = CGRect.init(x: 0, y: 5 + headView.bounds.height, width: UIScreen.main.bounds.width, height: 51 * 2)
        view.addSubview(centerGroupView)
        
        let clickQa = UITapGestureRecognizer.init(target: self, action: #selector(onClickQA))
        qaGroupView.isUserInteractionEnabled = true
        qaGroupView.addGestureRecognizer(clickQa)
        
        let clickUA = UITapGestureRecognizer.init(target: self, action: #selector(onClickUA))
        uaGroupView.isUserInteractionEnabled = true
        uaGroupView.addGestureRecognizer(clickUA)
        
        let logoutButton = UIButton.init(type: UIButtonType.custom)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        logoutButton.setBackgroundImage(UIImage.init(named: "退出登录背景"), for: UIControlState.normal)
        logoutButton.setTitle("退出登录", for: UIControlState.normal)
        logoutButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        logoutButton.sizeToFit()
        logoutButton.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width/2 - logoutButton.bounds.width/2, y: centerGroupView.bounds.height + 30 + centerGroupView.frame.origin.y)
        view.addSubview(logoutButton)
        
        logoutButton.addTarget(self, action: #selector(logout), for: UIControlEvents.touchUpInside)
    }
    
    /// 退出登录
    @objc func logout() {
        LocalDataUtils.clearLoaclData()
        self.navigationController?.popViewController(animated: true)
        
        if self.logoutCallback != nil {
            self.logoutCallback!()
        }
        
//        Alamofire.request(Constants.Network.User.LOGOUT_URL, method: .post, parameters: NetWorkUtils.createBaseParams()).responseJSON { (response) in
//        }
    }
    
    /// 点击用户协议
    @objc func onClickUA() {
        self.navigationController?.pushViewController(UserAgreementViewController(), animated: true)
    }
    
    /// 点击常见问题
    @objc func onClickQA() {
        self.navigationController?.pushViewController(QAWebViewController(), animated: true)
    }

}
