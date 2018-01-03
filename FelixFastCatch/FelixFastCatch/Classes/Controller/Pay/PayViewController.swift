//
//  PayViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/21.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class PayViewController: UIViewController {

    /// 我的余额
    var myBalanceLabel:MainCustomerLabel = MainCustomerLabel()
    
    /// 我的余额背景
    lazy var balanceBackgroundView = UIView()
    
    /// 根view
    lazy var rootView:UIView = UIView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}



