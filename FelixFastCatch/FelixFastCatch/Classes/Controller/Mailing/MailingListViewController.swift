//
//  MailingListViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/9.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/// 邮寄列表页面
class MailingListViewController: UIViewController {
    
    // 返回按钮
    fileprivate lazy var backBtn = UIButton(type: UIButtonType.custom)
    
    // 待邮寄按钮
    fileprivate lazy var tobeMailedBtn = UIButton(type: UIButtonType.custom)
    
    fileprivate lazy var convertedButton = UIButton(type: UIButtonType.custom)
    
    // 已邮寄按钮
    fileprivate lazy var hasBeenMailedBtn = UIButton(type: UIButtonType.custom)
    
    // 没有邮寄的奖品
    fileprivate lazy var noMailingValueView = UIView()
    
    // 待邮寄的tabview
    fileprivate lazy var tobeMailedTabView = UITableView()
    
    // 已邮寄的tabview
    fileprivate lazy var hasbeenMailedTabView = UITableView()
    
    // 已兑换的tabview
    fileprivate lazy var convertedTabView = UITableView()
    
    // 代理
    fileprivate var tobeMailedDelegate = FCMyGiftToBeMailedTabViewDelegate()
    fileprivate var hasBeenMailedDelegate = FCMyGiftHasBeenMailedTabViewDelegate()
    
    // tab的背景
    fileprivate var tabsBackground:UIImageView!
    
    // 我要邮寄的按钮
    fileprivate var mailedBtn = UIButton(type: UIButtonType.custom)
    
    // 我要兑换的按钮
    fileprivate var exchangePointsBtn = UIButton(type: UIButtonType.custom)
    
    // 邮费相关的描述
    fileprivate var postageInfoLabel = MainCustomerLabel()
    
    // 邮件确认
    fileprivate var mailedConfirmDialog:FCMailedConfirmDialog!
    
    // 兑换积分确认
    fileprivate var exchangePointsDialog:ExchangePointsDialog!
    
    // 免邮次数
    fileprivate var freePostageNumber = 0
    
    // 需要支付的邮费
    fileprivate var postageCashNumber = 0
    
    fileprivate var convertedDataSource = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViewBackground()
        
        createNoValueView()
        
        createBackBtn()
        
        createTabs()
        
        createMailedBtn()
        
        createTobeMailedList()
        createHasBeenMailedList()
        createExchangeList()
    }
    
    /// 创建view的背景
    func createViewBackground() -> () {
        let mailingBackground = UIImageView(image: UIImage(named: "邮寄背景"))
        mailingBackground.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(mailingBackground)
    }
    
    /// 创建返回的按钮
    func createBackBtn() -> () {
        backBtn.setImage(UIImage(named: "邮寄返回"), for: .normal)
        backBtn.sizeToFit()
        backBtn.frame = CGRect(x: 14, y: UIApplication.shared.statusBarFrame.height + 10, width: backBtn.bounds.width, height: backBtn.bounds.height)
        view.addSubview(backBtn)
        
        backBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }
    
    /// 关掉当前页面
    @objc func closeView() -> () {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - 顶部切换按钮
extension MailingListViewController{
    
    /// 创建顶部的tabs
    func createTabs() -> () {
        createTabsBackground()
    }
    
    /// 创建tabs的背景
    func createTabsBackground() -> () {
        tabsBackground = UIImageView(image: UIImage(named: "tap底"))
        view.addSubview(tabsBackground)
        tabsBackground.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(backBtn)
        }
        addTabsBtn(tabsBackground: tabsBackground)
    }
    
    /// 添加按钮
    func addTabsBtn(tabsBackground:UIImageView) -> () {
        /// 待邮寄
        tobeMailedBtn.setBackgroundImage(UIImage(named: "待提取_en"), for: .normal)
        tobeMailedBtn.setBackgroundImage(UIImage(named: "待提取"), for: .selected)
        view.addSubview(tobeMailedBtn)
        
        tobeMailedBtn.snp.makeConstraints { (make) in
            make.left.equalTo(tabsBackground).offset(1)
            make.centerY.equalTo(tabsBackground)
        }
        
        /// 已邮寄
        hasBeenMailedBtn.setBackgroundImage(UIImage(named: "已提取_en"), for: .normal)
        hasBeenMailedBtn.setBackgroundImage(UIImage(named: "已提取"), for: .selected)
        view.addSubview(hasBeenMailedBtn)
        
        hasBeenMailedBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(tabsBackground)
            make.centerY.equalTo(tabsBackground)
        }
        
        /// 已兑换
        convertedButton.setBackgroundImage(UIImage(named: "已兑换H"), for: .normal)
        convertedButton.setBackgroundImage(UIImage(named: "已兑换"), for: .selected)
        view.addSubview(convertedButton)
        
        convertedButton.snp.makeConstraints { (make) in
            make.right.equalTo(tabsBackground).offset(-1)
            make.centerY.equalTo(tabsBackground)
        }
        
        tobeMailedBtn.addTarget(self, action: #selector(tabsClick(action:)), for: .touchUpInside)
        hasBeenMailedBtn.addTarget(self, action: #selector(tabsClick(action:)), for: .touchUpInside)
        convertedButton.addTarget(self, action: #selector(tabsClick(action:)), for: .touchUpInside)
        
        switchTabs(tabsIndex: 0)
    }
    
    /// 切换tabs
    ///
    /// - Parameter tabsIndex: tab的坐标，0是待邮寄，1是已邮寄
    func switchTabs(tabsIndex:Int) -> () {
        if tabsIndex == 0 {
            tobeMailedBtn.isSelected = true
            hasBeenMailedBtn.isSelected = false
            convertedButton.isSelected = false
            
            tobeMailedBtn.isUserInteractionEnabled = false
            hasBeenMailedBtn.isUserInteractionEnabled = true
            convertedButton.isUserInteractionEnabled = true
            
            tobeMailedTabView.isHidden = false
            hasbeenMailedTabView.isHidden = true
            convertedTabView.isHidden = true
            
            if tobeMailedDelegate.dataSource.count <= 0 {
                noMailingValueView.isHidden = false
            }else{
                noMailingValueView.isHidden = true
            }
            
            mailedBtn.isHidden = false
            exchangePointsBtn.isHidden = false
            
        }else if tabsIndex == 1 {
            tobeMailedBtn.isSelected = false
            hasBeenMailedBtn.isSelected = true
            convertedButton.isSelected = false
            
            tobeMailedBtn.isUserInteractionEnabled = true
            hasBeenMailedBtn.isUserInteractionEnabled = false
            convertedButton.isUserInteractionEnabled = true
            
            tobeMailedTabView.isHidden = true
            hasbeenMailedTabView.isHidden = false
            convertedTabView.isHidden = true
            
            if hasBeenMailedDelegate.dataSource.count <= 0 {
                noMailingValueView.isHidden = false
            }else{
                noMailingValueView.isHidden = true
            }
            
            mailedBtn.isHidden = true
            exchangePointsBtn.isHidden = true
        }else{
            tobeMailedBtn.isSelected = false
            hasBeenMailedBtn.isSelected = false
            convertedButton.isSelected = true
            
            tobeMailedBtn.isUserInteractionEnabled = true
            hasBeenMailedBtn.isUserInteractionEnabled = true
            convertedButton.isUserInteractionEnabled = false
            
            tobeMailedTabView.isHidden = true
            hasbeenMailedTabView.isHidden = true
            convertedTabView.isHidden = false
            
            if convertedDataSource.count <= 0 {
                noMailingValueView.isHidden = false
            }else{
                noMailingValueView.isHidden = true
            }
            
            mailedBtn.isHidden = true
            exchangePointsBtn.isHidden = true
        }
    }
    
    /// 点击
    @objc func tabsClick(action:UIButton) -> () {
        if action == tobeMailedBtn {
            switchTabs(tabsIndex: 0)
        }else if action == hasBeenMailedBtn {
            switchTabs(tabsIndex: 1)
        }else{
            switchTabs(tabsIndex: 2)
        }
    }
}

// MARK: - 没有奖品
extension MailingListViewController{

    /// 创建没有奖品的view
    func createNoValueView() -> () {
        noMailingValueView.frame = view.bounds
        view.addSubview(noMailingValueView)
        noMailingValueView.center = view.center
        
        let noValueImage = UIImageView(image: UIImage(named: "邮寄没奖品"))
        noMailingValueView.addSubview(noValueImage)
        noValueImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(noMailingValueView)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        let noValueLabel = MainCustomerLabel()
        noValueLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 22)
        noValueLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        noValueLabel.outTextColor = UIColor.white
        noValueLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        noValueLabel.text = "暂无记录"
        noValueLabel.sizeToFit()
        noMailingValueView.addSubview(noValueLabel)
        
        noValueLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(noMailingValueView).offset(60)
            make.centerX.equalTo(noMailingValueView)
        }
    }
}

// MARK: - 我要邮寄
extension MailingListViewController{
    
    /// 创建我要邮寄的按钮
    func createMailedBtn() -> () {
        postageInfoLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        postageInfoLabel.outTextColor = UIColor.white
        postageInfoLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        postageInfoLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        postageInfoLabel.text = "本月剩余免邮次数"
        postageInfoLabel.sizeToFit()
        view.addSubview(postageInfoLabel)
        
        postageInfoLabel.isHidden = true
        
        postageInfoLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-10)
        }
    
        mailedBtn.setBackgroundImage(UIImage(named: "我要邮寄"), for: .normal)
        mailedBtn.setBackgroundImage(UIImage(named: "我要邮寄点击"), for: .highlighted)
        mailedBtn.setBackgroundImage(UIImage(named: "我要邮寄H"), for: .disabled)
        mailedBtn.sizeToFit()
        
        mailedBtn.isEnabled = true
        
        view.addSubview(mailedBtn)
        
        mailedBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-14)
            make.bottom.equalTo(postageInfoLabel).offset(-(postageInfoLabel.bounds.height))
        }
        mailedConfirmDialog = FCMailedConfirmDialog(frame: view.bounds)
        mailedBtn.addTarget(self, action: #selector(showMailedConfirmDialog), for: .touchUpInside)
        
        /// 我要兑换的按钮
        exchangePointsBtn.setBackgroundImage(UIImage(named: "积分兑换"), for: .normal)
        exchangePointsBtn.setBackgroundImage(UIImage(named: "积分兑换点击"), for: .highlighted)
        exchangePointsBtn.setBackgroundImage(UIImage(named: "积分兑换H"), for: .disabled)
        
        exchangePointsBtn.sizeToFit()
        
        exchangePointsBtn.isEnabled = true
        
        view.addSubview(exchangePointsBtn)
        
        exchangePointsBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(14)
            make.centerY.equalTo(mailedBtn)
        }
        exchangePointsBtn.addTarget(self, action: #selector(showExchangePointsDialog), for: .touchUpInside)
    }
    
    /// 显示兑换积分的弹窗
    @objc func showExchangePointsDialog(){
//        if tobeMailedDelegate.selectList.count <= 0 {
//            ToastUtils.showErrorToast(msg: "请选择要兑换的产品")
//            return
//        }
        
        /// 组装数据
        var sendData = [JSON]()
        for key in Array(tobeMailedDelegate.selectList.keys) {
            if tobeMailedDelegate.selectList[key] == true {
                sendData.append(tobeMailedDelegate.dataSource[key])
            }
        }
        
        if sendData.count <= 0 {
            ToastUtils.showErrorToast(msg: "请选择要兑换的产品")
            return
        }
        
        if exchangePointsDialog == nil {
            exchangePointsDialog = ExchangePointsDialog(frame: UIScreen.main.bounds)
        }
        
        exchangePointsDialog.exchangeData.removeAll()
        exchangePointsDialog.exchangeData = sendData
        
        exchangePointsDialog.exchangeSuccessCallback = {[weak self] in
            self?.tobeMailedDelegate.dataSource.removeAll()
            self?.hasBeenMailedDelegate.dataSource.removeAll()
            self?.getConvertedList()
            self?.getMailedGiftList(isRefresh: true)
            self?.getTobeMailedGiftList(isRefresh: true)
        }
        
        exchangePointsDialog.createView()
        exchangePointsDialog.show()
    }
    
    // 展示邮件信息确认页面
    @objc func showMailedConfirmDialog() -> () {
        var awardType0 = false
        var awardType1 = false
        for key in Array(tobeMailedDelegate.selectList.keys) {
            if tobeMailedDelegate.selectList[key] == true {
                if tobeMailedDelegate.dataSource[key]["awardType"].intValue == 0 {
                    awardType0 = true
                }
                if tobeMailedDelegate.dataSource[key]["awardType"].intValue == 1 {
                    awardType1 = true
                }
            }
        }
        
        if awardType0 && awardType1 {
            ToastUtils.showErrorToast(msg: "虚拟奖品与实物奖品无法同时发货,请重新选择")
            return
        }
        
        /// 组装数据
        var sendData = [JSON]()
        for key in Array(tobeMailedDelegate.selectList.keys) {
            if tobeMailedDelegate.selectList[key] == true {
                sendData.append(tobeMailedDelegate.dataSource[key])
            }
        }
        
        if sendData.count <= 0 {
            ToastUtils.showErrorToast(msg: "请选择要邮寄的产品")
            return
        }
        
        mailedConfirmDialog.mailedSuccessCallback = {[weak self] in
            self?.tobeMailedDelegate.dataSource.removeAll()
            self?.hasBeenMailedDelegate.dataSource.removeAll()
            self?.getMailedGiftList(isRefresh: true)
            self?.getTobeMailedGiftList(isRefresh: true)
        }
        
        mailedConfirmDialog.sendData.removeAll()
        mailedConfirmDialog.sendData = sendData
        
        if awardType1 == true {
            mailedConfirmDialog.isOnline = true
        }else{
            mailedConfirmDialog.isOnline = false
        }
        
        mailedConfirmDialog.postageCashNumber = self.postageCashNumber
        mailedConfirmDialog.freePostageNumber = self.freePostageNumber
        
        mailedConfirmDialog.createView()
        mailedConfirmDialog.show()
    }
    
}

// MARK: - 待邮寄列表
extension MailingListViewController{
    
    /// 创建待邮寄列表
    func createTobeMailedList() -> () {
        // 待邮寄
        view.addSubview(tobeMailedTabView)
        tobeMailedTabView.backgroundColor = UIColor.clear
        tobeMailedTabView.delegate = tobeMailedDelegate
        tobeMailedTabView.dataSource = tobeMailedDelegate
        ///固定待邮寄cell的高度
        tobeMailedTabView.estimatedRowHeight = UIScreen.main.bounds.width * 0.98 * 0.3
        tobeMailedTabView.rowHeight = UIScreen.main.bounds.width * 0.98 * 0.3
        tobeMailedTabView.separatorColor = UIColor.clear
        tobeMailedTabView.showsVerticalScrollIndicator = false
        tobeMailedTabView.register(FCMyGiftCell.self, forCellReuseIdentifier: "cellId")
        
        tobeMailedTabView.snp.makeConstraints { (make) in
            make.top.equalTo(tabsBackground).offset(tabsBackground.bounds.height + 5)
            make.centerX.equalTo(view)
            make.bottom.equalTo(mailedBtn).offset(-(5 + mailedBtn.bounds.height))
            make.width.equalTo(UIScreen.main.bounds.width * 0.98)
        }
        
        getTobeMailedGiftList(isRefresh: true)
    }
    
    func getTobeMailedGiftList(isRefresh:Bool) -> () {
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "10000"
        params["page"] = "0"
        
        Alamofire.request(Constants.Network.Gift.GET_TOBE_MAILED_GIFT_LIST, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(response.result.value!)
                if isRefresh {
                    self.tobeMailedDelegate.selectList.removeAll()
                    self.tobeMailedDelegate.dataSource.removeAll()
                }
                self.tobeMailedDelegate.dataSource += json["data"]["content"].array!
                
                if self.tobeMailedDelegate.dataSource.count > 0 {
                    for i in 0...self.tobeMailedDelegate.dataSource.count-1 {
                        self.tobeMailedDelegate.selectList[i] = true
                    }
                }
                
                self.updateFreePostageNumber(number: json["data"]["freePostNum"].intValue)
                self.freePostageNumber = json["data"]["freePostNum"].intValue
                self.postageCashNumber = json["data"]["postDiamonds"].intValue
                
                self.tobeMailedTabView.reloadData()
                
                if self.tobeMailedDelegate.dataSource.count <= 0 {
                    self.mailedBtn.isEnabled = false
                    self.exchangePointsBtn.isEnabled = false
                }else{
                    self.mailedBtn.isEnabled = true
                    self.exchangePointsBtn.isEnabled = true
                }
                
                self.showTobeMailedNoValue()
            }else{
                self.showTobeMailedNoValue()
            }
        }
    }
    
    /// 更新免邮次数
    func updateFreePostageNumber(number:Int) -> () {
        postageInfoLabel.text = "本月剩余免邮次数" + String(number) + "次"
    }
    
    func showTobeMailedNoValue() -> () {
        /// 如果list是隐藏状态，就不用继续进行操作了
        if tobeMailedTabView.isHidden != false {
            return
        }
        
        if self.tobeMailedDelegate.dataSource.count <= 0 {
            self.noMailingValueView.isHidden = false
        }else{
            self.noMailingValueView.isHidden = true
        }
    }
}

// MARK: - 已邮寄列表
extension MailingListViewController{
    
    /// 创建已邮寄列表
    func createHasBeenMailedList() -> () {
        // 已邮寄
        
        view.addSubview(hasbeenMailedTabView)
        hasbeenMailedTabView.backgroundColor = UIColor.clear
        hasbeenMailedTabView.separatorColor = UIColor.clear
        hasbeenMailedTabView.showsVerticalScrollIndicator = false
        
        hasbeenMailedTabView.estimatedRowHeight = UIImage(named: "已邮寄item背景")?.size.height ?? 0
        
        hasbeenMailedTabView.delegate = hasBeenMailedDelegate
        hasbeenMailedTabView.dataSource = hasBeenMailedDelegate
        hasbeenMailedTabView.register(FCMyGiftHasBeenMailedCell.self, forCellReuseIdentifier: "cellId")
        
        hasbeenMailedTabView.snp.makeConstraints { (make) in
            make.top.equalTo(tabsBackground).offset(tabsBackground.bounds.height + 10)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view)
            make.width.equalTo(UIScreen.main.bounds.width * 0.9)
        }
        
        hasbeenMailedTabView.isHidden = true
        
        getMailedGiftList(isRefresh: true)
    }
    
    func getMailedGiftList(isRefresh:Bool) -> () {
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "10000"
        params["page"] = "0"
        
        Alamofire.request(Constants.Network.Gift.GET_MAILED_GIFT_LIST, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(response.result.value!)
                if isRefresh {
                    self.hasBeenMailedDelegate.dataSource.removeAll()
                }
                self.hasBeenMailedDelegate.dataSource += json["data"]["content"].array!
                self.hasbeenMailedTabView.reloadData()
                self.showHasBeenNoValue()
            }else{
                self.showHasBeenNoValue()
            }
        }
    }
    
    func showHasBeenNoValue() -> () {
        if hasbeenMailedTabView.isHidden != false {
            return
        }
        
        if hasBeenMailedDelegate.dataSource.count <= 0 {
            noMailingValueView.isHidden = false
        }else{
            noMailingValueView.isHidden = true
        }
    }
    
}

extension MailingListViewController: UITableViewDelegate, UITableViewDataSource{
    
    /// 创建已兑换的list
    func createExchangeList() {
        view.addSubview(convertedTabView)
        convertedTabView.backgroundColor = UIColor.clear
        convertedTabView.separatorColor = UIColor.clear
        convertedTabView.showsVerticalScrollIndicator = false
        
        convertedTabView.rowHeight = (UIScreen.main.bounds.width * 0.98) * 0.3
        
        convertedTabView.estimatedRowHeight = UIImage(named: "已邮寄item背景")?.size.height ?? 0
        
        convertedTabView.delegate = self
        convertedTabView.dataSource = self
        convertedTabView.register(HasBeenConvertedTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        convertedTabView.snp.makeConstraints { (make) in
            make.top.equalTo(tabsBackground).offset(tabsBackground.bounds.height + 10)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view)
            make.width.equalTo(UIScreen.main.bounds.width * 0.98)
        }
        
        convertedTabView.isHidden = true
        
        getConvertedList()
    }
    
    /// 获取已兑换的list
    func getConvertedList() {
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "10000"
        params["page"] = "0"
        params["type"] = "2"
        
        Alamofire.request(Constants.Network.Gift.GET_CONVERTED_LIST, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(response.result.value!)
                self.convertedDataSource.removeAll()
    
                self.convertedDataSource += json["data"]["content"].array!
                self.convertedTabView.reloadData()
                self.showConvertedNoValue()
            }else{
                self.showConvertedNoValue()
            }
        }
    }
    
    func showConvertedNoValue() -> () {
        if convertedTabView.isHidden != false {
            return
        }
        
        if convertedDataSource.count <= 0 {
            convertedTabView.isHidden = false
        }else{
            convertedTabView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convertedDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? HasBeenConvertedTableViewCell
        
        cell?.productImage.kf.setImage(with: URL(string: convertedDataSource[indexPath.row]["awardImg"].stringValue))
        cell?.productTitleLabel.text = convertedDataSource[indexPath.row]["awardTitle"].stringValue
        
        cell?.timeLabel.text = convertedDataSource[indexPath.row]["createTime"].stringValue
        
        cell?.pointsLabel.text = "+\(convertedDataSource[indexPath.row]["integral"].stringValue)积分"
        
        cell?.pointsLabel.sizeToFit()
        
        return cell!
    }
    
}














