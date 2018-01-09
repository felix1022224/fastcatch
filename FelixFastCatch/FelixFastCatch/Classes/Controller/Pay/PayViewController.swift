//
//  PayViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/21.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

class PayViewController: UIViewController {

    /// 我的余额
    var myBalanceLabel:MainCustomerLabel = MainCustomerLabel()
    
    /// 我的余额背景
    var balanceBackgroundView = UIView()
    
    /// 根view
    var rootView:UIScrollView = UIScrollView()
    
    /// 用户状态的回调
    var userStatusCallback:(()->())!
    
    /// vip 模块
    var vipModel:UIView = UIView()
    
    /// svip 模块
    var svipModel:UIView = UIView()
    
    /// vip模块的标题
    var vipTitle:UIImageView = UIImageView()
    
    /// 兑换码的弹窗
    var exchangeCodeDialog:ExchangeCodeDialog!
    
    /// 支付列表
    var payTableView:UITableView = UITableView()
    
    /// 支付列表的数据
    var payListDataSource : [JSON] = [JSON]()
    
    /// 代币充值列表的标题
    let listTitle = UIImageView(image: UIImage(named: "代币充值标题"))
    
    /// 优惠券按钮
    let couponListLabel = MainCustomerLabel()
    
    /// 结算页面
    let settlementView : SettlementView = SettlementView(frame: UIScreen.main.bounds)
    
    let vipDialog = VIPDialog(frame: UIScreen.main.bounds)
    let svipDialog = SVIPDialog(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        vipDialog.createView()
        vipDialog.show()
    }

    
    
}



