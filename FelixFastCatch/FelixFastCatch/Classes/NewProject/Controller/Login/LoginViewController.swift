//
//  LoginViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/23.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

/// 登录界面
class LoginViewController: UIViewController {

    /// 打开登录页面
    static func showLoginVC(vc:UIViewController){
        vc.present(LoginViewController(), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
    }

}
