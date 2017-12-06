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
    
    // 已邮寄按钮
    fileprivate lazy var hasBeenMailedBtn = UIButton(type: UIButtonType.custom)
    
    // 没有邮寄的奖品
    fileprivate lazy var noMailingValueView = UIView()
    
    // 待邮寄的tabview
    fileprivate lazy var tobeMailedTabView = UITableView()
    
    // 已邮寄的tabview
    fileprivate lazy var hasbeenMailedTabView = UITableView()
    
    // 代理
    fileprivate var tobeMailedDelegate = FCMyGiftToBeMailedTabViewDelegate()
    fileprivate var hasBeenMailedDelegate = FCMyGiftHasBeenMailedTabViewDelegate()
    
    // tab的背景
    fileprivate var tabsBackground:UIImageView!
    
    // 我要邮寄的按钮
    fileprivate var mailedBtn = UIButton(type: UIButtonType.custom)
    
    // 邮费相关的描述
    fileprivate var postageInfoLabel = MainCustomerLabel()
    
    // 邮件确认
    fileprivate var mailedConfirmDialog:FCMailedConfirmDialog!
    
    // 免邮次数
    fileprivate var freePostageNumber = 0
    
    // 需要支付的邮费
    fileprivate var postageCashNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViewBackground()
        
        createNoValueView()
        
        createBackBtn()
        
        createTabs()
        
        createMailedBtn()
        
        createTobeMailedList()
        createHasBeenMailedList()
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
        tabsBackground = UIImageView(image: UIImage(named: "邮寄未邮寄背景"))
        view.addSubview(tabsBackground)
        tabsBackground.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(backBtn)
        }
        addTabsBtn(tabsBackground: tabsBackground)
    }
    
    /// 添加按钮
    func addTabsBtn(tabsBackground:UIImageView) -> () {
        let tobeImage = UIImageView(image: UIImage(named: "待邮寄未点击"))
        
        /// 待邮寄
        tobeMailedBtn.setBackgroundImage(UIImage(named: "待邮寄未点击"), for: .normal)
        tobeMailedBtn.setBackgroundImage(UIImage(named: "待邮寄点击"), for: .selected)
        view.addSubview(tobeMailedBtn)
        
        tobeMailedBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(tabsBackground).offset(-tobeImage.bounds.width/2)
            make.centerY.equalTo(tabsBackground)
        }
        
        /// 已邮寄
        hasBeenMailedBtn.setBackgroundImage(UIImage(named: "已邮寄未点击"), for: .normal)
        hasBeenMailedBtn.setBackgroundImage(UIImage(named: "已邮寄点击"), for: .selected)
        view.addSubview(hasBeenMailedBtn)
        
        hasBeenMailedBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(tabsBackground).offset(tobeImage.bounds.width/2)
            make.centerY.equalTo(tabsBackground)
        }
        
        tobeMailedBtn.addTarget(self, action: #selector(tabsClick(action:)), for: .touchUpInside)
        hasBeenMailedBtn.addTarget(self, action: #selector(tabsClick(action:)), for: .touchUpInside)
        
        switchTabs(tabsIndex: 0)
    }
    
    /// 切换tabs
    ///
    /// - Parameter tabsIndex: tab的坐标，0是待邮寄，1是已邮寄
    func switchTabs(tabsIndex:Int) -> () {
        if tabsIndex == 0 {
            tobeMailedBtn.isSelected = true
            hasBeenMailedBtn.isSelected = false
            
            tobeMailedBtn.isUserInteractionEnabled = false
            hasBeenMailedBtn.isUserInteractionEnabled = true
            
            tobeMailedTabView.isHidden = false
            hasbeenMailedTabView.isHidden = true
            
            if tobeMailedDelegate.dataSource.count <= 0 {
                noMailingValueView.isHidden = false
            }else{
                noMailingValueView.isHidden = true
            }
            
            mailedBtn.isHidden = false
//            postageInfoLabel.isHidden = false
            
        }else{
            tobeMailedBtn.isSelected = false
            hasBeenMailedBtn.isSelected = true
            
            tobeMailedBtn.isUserInteractionEnabled = true
            hasBeenMailedBtn.isUserInteractionEnabled = false
            
            tobeMailedTabView.isHidden = true
            hasbeenMailedTabView.isHidden = false
            
            if hasBeenMailedDelegate.dataSource.count <= 0 {
                noMailingValueView.isHidden = false
            }else{
                noMailingValueView.isHidden = true
            }
            
            mailedBtn.isHidden = true
//            postageInfoLabel.isHidden = true
        }
    }
    
    /// 点击
    @objc func tabsClick(action:UIButton) -> () {
        if action == tobeMailedBtn {
            switchTabs(tabsIndex: 0)
        }else{
            switchTabs(tabsIndex: 1)
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
//            make.height.equalTo(UIScreen.main.bounds.height)
        }
        
        let noValueLabel = MainCustomerLabel()
        noValueLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(22))
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
        postageInfoLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(14))
        postageInfoLabel.text = "本月剩余免邮次数"
        postageInfoLabel.sizeToFit()
        view.addSubview(postageInfoLabel)
        
        postageInfoLabel.isHidden = true
        
        postageInfoLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-10)
        }
        
        mailedBtn.frame.size = CGSize(width: 161, height: 45)
        mailedBtn.setBackgroundImage(UIImage(named: "按钮我要邮寄"), for: .normal)
        mailedBtn.setBackgroundImage(UIImage(named: "按钮我要邮寄灰"), for: .disabled)
        
        mailedBtn.isEnabled = true
        
        view.addSubview(mailedBtn)
        
        mailedBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(postageInfoLabel).offset(-(10 + postageInfoLabel.bounds.height))
        }
        mailedConfirmDialog = FCMailedConfirmDialog(frame: view.bounds)
        mailedBtn.addTarget(self, action: #selector(showMailedConfirmDialog), for: .touchUpInside)
    }
    
    // 展示邮件信息确认页面
    @objc func showMailedConfirmDialog() -> () {
        if tobeMailedDelegate.selectList.count <= 0 {
            ToastUtils.showErrorToast(msg: "请选择要邮寄的产品")
            return
        }
        /// 组装数据
        var sendData = [JSON]()
        for key in Array(tobeMailedDelegate.selectList.keys) {
            if tobeMailedDelegate.selectList[key] == true {
                sendData.append(tobeMailedDelegate.dataSource[key])
            }
        }
        
        mailedConfirmDialog.mailedSuccessCallback = {[weak self] in
            self?.tobeMailedDelegate.dataSource.removeAll()
            self?.hasBeenMailedDelegate.dataSource.removeAll()
            self?.getMailedGiftList(isRefresh: true)
            self?.getTobeMailedGiftList(isRefresh: true)
        }
        
        mailedConfirmDialog.sendData.removeAll()
        mailedConfirmDialog.sendData = sendData
        
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
        params["size"] = "300"
        params["page"] = "0"
        
        Alamofire.request(Constants.Network.Gift.GET_TOBE_MAILED_GIFT_LIST, method: .post, parameters: params).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(response.result.value!)
                print("mailed:\(json)")
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
                }else{
                    self.mailedBtn.isEnabled = true
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
        _ = UIImage(named: "已邮寄item背景")
        
        view.addSubview(hasbeenMailedTabView)
        hasbeenMailedTabView.backgroundColor = UIColor.clear
        hasbeenMailedTabView.separatorColor = UIColor.clear
        hasbeenMailedTabView.showsVerticalScrollIndicator = false
        
        hasbeenMailedTabView.delegate = hasBeenMailedDelegate
        hasbeenMailedTabView.dataSource = hasBeenMailedDelegate
        hasbeenMailedTabView.register(FCMyGiftHasBeenMailedCell.self, forCellReuseIdentifier: "cellId")
        
        hasbeenMailedTabView.snp.makeConstraints { (make) in
            make.top.equalTo(tabsBackground).offset(tabsBackground.bounds.height + 10)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view)
            make.width.equalTo(UIScreen.main.bounds.width * 0.98)
        }
        
        hasbeenMailedTabView.isHidden = true
        
        getMailedGiftList(isRefresh: true)
    }
    
    func getMailedGiftList(isRefresh:Bool) -> () {
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "300"
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















