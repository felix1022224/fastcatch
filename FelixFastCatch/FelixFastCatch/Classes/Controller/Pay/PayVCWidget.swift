//
//  PayVCWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/25.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension PayViewController {
    
    /// 装载UI
    func setupUI() {
        ///设置背景
        setBackgroundImage(rootView: view, imgName: "邮寄背景")
        
        setupTopGroup()
        
        rootView.frame = CGRect(x: 20, y: UIApplication.shared.statusBarFrame.height + Constants.UI.TITLE_IMAGE_HEIGHT, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.height - Constants.UI.TITLE_IMAGE_HEIGHT)
        rootView.showsVerticalScrollIndicator = false
        self.view.addSubview(rootView)
        
        setupMyBalance()
        
        setupVIPPayModel()
        
        setupVIPListModel()
        
        settlementView.vc = self
        /// 把支付界面添加到根布局
        self.view.addSubview(settlementView)
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
        
        exchangeBtn.isHidden = true
        hideShowExchangeBtn(exchangeBtn: exchangeBtn)
        
        backBtn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        exchangeBtn.addTarget(self, action: #selector(showExchangeDialog), for: .touchUpInside)
        
    }
    
    /// 关闭页面
    @objc func closeVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 显示兑换码弹窗
    @objc func showExchangeDialog() -> () {
        if exchangeCodeDialog == nil {
            exchangeCodeDialog = ExchangeCodeDialog(frame: UIScreen.main.bounds)
        }
        exchangeCodeDialog.successCallback = {
            UserTools.getUserInfo(callback: { [weak self] in
                /// 如果兑换成功，更新余额
                self?.updateMyBalance(myBalance: Constants.User.diamondsCount)
            })
        }
        exchangeCodeDialog.createView()
        exchangeCodeDialog.show()
    }
    
    /// 显示或隐藏兑换码的按钮
    func hideShowExchangeBtn(exchangeBtn:UIButton){
        /// 获取版本号，来判断显不显示微信支付
        Alamofire.request(Constants.Network.GET_SYS_INFO_VERSION, method: .post, parameters: NetWorkUtils.createBaseParams()).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(data: response.data!)
                let infoDictionary = Bundle.main.infoDictionary!
                if let buildVersion = (infoDictionary["CFBundleVersion"] as? NSString)?.doubleValue {
                    if json["data"].doubleValue >= buildVersion {
                        print("正式")
                        exchangeBtn.isHidden = false
                    }else{
                        print("提审")
                        exchangeBtn.isHidden = true
                    }
                }else {
                    exchangeBtn.isHidden = true
                }
            }else{
                /// 发生异常
                exchangeBtn.isHidden = true
            }
        }
    }
    
}
