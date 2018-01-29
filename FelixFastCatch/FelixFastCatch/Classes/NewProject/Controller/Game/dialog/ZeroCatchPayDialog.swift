//
//  ZeroCatchPayDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/29.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// 0元抓购买的弹窗
class ZeroCatchPayDialog: UIView {

    var keyWindow:UIWindow!
    
    // 背景透明色
    var shadow:UIControl!
    
    /// 根布局
    var rootView = UIView()
    
    var payType = 0
    
    var dataSource:JSON!
    
    let selectedAliPayBtn = UIButton.init(type: UIButtonType.custom)
    let selectedWechatPayBtn = UIButton.init(type: UIButtonType.custom)
    let payButton = UIButton.init(type: UIButtonType.custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        keyWindow = UIApplication.shared.keyWindow
    }
    
    func createView() {
        rootView.backgroundColor = UIColor.white
        rootView.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4)
        addSubview(rootView)
        rootView.corner(byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], radii: 20)
        
        let closeBtn = UIButton.init(type: UIButtonType.custom)
        closeBtn.setBackgroundImage(UIImage.init(named: "关闭"), for: UIControlState.normal)
        closeBtn.sizeToFit()
        closeBtn.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - closeBtn.bounds.width - 10, y: 10)
        rootView.addSubview(closeBtn)
        
        closeBtn.addTarget(self, action: #selector(hide), for: UIControlEvents.touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.text = "请选择支付方式"
        titleLabel.sizeToFit()
        titleLabel.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width/2 - titleLabel.bounds.width/2, y: 35)
        rootView.addSubview(titleLabel)
        
        /// 微信支付
        let wechatPayIcon = UIImageView(image: UIImage.init(named: "0元抓微信支付"))
        wechatPayIcon.sizeToFit()
        wechatPayIcon.frame.origin = CGPoint.init(x: 15, y: titleLabel.frame.origin.y + titleLabel.bounds.height + 25)
        rootView.addSubview(wechatPayIcon)
        
        let wechatPayLabel = UILabel()
        wechatPayLabel.font = UIFont.systemFont(ofSize: 14)
        wechatPayLabel.text = "微信支付"
        wechatPayLabel.sizeToFit()
        wechatPayLabel.frame.origin = CGPoint.init(x: 15 + wechatPayIcon.bounds.width + 15, y: wechatPayIcon.frame.origin.y + (wechatPayIcon.bounds.height/2 - wechatPayLabel.bounds.height/2))
        rootView.addSubview(wechatPayLabel)
        
        selectedWechatPayBtn.setImage(UIImage.init(named: "未选择支付"), for: UIControlState.normal)
        selectedWechatPayBtn.setImage(UIImage.init(named: "选择支付"), for: UIControlState.selected)
        selectedWechatPayBtn.sizeToFit()
        selectedWechatPayBtn.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - selectedWechatPayBtn.bounds.width - 15, y: wechatPayIcon.frame.origin.y + (wechatPayIcon.bounds.height/2 - selectedWechatPayBtn.bounds.height/2))
        rootView.addSubview(selectedWechatPayBtn)
        
        let lineView = UIView()
        lineView.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 0.5)
        lineView.backgroundColor = UIColor.gray
        lineView.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width * 0.05, y: wechatPayIcon.frame.origin.y + wechatPayIcon.bounds.height + 25)
        rootView.addSubview(lineView)
        
        /// 支付宝
        let aliPayIcon = UIImageView(image: UIImage.init(named: "0元抓支付宝支付"))
        aliPayIcon.sizeToFit()
        aliPayIcon.frame.origin = CGPoint.init(x: 15, y: lineView.frame.origin.y + lineView.bounds.height + 25)
        rootView.addSubview(aliPayIcon)
        
        let aliPayLabel = UILabel()
        aliPayLabel.font = UIFont.systemFont(ofSize: 14)
        aliPayLabel.text = "支付宝支付"
        aliPayLabel.sizeToFit()
        aliPayLabel.frame.origin = CGPoint.init(x: 15 + aliPayIcon.bounds.width + 15, y: aliPayIcon.frame.origin.y + (aliPayIcon.bounds.height/2 - aliPayLabel.bounds.height/2))
        rootView.addSubview(aliPayLabel)
        
        selectedAliPayBtn.setImage(UIImage.init(named: "未选择支付"), for: UIControlState.normal)
        selectedAliPayBtn.setImage(UIImage.init(named: "选择支付"), for: UIControlState.selected)
        selectedAliPayBtn.sizeToFit()
        selectedAliPayBtn.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - selectedAliPayBtn.bounds.width - 15, y: aliPayIcon.frame.origin.y + (aliPayIcon.bounds.height/2 - selectedAliPayBtn.bounds.height/2))
        rootView.addSubview(selectedAliPayBtn)
        
        /// payButton
        payButton.setBackgroundImage(UIImage.init(named: "确认支付"), for: UIControlState.normal)
        payButton.sizeToFit()
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rootView.addSubview(payButton)
        
        let attrText = NSMutableAttributedString.init(string: "确认支付 ￥\(dataSource["buyPrice"].doubleValue)")
        attrText.addAttribute(NSAttributedStringKey.font, value: UIFont.getCustomeYuanTiFont(fontSize: 16), range: NSRange(location: 5, length:String(dataSource["buyPrice"].doubleValue).count + 1))
        payButton.setAttributedTitle(attrText, for: UIControlState.normal)
        
        payButton.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width/2 - payButton.bounds.width/2, y: rootView.bounds.height - payButton.bounds.height - 40)
        
        selectedWechatPayBtn.isSelected = true
        payType = 0
        
        selectedAliPayBtn.addTarget(self, action: #selector(switchPayType), for: UIControlEvents.touchUpInside)
        selectedWechatPayBtn.addTarget(self, action: #selector(switchPayType), for: UIControlEvents.touchUpInside)
        payButton.addTarget(self, action: #selector(pay), for: UIControlEvents.touchUpInside)
        
        addDialogToWindow()
    }
    
    @objc func switchPayType() {
        if payType == 0 {
            payType = 1
            selectedWechatPayBtn.isSelected = false
            selectedAliPayBtn.isSelected = true
        }else{
            payType = 0
            selectedWechatPayBtn.isSelected = true
            selectedAliPayBtn.isSelected = false
        }
    }
    
    /// 发起支付
    @objc func pay(){
        if payType == 0 {
            wechatPay(rp: dataSource["id"].intValue)
        }else{
            aliPay(rp: dataSource["id"].intValue)
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
        
        params["aid"] = String(rp)
        params["rp"] = "-10"
        
        Alamofire.request(Constants.Network.WECHAT_PAY_URL, method: .post, parameters: params).responseJSON { (response) in
            ToastUtils.hide()
            if response.error == nil && response.data != nil {
                let jsonData = JSON(data: response.data!)
                if jsonData["code"].int! == 0 {
                    WeChatShared.pay(to: "main", jsonData["data"], resultHandle: { (result, identifier) in
                        switch(result){
                        case .Success:
                            ToastUtils.showSuccessToast(msg: "购买成功，请到奖品中查看")
                            self.hide()
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
                    LoginViewController.showLoginVC()
                    LocalDataUtils.clearLoaclData()
                }else if jsonData["code"].int! == -101 {
                    ToastUtils.showErrorToast(msg: "您不具备首充资格，请刷新")
                }else{
                    ToastUtils.showErrorToast(msg: "错误:" + jsonData["msg"].stringValue)
                }
            }else{
                
            }
        }
    }
    
    func aliPay(rp:Int) -> () {
        ToastUtils.showLoadingToast(msg: "正在下单……")
        var params = NetWorkUtils.createBaseParams()
        
        params["aid"] = String(rp)
        params["rp"] = "-10"
        
        Alamofire.request(Constants.Network.ALIPAY_URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            ToastUtils.hide()
            if response.error == nil && response.data != nil {
                let jsonData = JSON(data: response.data!)
                if jsonData["code"].int! == 0 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { [weak self] in
                        self?.aliPayOrder(orderBody: jsonData["data"]["orderBody"].string!)
                    })
                }else if jsonData["code"].int! == -302 {
                    print("用户身份异常，重新登录")
                    LoginViewController.showLoginVC()
                    LocalDataUtils.clearLoaclData()
                }else if jsonData["code"].int! == -101 {
                    ToastUtils.showErrorToast(msg: "您不具备首充资格，请刷新")
                }else {
                    ToastUtils.showErrorToast(msg: "错误:" + jsonData["msg"].stringValue)
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
                    ToastUtils.showSuccessToast(msg: "购买成功，请到奖品中查看")
                    self.hide()
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
    
    func show() {
        self.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.shadow.alpha = 0.5
            self.rootView.frame.origin = CGPoint.init(x: 0, y: UIScreen.main.bounds.height - self.rootView.bounds.height)
        }
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.shadow.alpha = 0.0
            self.rootView.frame.origin.y = UIScreen.main.bounds.height
        }) { (isEnd) in
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
    
    // 添加view到window中
    func addDialogToWindow(){
        self.shadow = UIControl(frame: (keyWindow?.bounds)!)
        self.shadow.backgroundColor = UIColor.black
        self.shadow.alpha = 0.0
        keyWindow?.addSubview(self.shadow)
        keyWindow?.addSubview(self)
        
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
