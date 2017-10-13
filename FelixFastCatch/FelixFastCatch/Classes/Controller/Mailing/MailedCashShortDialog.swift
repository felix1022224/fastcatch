//
//  MailedCashShortDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

/// 邮费不足
class MailedCashShortDialog: BaseDialog {

    override func createView() {
        createBackgroundImage(imageName: "邮费不足背景")
        backgroundImage.center = self.center
        
        let cashShortLabel = MainCustomerLabel()
        
        cashShortLabel.text = "代币不足"
        cashShortLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        cashShortLabel.outTextColor = UIColor.white
        cashShortLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        cashShortLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(20))
        cashShortLabel.sizeToFit()
        cashShortLabel.center = backgroundImage.center
        addSubview(cashShortLabel)
        
        let goPayBtn = UIButton(type: UIButtonType.custom)
        goPayBtn.setBackgroundImage(UIImage(named: "去充值按钮"), for: .normal)
        goPayBtn.sizeToFit()
        addSubview(goPayBtn)
        
        goPayBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImage).offset(goPayBtn.bounds.height/2)
            make.centerX.equalTo(backgroundImage)
        }
        
        goPayBtn.addTarget(self, action: #selector(showPayDialog), for: .touchUpInside)
        
        addDialogToWindow()
    }
    
    @objc func showPayDialog() -> () {
        let payDialog = PayListDialog(frame: UIScreen.main.bounds)
        payDialog.createView()
        payDialog.show()
        hide()
    }

}
