//
//  CouponListViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/4.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

/// 优惠券列表
class CouponListViewController: UIViewController {

    /// 是否来选择优惠券
    var isSelectCoupon:Bool = false
    
    /// 优惠券列表
    var couponList:UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    ///  装载UI
    func setupUI() {
        
    }

}
