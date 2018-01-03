//
//  PayVCWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/25.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

extension PayViewController {
    
    /// 装载UI
    func setupUI() {
        ///设置背景
        setBackgroundImage(rootView: view, imgName: "邮寄背景")
        
        setupTopGroup()
        
        rootView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + Constants.UI.TITLE_IMAGE_HEIGHT, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.height - Constants.UI.TITLE_IMAGE_HEIGHT)
        self.view.addSubview(rootView)
        
        setupMyBalance()
    }
    
    /// 装载顶部的UI
    func setupTopGroup() -> () {
        /// 顶部标题
        let topTitile = UIImageView(image: UIImage(named: "充值顶部"))
        view.addSubview(topTitile)
        
        topTitile.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(UIApplication.shared.statusBarFrame.height)
            make.width.equalTo(Constants.UI.TITLE_IMAGE_WIDTH)
            make.height.equalTo(Constants.UI.TITLE_IMAGE_HEIGHT)
        }
        
        /// 返回按钮
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "邮寄返回"), for: .normal)
        backBtn.sizeToFit()
        view.addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(14)
            make.centerY.equalTo(topTitile)
        }
        
        /// 兑换码
        let exchangeBtn = UIButton(type: UIButtonType.custom)
        exchangeBtn.setBackgroundImage(UIImage(named: "兑换码"), for: .normal)
        exchangeBtn.sizeToFit()
        view.addSubview(exchangeBtn)
        
        exchangeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(topTitile)
            make.right.equalTo(view).offset(-14)
            make.width.equalTo(exchangeBtn.bounds.width * 0.9)
            make.height.equalTo(exchangeBtn.bounds.height * 0.9)
        }
        
        backBtn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
    }
    
    /// 关闭页面
    @objc func closeVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
