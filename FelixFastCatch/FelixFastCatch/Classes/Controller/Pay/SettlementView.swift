//
//  SettlementView.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/9.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// 支付结算页面
class SettlementView: UIView {

    /// 底部view
    var bottomView:UIView = UIView()
    
    let backgroundView = UIView(frame: UIScreen.main.bounds)
    
    /// 选择优惠券的label
    let selectCouponLabel = UILabel()
    
    let wechatButton = UIButton(type: UIButtonType.custom)
    
    let alipayButton = UIButton(type: UIButtonType.custom)
    
    /// 支付方式 0是微信，1是支付宝
    var payType = 0
    
    /// 优惠后的
    let afterDiscountLabel = UILabel()
    
    /// 优惠前的原价
    let originalLabel = UILabel()
    
    /// 支付的数据
    var dataSource:JSON!
    
    /// 优惠券
    var discountNumber:Float = -1
    
    var vc:PayViewController!
    
    /// 优惠券ID
    var couponId = ""
    
    /// 是否是充值vip
    var isVip = false
    
    var vipNumber = 0.0
    
    var vipRP = 0
    
    var aid = -1
    
    /// 支付成功的回调，用于游戏界面0元抓
    var successCallback:(()->())!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// 设置背景颜色
        backgroundView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        self.addSubview(backgroundView)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(hide))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(backTap)
        
        bottomView.backgroundColor = UIColor.white
        bottomView.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.height * 0.7)
        bottomView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3)
        self.addSubview(bottomView)
        
        /// dialog标题
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        titleLabel.text = "请选择支付方式:"
        titleLabel.sizeToFit()
        titleLabel.frame.origin = CGPoint(x: 20, y: 20)
        self.bottomView.addSubview(titleLabel)
        
        ///优惠券
        selectCouponLabel.font = UIFont.systemFont(ofSize: 14)
        selectCouponLabel.text = "优惠券 >"
        selectCouponLabel.sizeToFit()
        self.bottomView.addSubview(selectCouponLabel)
        
        selectCouponLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.bottomView).offset(-20)
            make.centerY.equalTo(titleLabel)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectCoupon))
        selectCouponLabel.isUserInteractionEnabled = true
        selectCouponLabel.addGestureRecognizer(tap)
        
        /// 微信
        wechatButton.setBackgroundImage(UIImage(named: "微信支付"), for: .normal)
        wechatButton.setBackgroundImage(UIImage(named: "微信支付选中"), for: .disabled)
        wechatButton.sizeToFit()
        self.bottomView.addSubview(wechatButton)
        
        wechatButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomView)
            make.centerX.equalTo(bottomView).offset(-wechatButton.bounds.width * 1.5)
        }
        
        wechatButton.addTarget(self, action: #selector(payButtonClick(button:)), for: .touchUpInside)
        
        /// 支付宝
        alipayButton.setBackgroundImage(UIImage(named: "支付宝支付"), for: .normal)
        alipayButton.setBackgroundImage(UIImage(named: "支付宝支付选中"), for: .disabled)
        alipayButton.sizeToFit()
        self.bottomView.addSubview(alipayButton)
        
        alipayButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomView)
            make.centerX.equalTo(bottomView).offset(alipayButton.bounds.width * 1.5)
        }
        
        alipayButton.addTarget(self, action: #selector(payButtonClick(button:)), for: .touchUpInside)
        
        /// 去支付按钮
        let payButton = UIButton(type: UIButtonType.custom)
        payButton.setBackgroundImage(UIImage(named: "去支付"), for: .normal)
        self.bottomView.addSubview(payButton)
        
        payButton.snp.makeConstraints { (make) in
            make.right.equalTo(selectCouponLabel)
            make.bottom.equalTo(bottomView).offset(-20)
        }
        
        payButton.addTarget(self, action: #selector(pay), for: .touchUpInside)
        
        /// 优惠后的价格
        afterDiscountLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        afterDiscountLabel.text = "10元"
        afterDiscountLabel.textColor = UIColor.red
        afterDiscountLabel.sizeToFit()
        self.bottomView.addSubview(afterDiscountLabel)
        
        afterDiscountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.centerY.equalTo(payButton)
        }
        
        /// 原价
        let priceString = NSMutableAttributedString.init(string: "100元")
        priceString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: priceString.length))
        originalLabel.font = UIFont.systemFont(ofSize: 14)
        originalLabel.attributedText = priceString
        originalLabel.textColor = UIColor.gray
        originalLabel.sizeToFit()
        self.bottomView.addSubview(originalLabel)
        
        originalLabel.frame.origin = CGPoint(x: 20 + afterDiscountLabel.bounds.width + 10, y: 0)
        originalLabel.center.y = afterDiscountLabel.center.y
        
//        originalLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(afterDiscountLabel).offset(afterDiscountLabel.bounds.width*1.5 + 10)
//            make.bottom.equalTo(afterDiscountLabel).offset(-1)
//        }
        
        backgroundView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        bottomView.frame.origin.y = UIScreen.main.bounds.height
        isHidden = true
        
        switchPayType(payType: 0)
        
        if isVip {
            selectCouponLabel.isHidden = true
            afterDiscountLabel.text = String(vipNumber) + "元"
        }else{
            selectCouponLabel.isHidden = false
        }
        
    }
    
    /// 前往选择优惠券
    @objc func selectCoupon(){
        if vc != nil {
            let couponListVC = CouponListViewController()
            couponListVC.selectCallback = { [weak self] (result) in
                self?.discountNumber = result["discount"].floatValue
                self?.couponId = result["id"].stringValue
                self?.updateInfo()
            }
            couponListVC.isSelectCoupon = true
            vc.navigationController?.pushViewController(couponListVC, animated: true)
        }
    }
    
    /// 更新信息
    func updateInfo() {
        if  isVip {
            selectCouponLabel.isHidden = true
            afterDiscountLabel.text = String(vipNumber) + "元"
            originalLabel.isHidden = true
        }else{
            selectCouponLabel.isHidden = false
            if discountNumber == -1 {
                selectCouponLabel.text = "优惠券 >"
                originalLabel.isHidden = true
                afterDiscountLabel.text = dataSource["value"].stringValue + "元"
            }else{
                selectCouponLabel.text = String(discountNumber) + "折 >"
                originalLabel.isHidden = false
                let afterDiscountNumber = String(dataSource["value"].floatValue * (discountNumber / 10))
                afterDiscountLabel.text = afterDiscountNumber + "元"
                afterDiscountLabel.sizeToFit()
                let priceString = NSMutableAttributedString.init(string: dataSource["value"].stringValue + "元")
                priceString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: priceString.length))
                originalLabel.attributedText = priceString
                originalLabel.sizeToFit()
                
                originalLabel.frame.origin = CGPoint(x: 20 + afterDiscountLabel.bounds.width + 10, y: 0)
                originalLabel.center.y = afterDiscountLabel.center.y
            }
        }
    }
    
    @objc func payButtonClick(button:UIButton){
        if button == wechatButton {
            switchPayType(payType: 0)
        }else if button == alipayButton {
            switchPayType(payType: 1)
        }
    }
    
    /// 切换支付方式
    func switchPayType(payType:Int) {
        if payType == 0 {
            self.wechatButton.isEnabled = false
            self.alipayButton.isEnabled = true
        }else{
            self.wechatButton.isEnabled = true
            self.alipayButton.isEnabled = false
        }
        self.payType = payType
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.backgroundView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
            self?.bottomView.frame.origin.y = UIScreen.main.bounds.height
        }) { [weak self] (isEnd) in
            self?.isHidden = true
        }
        discountNumber = -1
        couponId = ""
        payType = 0
        
        switchPayType(payType: 0)
        
        isVip = false
        vipRP = -1
        vipNumber = 0.0
        aid = -1
    }
    
    func show() {
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.backgroundView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
            self?.bottomView.frame.origin.y = UIScreen.main.bounds.height * 0.7
            self?.isHidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pay(){
        if payType == 0 {
            if isVip {
                wechatPay(rp: vipRP)
            }else{
                wechatPay(rp: dataSource["id"].intValue)
            }
        }else if payType == 1 {
            if isVip {
                aliPay(rp: vipRP)
            }else{
                aliPay(rp: dataSource["id"].intValue)
            }
        }
    }
    
    /// 微信支付
    func wechatPay(rp:Int) -> () {
        if WeChatShared.isInstall() == false {
            ToastUtils.showErrorToast(msg: "暂时无法支付")
            return
        }
        
        ToastUtils.showLoadingToast(msg: "正在下单")
        var params = NetWorkUtils.createBaseParams()
        params["rp"] = String(rp)
        if couponId != "" {
            params["cid"] = couponId
        }
        
        if aid != -1 {
            params["aid"] = String(aid)
            params["rp"] = "-10"
        }
        
        Alamofire.request(Constants.Network.WECHAT_PAY_URL, method: .post, parameters: params).responseJSON { (response) in
            ToastUtils.hide()
            if response.error == nil && response.data != nil {
                let jsonData = JSON(data: response.data!)
                print("jsonData:\(jsonData)")
                if jsonData["code"].int! == 0 {
                    WeChatShared.pay(to: "main", jsonData["data"], resultHandle: { (result, identifier) in
                        switch(result){
                        case .Success:
                            if self.aid != -1 {
                                ToastUtils.showSuccessToast(msg: "购买成功，请到奖品中查看")
                            }else{
                                ToastUtils.showSuccessToast(msg: "支付成功")
                            }
                            self.hide()
                            if self.vc != nil {
                                self.vc.updateInfo()
                                if self.vc.userStatusCallback != nil {
                                    self.vc.userStatusCallback!()
                                }
                            }
                            if self.successCallback != nil {
                                self.successCallback!()
                            }
                            break;
                        case .Failed:
                            ToastUtils.showErrorToast(msg: "支付失败")
                            break;
                        case .Cancel:
                            ToastUtils.showInfoToast(msg: "取消支付")
                            break;
                        }
                    })
                }else if jsonData["code"].int! == -302 {
                    print("用户身份异常，重新登录")
                    if !Constants.isFastLoginShow {
                        let loginDialog = FastLoginDialog(frame: UIScreen.main.bounds)
                        loginDialog.createView()
                        loginDialog.show()
                    }
                    LocalDataUtils.clearLoaclData()
                }else if jsonData["code"].int! == -101 {
                    ToastUtils.showErrorToast(msg: "您不具备首充资格，请刷新")
                }
            }else{
                
            }
        }
    }
    
    func aliPay(rp:Int) -> () {
        ToastUtils.showLoadingToast(msg: "正在下单……")
        var params = NetWorkUtils.createBaseParams()
        params["rp"] = String(rp)
        
        if couponId != "" {
            params["cid"] = couponId
        }
        
        if aid != -1 {
            params["aid"] = String(aid)
            params["rp"] = "-10"
        }
        
        Alamofire.request(Constants.Network.ALIPAY_URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            ToastUtils.hide()
            if response.error == nil && response.data != nil {
                let jsonData = JSON(data: response.data!)
                print("jsonData:\(jsonData)")
                if jsonData["code"].int! == 0 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { [weak self] in
                        self?.aliPayOrder(orderBody: jsonData["data"]["orderBody"].string!)
                    })
                }else if jsonData["code"].int! == -302 {
                    print("用户身份异常，重新登录")
                    if !Constants.isFastLoginShow {
                        let loginDialog = FastLoginDialog(frame: UIScreen.main.bounds)
                        loginDialog.createView()
                        loginDialog.show()
                    }
                    LocalDataUtils.clearLoaclData()
                }else if jsonData["code"].int! == -101 {
                    ToastUtils.showErrorToast(msg: "您不具备首充资格，请刷新")
                }
            }else{
                print("error:\(String(describing: response.error))")
            }
        }
    }
    
    func aliPayOrder(orderBody:String) -> () {
        AlipaySDK.defaultService().payOrder(orderBody, fromScheme: "alipay2017071707787463", callback: { (result) in
            /// 使用web支付会走到这里
            if let Alipayjson = result as NSDictionary?{
                let resultStatus = Alipayjson.value(forKey: "resultStatus") as! String
                if resultStatus == "9000"{
                    if self.aid != -1 {
                        ToastUtils.showSuccessToast(msg: "购买成功，请到奖品中查看")
                    }else{
                        ToastUtils.showSuccessToast(msg: "支付成功")
                    }
                    self.hide()
                    if self.vc != nil {
                        self.vc.updateInfo()
                        if self.vc.userStatusCallback != nil {
                            self.vc.userStatusCallback!()
                        }
                    }
                    if self.successCallback != nil {
                        self.successCallback!()
                    }
                }else if resultStatus == "8000" {
                    print("正在处理中")
                }else if resultStatus == "4000" {
                    print("订单支付失败");
                    ToastUtils.showErrorToast(msg: "支付失败")
                }else if resultStatus == "6001" {
                    print("用户中途取消")
                    ToastUtils.showErrorToast(msg: "支付取消")
                }else if resultStatus == "6002" {
                    print("网络连接出错")
                    ToastUtils.showErrorToast(msg: "网络出错")
                }
            }
        })
    }

}
