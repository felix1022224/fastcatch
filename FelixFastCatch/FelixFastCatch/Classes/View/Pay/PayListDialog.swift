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
import StoreKit

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
        
//        SKPaymentQueue.default().restoreCompletedTransactions()
//        SKPaymentQueue.default().add(self)
        
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
    
    override func hide() {
        super.hide()
//        SKPaymentQueue.default().remove(self)
    }
    
}

// MARK: - 内购支付
//extension PayListDialog: SKPaymentTransactionObserver {// 交易队列监听
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {// 当交易队列里面添加的每一笔交易状态发生变化的时候调用
//            switch transaction.transactionState {
//            case .deferred:
//                print("延迟处理")
//            case .failed:
//                print("支付失败")
//                queue.finishTransaction(transaction)
//            case .purchased:
//                print("支付成功")
//                applePaySuccess(transactions: transaction)
//                queue.finishTransaction(transaction)
//            case .purchasing:
//                print("正在支付")
//            case .restored:
//                print("恢复购买")
//                queue.finishTransaction(transaction)
//            }
//        }
//    }
//}

// MARK: - 内购的代理
//extension PayListDialog: SKProductsRequestDelegate {
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {// 当请求完毕之后, 从苹果服务器获取到数据之后调用
//        print(response.products)
//        print(response.invalidProductIdentifiers)
//        var prod: SKProduct?
//        for pro in response.products {
//            print("------------------")
//            print(pro.localizedDescription)
//            print(pro.localizedTitle)
//            print(pro.price)
//            print(pro.productIdentifier)
//            print("------------------")
//            prod = pro
//        }
//        // 发送购买请求
//        if let produ = prod {
//            let payment = SKPayment(product: produ)
//            SKPaymentQueue.default().add(payment)
//        }
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            ToastUtils.hide()
//        }
//    }
//    
//    /// 支付成功,去服务器校验
//    func applePaySuccess(transactions: SKPaymentTransaction) -> () {
//        let receiptUrl = Bundle.main.appStoreReceiptURL
//        let receiveData = NSData(contentsOf: receiptUrl!)
//        // 最好转成Base64，万一返回结果有特殊字符
//        let receiptString = receiveData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
//        
//        var params = NetWorkUtils.createBaseParams()
//        params["productIdentifier"] = transactions.payment.productIdentifier
//        params["receipt"] = receiptString
//        params["transactionIdentifier"] = transactions.transactionIdentifier
//        
//        Alamofire.request(Constants.Network.APPLE_PAY_CHECK, method: .post, parameters: params).responseJSON { (response) in
//            print("reponse:\(response.result.value!)")
//        }
//    }
//}

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
        if WeChatShared.isInstall() == false {
            ToastUtils.showErrorToast(msg: "不支持购买")
            return
        }
        if wechatBtn.isSelected && WeChatShared.isInstall() {
            wechatPay(rp: sender.tag)
            return
        }
        /// 内购
//        if SKPaymentQueue.canMakePayments() {//判断当前的支付环境, 是否可以支付
//            ToastUtils.showLoadingToast(msg: "请稍后……")
//            let product = ["com.meidaojia.secondcatch." + String(sender.tag)]
//            let set = NSSet(array: product as [AnyObject])
//            let request = SKProductsRequest(productIdentifiers: set as! Set<String>)
//            request.delegate = self
//            request.start()
//        }
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
            make.right.equalTo(backgroundImage).offset(-16)
//            make.right.equalTo(aliPayBtn).offset(-(aliPayBtn.bounds.width + 18))
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
        
        exchangeCode.isHidden = true
        
        aliPayBtn.isHidden = true
        wechatBtn.isHidden = true
        
        getAppReleaseVersion()
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
                wechatBtn.isSelected = true
            }else{
                wechatBtn.isSelected = false
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
        if WeChatShared.isInstall() == false {
            ToastUtils.showErrorToast(msg: "暂时无法支付")
            return
        }
        
        ToastUtils.showLoadingToast(msg: "正在下单")
        var params = NetWorkUtils.createBaseParams()
        params["rp"] = String(rp)
        
        Alamofire.request(Constants.Network.WECHAT_PAY_URL, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                ToastUtils.hide()
                let json = JSON(data: response.data!)
                WeChatShared.pay(to: "main", json["data"], resultHandle: { (result, identifier) in
                    switch(result){
                        case .Success:
                            ToastUtils.showSuccessToast(msg: "支付成功")
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
        Alamofire.request(Constants.Network.GET_PAY_LIST, method: .post, parameters: NetWorkUtils.createBaseParams()).responseJSON { (response) in
            print("reponse:\(response.result.value!)")
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

// MARK: - 获取当前APP STORE上的版本号
extension PayListDialog{
    
    /// 获取版本号，来判断显不显示微信支付
    func getAppReleaseVersion() -> () {
        Alamofire.request(Constants.Network.GET_SYS_INFO_VERSION, method: .post, parameters: NetWorkUtils.createBaseParams()).responseJSON { (response) in
            print("versionValue:\(response.result.value!)")
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(data: response.data!)
                let infoDictionary = Bundle.main.infoDictionary!
                if let buildVersion = (infoDictionary["CFBundleVersion"] as? NSString)?.doubleValue {
                    print("buildVersion:\(buildVersion)")
                    if json["data"].doubleValue >= buildVersion {
                        print("正式")
//                        self.wechatBtn.isSelected = true
                        self.exchangeCode.isHidden = false
                    }else{
                        print("提审")
//                        self.wechatBtn.isSelected = false
                        self.exchangeCode.isHidden = true
                    }
                }else {
//                    self.wechatBtn.isSelected = false
                    self.exchangeCode.isHidden = true
                }
            }else{
                /// 发生异常
//                self.wechatBtn.isSelected = false
                self.exchangeCode.isHidden = true
            }
        }
    }
    
}






