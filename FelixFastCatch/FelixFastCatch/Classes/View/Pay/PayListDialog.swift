//
//  PayListDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/31.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PayListDialog: BaseDialog {

    /// 商品列表
    fileprivate lazy var payList:UITableView = UITableView()
    
    /// 购买列表的数据
    fileprivate var payListDataSource = [JSON]()
    
    var scrollHand:UIImageView!
    
    var aliPayBtn = UIButton(type: .custom)
    
    var wechatBtn = UIButton(type: .custom)
    
    var exchangeCode = UIButton(type: .custom)
    
    fileprivate var exchangeCodeDialog:ExchangeCodeDialog!
    
    var paySuccessCallback:(()->())? = nil
    
    override func createView() {
        createBackgroundImage(imageName: "pay_background")
        
        backgroundImage.frame.size = CGSize(width: 290, height: 410)
        backgroundImage.center = self.center
        
        createCloseBtn()
        
        /// 创建购买列表
        createPayList()
        
        createPayMode()
        
        addDialogToWindow()
    }
    
    /// 创建购买列表的tabview
    func createPayList() -> () {
        payList.backgroundColor = UIColor.clear
        payList.register(PayItemTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        payList.separatorColor = UIColor.clear
        payList.showsVerticalScrollIndicator = false
        
        payList.delegate = self
        payList.dataSource = self
        
        addSubview(payList)
        
        let topContentHeight = UIImage(named: "pay_item_background")
        
        payList.snp.makeConstraints { (make) in
            make.width.equalTo(topContentHeight!.size.width)
            make.height.equalTo(topContentHeight!.size.height * 4)
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(backgroundImage).offset(75)
        }

        let scrollBackground = UIImageView(image: UIImage(named: "scroll_background"))
        scrollBackground.sizeToFit()
        addSubview(scrollBackground)
        
        scrollBackground.snp.makeConstraints { (make) in
            make.left.equalTo(payList).offset(topContentHeight!.size.width + 5)
            make.centerY.equalTo(payList)
            make.top.equalTo(payList)
            make.bottom.equalTo(payList)
        }
        
        let rightScroll = UIScrollView()
        rightScroll.contentSize = CGSize(width: scrollBackground.bounds.width - 2, height: topContentHeight!.size.height * 4)
        addSubview(rightScroll)
        
        rightScroll.snp.makeConstraints { (make) in
            make.left.equalTo(payList).offset(topContentHeight!.size.width + 5)
            make.centerY.equalTo(payList)
            make.top.equalTo(payList)
            make.bottom.equalTo(payList)
            make.width.equalTo(scrollBackground)
        }
        
        rightScroll.frame.size = CGSize(width: scrollBackground.bounds.width, height: topContentHeight!.size.height * 4)
        rightScroll.bounces = false
        rightScroll.alwaysBounceHorizontal = false
        scrollHand = UIImageView()
        rightScroll.addSubview(scrollHand)
        
        scrollHand.frame.size = CGSize(width: scrollBackground.bounds.width, height:topContentHeight!.size.height * 4 - (topContentHeight!.size.height * 4 + 10 * 4 - topContentHeight!.size.height * 4))
        
        scrollHand.image = UIImage(named: "scroll_hand")?.resizableImage(withCapInsets: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0), resizingMode: UIImageResizingMode.stretch)
        
        getPayList()
    }
    
    fileprivate var mainVC:MainViewController!
    
    func show2(mainViewController:MainViewController) -> () {
        mainVC = mainViewController
        show()
    }
    
}

// MARK: - 列表的代理
extension PayListDialog:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payListDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? PayItemTableViewCell
        
        let dataItem = payListDataSource[indexPath.row]
        
        cell?.payBtn.tag = dataItem["id"].intValue
        
        cell?.gemInfo.text = dataItem["name"].stringValue
//        cell?.payBtn.setImage(UIImage(named: dataItem["pay_btn_image_named"]!), for: .normal)
//        cell?.payBtn.titleLabel?.text = "\(dataItem["value"].stringValue)"
//        cell?.payBtn.setTitle("  \(dataItem["value"].stringValue)", for: .normal)
        cell?.payBtn.addTarget(self, action: #selector(payClick(sender:)), for: .touchUpInside)
        
        cell?.payNumberLabel.text = dataItem["value"].stringValue
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let topContentHeight = UIImage(named: "pay_item_background")
        
        return (topContentHeight?.size.height)! + 10
    }
    
    /// 点击购买按钮
    ///
    /// - Parameter sender: 按钮
    func payClick(sender:UIButton) -> () {
        print("rp:\(sender.tag)")
        wechatPay(rp: sender.tag)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.3) {
            self.scrollHand.frame.origin.y = scrollView.contentOffset.y
        }
    }
    
}

extension PayListDialog{
    
    /// 创建支付方式
    func createPayMode() -> () {

        /// 支付宝支付按钮
        aliPayBtn.setBackgroundImage(UIImage(named: "支付宝未选中"), for: .normal)
        aliPayBtn.setBackgroundImage(UIImage(named: "支付宝选中"), for: .selected)
        addSubview(aliPayBtn)
        
        aliPayBtn.tag = 100
        
        aliPayBtn.frame.size = CGSize(width: 36, height: 36)
        
        aliPayBtn.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundImage).offset(-16)
            make.bottom.equalTo(backgroundImage).offset(-30)
        }
        
        aliPayBtn.addTarget(self, action: #selector(payBtnClick(sender:)), for: .touchUpInside)
        
        /// 微信支付按钮
        wechatBtn.setBackgroundImage(UIImage(named: "微信未选中"), for: .normal)
        wechatBtn.setBackgroundImage(UIImage(named: "微信选中"), for: .selected)
        addSubview(wechatBtn)
        
        wechatBtn.isSelected = true
        wechatBtn.frame.size = CGSize(width: 36, height: 36)
        
        wechatBtn.tag = 101
        
        wechatBtn.snp.makeConstraints { (make) in
            make.right.equalTo(aliPayBtn).offset(-(aliPayBtn.bounds.width + 18))
            make.centerY.equalTo(aliPayBtn)
        }
        
        wechatBtn.addTarget(self, action: #selector(payBtnClick(sender:)), for: .touchUpInside)
        
        exchangeCode.setBackgroundImage(UIImage(named: "兑换码"), for: .normal)
        exchangeCode.frame.size = CGSize(width: 36, height: 36)
        addSubview(exchangeCode)
        
        exchangeCode.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundImage).offset(20)
            make.centerY.equalTo(wechatBtn)
        }
        
        exchangeCode.addTarget(self, action: #selector(showExchangeDialog), for: .touchUpInside)
        
        aliPayBtn.isHidden = true
        wechatBtn.isHidden = true
        
    }
    
    func showExchangeDialog() -> () {
        if exchangeCodeDialog == nil {
            exchangeCodeDialog = ExchangeCodeDialog(frame: UIScreen.main.bounds)
        }
        exchangeCodeDialog.createView()
        exchangeCodeDialog.show2(mainViewController: mainVC)
    }
    
    func payBtnClick(sender:UIButton) -> () {
        if sender.tag == 100 {
            /// 支付宝
            if !aliPayBtn.isSelected {
                switchPayBtn()
            }
        }else if sender.tag == 101 {
            /// 微信
            if !wechatBtn.isSelected {
                switchPayBtn()
            }
        }
    }
    
    func switchPayBtn() -> () {
        if aliPayBtn.isSelected {
            aliPayBtn.isSelected = false
            wechatBtn.isSelected = true
        }else {
            aliPayBtn.isSelected = true
            wechatBtn.isSelected = false
        }
    }
    
    /// 微信支付
    func wechatPay(rp:Int) -> () {
        ToastUtils.showLoadingToast(msg: "正在下单")
        var params = NetWorkUtils.createBaseParams()
        params["rp"] = String(rp)
        
        Alamofire.request(Constants.Network.WECHAT_PAY_URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                ToastUtils.hide()
                let json = JSON(data: response.data!)
                WeChatShared.pay(to: "main", json["data"], resultHandle: { (result, identifier) in
                    print("result:\(result)")
                    print("indentifier:\(identifier)")
                    switch(result){
                        case .Success:
                            ToastUtils.showSuccessToast(msg: "支付成功")
                            if self.mainVC != nil {
                                self.mainVC.getsUserInfo()
                            }
                            if self.paySuccessCallback != nil {
                                self.paySuccessCallback!()
                            }
                            break;
                        case .Failed:
                            ToastUtils.showErrorToast(msg: "支付失败")
                            break;
                        case .Cancel:
                            ToastUtils.showInfoToast(msg: "取消支付")
                            break;
//                        default:
//                            ToastUtils.showInfoToast(msg: "发生异常")
//                            break
                    }
                })
            }else{
                ToastUtils.showErrorToast(msg: "错误，请稍后重试")
            }
        }
    }
}

// MARK: - 获取支付的列表
extension PayListDialog{

    /// 获取支付的列表
    func getPayList() -> () {
        Alamofire.request(Constants.Network.GET_PAY_LIST, method: .post, parameters: NetWorkUtils.createBaseParams(), encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(data: response.data!)
                /// 获取数据成功，重新加载数据
                print("data\(json)")
                self.payListDataSource = json["data"].arrayValue
                self.payList.reloadData()
            }else{
                ToastUtils.showErrorToast(msg: "获取套餐列表失败")
            }
        }
    }
    
}






