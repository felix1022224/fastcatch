//
//  PayVCRootWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/25.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension PayViewController {
    
    /// 装载我的余额
    func setupMyBalance() {
        myBalanceLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        myBalanceLabel.outTextColor = UIColor.white
        myBalanceLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        myBalanceLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 16)
        myBalanceLabel.text = "我的余额:"
        myBalanceLabel.sizeToFit()
        
        let balanceBackgroundWidth = myBalanceLabel.bounds.width * 1.2
        
        balanceBackgroundView.frame = CGRect(x: rootView.bounds.width / 2 - balanceBackgroundWidth / 2, y: 0, width: balanceBackgroundWidth, height: myBalanceLabel.bounds.height * 1.5)
        balanceBackgroundView.layer.cornerRadius = balanceBackgroundView.bounds.height/2
        balanceBackgroundView.layer.masksToBounds = true
        balanceBackgroundView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        
        balanceBackgroundView.addSubview(myBalanceLabel)
        
        rootView.addSubview(balanceBackgroundView)
        
        myBalanceLabel.frame.origin = CGPoint(x: balanceBackgroundView.bounds.width/2 - myBalanceLabel.bounds.width/2, y: balanceBackgroundView.bounds.height/2 - myBalanceLabel.bounds.height/2)
        
        updateMyBalance(myBalance: Constants.User.diamondsCount)
    }
    
    /// 更新我的余额
    func updateMyBalance(myBalance:Int) -> () {
        myBalanceLabel.text = "我的余额 : " + String(myBalance)
        myBalanceLabel.sizeToFit()
        let balanceBackgroundWidth = myBalanceLabel.bounds.width * 1.2
        balanceBackgroundView.frame = CGRect(x: rootView.bounds.width / 2 - balanceBackgroundWidth / 2, y: 15, width: balanceBackgroundWidth, height: myBalanceLabel.bounds.height * 1.5)
        balanceBackgroundView.layer.cornerRadius = balanceBackgroundView.bounds.height/2
        balanceBackgroundView.layer.masksToBounds = true
        myBalanceLabel.frame.origin = CGPoint(x: balanceBackgroundView.bounds.width/2 - myBalanceLabel.bounds.width/2, y: balanceBackgroundView.bounds.height/2 - myBalanceLabel.bounds.height/2)
    }
    
    /// 装载vip充值模块
    func setupVIPPayModel() -> () {
        vipTitle.image = UIImage(named: "VIP月卡标题")
        vipTitle.sizeToFit()
        vipTitle.frame.origin = CGPoint(x: 10, y: myBalanceLabel.bounds.height + 35)
        rootView.addSubview(vipTitle)
        
        let vipModelWidth = (UIScreen.main.bounds.width - 45) / 2
        
        /// 充值vip模块
        vipModel.frame = CGRect(x: 0, y: vipTitle.frame.origin.y + vipTitle.bounds.height + 10, width: vipModelWidth, height: vipModelWidth * 1.1)
        vipModel.layer.contents = UIImage(named: "VIP")?.cgImage
        rootView.addSubview(vipModel)
        
        vipButton.setBackgroundImage(UIImage(named: "VIP充值按钮"), for: .normal)
        vipButton.sizeToFit()
        rootView.addSubview(vipButton)
        
        vipButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(vipModel)
            make.bottom.equalTo(vipModel).offset(-25)
        }
        
        vipButton.addTarget(self, action: #selector(vipClick(sender:)), for: .touchUpInside)
        
        /// svip 模块
        svipModel.frame = CGRect(x: rootView.bounds.width - vipModelWidth, y: vipModel.frame.origin.y, width: vipModelWidth, height: vipModelWidth * 1.1)
        svipModel.layer.contents = UIImage(named: "SVIP")?.cgImage
        rootView.addSubview(svipModel)
        
        svipButton.setBackgroundImage(UIImage(named: "SVIP充值按钮"), for: .normal)
        svipButton.sizeToFit()
        rootView.addSubview(svipButton)
        
        svipButton.addTarget(self, action: #selector(vipClick(sender:)), for: .touchUpInside)
        
        svipButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(svipModel)
            make.bottom.equalTo(svipModel).offset(-25)
        }
        
        setupVIPListModel()
        
        /// 装载完所有内容之后，重新计算RootView的contentSize
        countRootViewHeight()
    }
    
    @objc func vipClick(sender:UIButton){
        if sender == vipButton {
            ///点击了vip
            vipDialog.vipCallback = {[weak self] in
                self?.settlementView.isVip = true
                self?.settlementView.vipRP = 100000
                self?.settlementView.vipNumber = 9.9
                self?.settlementView.updateInfo()
                self?.settlementView.show()
            }
            vipDialog.createView()
            vipDialog.show()
        }else{
            svipDialog.svipCallback = {[weak self] in
                self?.settlementView.isVip = true
                self?.settlementView.vipRP = 110000
                self?.settlementView.vipNumber = 19.9
                if Constants.User.vip == 100000 {
                    self?.settlementView.vipNumber = Double(Constants.User.vipDay) * 0.33
                }
                self?.settlementView.updateInfo()
                self?.settlementView.show()
            }
            svipDialog.createView()
            svipDialog.show()
        }
    }
    
    /// 装载vip档列表
    func setupVIPListModel() {
        listTitle.frame.origin = CGPoint(x: 10, y: vipModel.frame.origin.y + vipModel.bounds.height + 10)
        listTitle.sizeToFit()
        rootView.addSubview(listTitle)
        
        ///优惠券
        couponListLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 17)
        couponListLabel.outLineWidth = 2
        couponListLabel.outTextColor = UIColor.white
        couponListLabel.outLienTextColor = UIColor(red: 18/255.0, green: 70/255.0, blue: 66/255.0, alpha: 1.0)
        if Constants.User.userCouponNumber <= 0 {
            couponListLabel.text = "优惠券＞"
        }else{
            couponListLabel.text = "有\(Constants.User.userCouponNumber)张优惠券＞"
        }
        couponListLabel.sizeToFit()
        couponListLabel.frame = CGRect(x: rootView.bounds.width - couponListLabel.bounds.width - 10, y: listTitle.frame.origin.y - 2, width: couponListLabel.bounds.width, height: couponListLabel.bounds.height)
        rootView.addSubview(couponListLabel)
        
        couponListLabel.isUserInteractionEnabled = true
        
        let tapCouponGR = UITapGestureRecognizer(target: self, action: #selector(tapCoupon))
        couponListLabel.addGestureRecognizer(tapCouponGR)
        
        payTableView.separatorColor = UIColor.clear
        payTableView.backgroundColor = UIColor.clear
        payTableView.isScrollEnabled = false
        payTableView.rowHeight = (UIScreen.main.bounds.width - 40) * 0.3
        payTableView.frame = CGRect(x: 0, y: listTitle.frame.origin.y + listTitle.bounds.height + 10, width: rootView.bounds.width, height: UIScreen.main.bounds.height)
        payTableView.delegate = self
        payTableView.dataSource = self
        payTableView.register(PayListTableViewCell.self, forCellReuseIdentifier: "cellId")
        rootView.addSubview(payTableView)
        
        getPayListDataSource()
    }
    
    /// 点击优惠券
    @objc func tapCoupon() {
        self.navigationController?.pushViewController(CouponListViewController(), animated: true)
    }
    
    /// 计算rootview的高度
    func countRootViewHeight() {
        rootView.contentSize = CGSize(width: rootView.bounds.width, height: vipModel.frame.origin.y + vipModel.bounds.height + 10 + listTitle.bounds.height + 10 + payTableView.rowHeight * CGFloat(payListDataSource.count))
    }
}

extension PayViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payListDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? PayListTableViewCell
        
        cell?.gemTitle.text = payListDataSource[indexPath.row]["name"].stringValue
        cell?.gemInfo.text = payListDataSource[indexPath.row]["description"].stringValue
        cell?.payNumberLabel.text = payListDataSource[indexPath.row]["value"].stringValue
        
        if payListDataSource[indexPath.row]["status"].intValue == 0 {
            cell?.payBtn.setBackgroundImage(UIImage(named: "普通充值按钮"), for: .normal)
            
            cell?.gemInfo.isHidden = true
            
            cell?.gemTitle.snp.makeConstraints({ (make) in
                make.left.equalTo((cell?.gem)!).offset((cell?.gem.bounds.width)! + 10)
                make.centerY.equalTo((cell?.gem)!)
            })
        }else{
            cell?.payBtn.setBackgroundImage(UIImage(named: "新用户充值按钮"), for: .normal)
            
            cell?.gemInfo.isHidden = false
            
            cell?.gemTitle.snp.makeConstraints({ (make) in
                make.top.equalTo((cell?.gem)!)
                make.left.equalTo((cell?.gem)!).offset((cell?.gem.bounds.width)! + 10)
            })
        }
        
        cell?.payBtn.tag = indexPath.row
        
        cell?.payBtn.addTarget(self, action: #selector(showSettlementView(payBtn:)), for: .touchUpInside)
        
        return cell!
    }
    
    /// 更新当前页面
    func updateInfo() {
        UserTools.getUserInfo {[weak self] in
            self?.updateMyBalance(myBalance: Constants.User.diamondsCount)
            self?.getPayListDataSource()
            
            if Constants.User.userCouponNumber <= 0 {
                self?.couponListLabel.text = "优惠券＞"
            }else{
                self?.couponListLabel.text = "有\(Constants.User.userCouponNumber)张优惠券＞"
            }
            self?.couponListLabel.sizeToFit()
            self?.couponListLabel.frame.origin = CGPoint(x: (self?.rootView.bounds.width)! - (self?.couponListLabel.bounds.width)! - 10, y: (self?.couponListLabel.frame.origin.y)!)
        }
    }
    
    @objc func showSettlementView(payBtn:UIButton) {
        settlementView.dataSource = payListDataSource[payBtn.tag]
        settlementView.updateInfo()
        settlementView.show()
    }
    
    /// 从服务器获取支付列表
    func getPayListDataSource() {
        ToastUtils.showLoadingToast(msg: "正在获取支付列表")
        var params = NetWorkUtils.createBaseParams()
        params["status"] = "1"
        
        Alamofire.request(Constants.Network.GET_PAY_LIST, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                ToastUtils.hide()
                let json = JSON(data: response.data!)
                /// 获取数据成功，重新加载数据
                self.payListDataSource.removeAll()
                self.payListDataSource = json["data"].arrayValue
                self.payTableView.reloadData()
                self.countRootViewHeight()
            }else{
                ToastUtils.showErrorToast(msg: "获取套餐列表失败")
            }
        }
    }
    
}

