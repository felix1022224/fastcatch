//
//  PayVCRootWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/25.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

extension PayViewController {
    
    /// 装载我的余额
    func setupMyBalance() {
        myBalanceLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        myBalanceLabel.outTextColor = UIColor.white
        myBalanceLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        myBalanceLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 16)
        myBalanceLabel.text = "我的余额 : " + String(Constants.User.diamondsCount)
        myBalanceLabel.sizeToFit()
        
        let balanceBackgroundWidth = myBalanceLabel.bounds.width * 1.2
        
        balanceBackgroundView.frame = CGRect(x: UIScreen.main.bounds.width / 2 - balanceBackgroundWidth / 2, y: 15, width: balanceBackgroundWidth, height: myBalanceLabel.bounds.height * 1.5)
        balanceBackgroundView.layer.cornerRadius = balanceBackgroundView.bounds.height/2
        balanceBackgroundView.layer.masksToBounds = true
        balanceBackgroundView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        rootView.addSubview(balanceBackgroundView)
        
        myBalanceLabel.center = balanceBackgroundView.center
        rootView.addSubview(myBalanceLabel)
    }
    
    /// 更新我的余额
    func updateMyBalance(myBalance:Int) -> () {
        myBalanceLabel.text = "我的余额 : " + String(myBalance)
        myBalanceLabel.sizeToFit()
        let balanceBackgroundWidth = myBalanceLabel.bounds.width * 1.2
        balanceBackgroundView.frame = CGRect(x: UIScreen.main.bounds.width / 2 - balanceBackgroundWidth / 2, y: 15, width: balanceBackgroundWidth, height: myBalanceLabel.bounds.height * 1.5)
        
    }
    
}
