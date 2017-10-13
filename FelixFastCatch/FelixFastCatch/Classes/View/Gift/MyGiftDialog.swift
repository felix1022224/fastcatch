//
//  MyGiftDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/31.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyGiftDialog: BaseDialog {

//    // 关闭按钮
//    fileprivate var closeBtn:UIButton!
    
    // 切换tab的北京
    fileprivate var tabBackground:UIImageView!
    
    // 待邮寄
    fileprivate var tobeMailedBtn:UIButton!
    
    // 已邮寄
    fileprivate var hasbeenMailedBtn:UIButton!
    
    // 待邮寄的tabview
    fileprivate var tobeMailedTabView:UITableView!
    
    // 已邮寄的tabview
    fileprivate var hasbeenMailedTabView:UITableView!
    
    // 去邮寄按钮
    fileprivate var toMailedBtn:UIButton!
    
    // 是否选中了待发货
    fileprivate var isSelectTobe:Bool = true
    
    // 代理
    fileprivate var tobeMailedDelegate:FCMyGiftToBeMailedTabViewDelegate!
    fileprivate var hasBeenMailedDelegate:FCMyGiftHasBeenMailedTabViewDelegate!
    
    // 邮件确认
    fileprivate var mailedConfirmDialog:FCMailedConfirmDialog!
    
//    /// 地址数据
//    fileprivate var addressData = ""
    
    /// 编辑地址
    fileprivate var editAddressDialog:EditAddressDialog!
    
    /// 没有数据时候的view
    fileprivate var noValueImageView:UIImageView!
    
    override func createView() {
        createBackgroundImage(imageName: "待邮寄背景")
        
        backgroundImage.frame.size = CGSize(width: 288, height: 388)
        backgroundImage.center = self.center
        
        createCloseBtn()
        
        editAddressDialog = EditAddressDialog(frame: UIScreen.main.bounds)
        
//        // 关闭按钮
//        closeBtn = UIButton(type: .custom)
//        let closeImage = UIImage(named: "关闭我的奖品")
//        closeBtn.setBackgroundImage(closeImage, for: .normal)
//        closeBtn.frame = CGRect(x: self.bounds.width/2 + backgroundImage.bounds.width/2 - (closeImage?.size.width)!/2 - 5, y: self.bounds.height/2 - backgroundImage.bounds.height/2 + (closeImage?.size.height)!/2 + 5, width: (closeImage?.size.width)!, height: (closeImage?.size.height)!)
//        addSubview(closeBtn)
//        closeBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        // 切换tab背景
        tabBackground = UIImageView(image: UIImage(named: "点击背景"))
        addSubview(tabBackground)
        tabBackground.frame = CGRect(x: self.bounds.width/2 - tabBackground.bounds.width/2, y: self.bounds.height/2 - backgroundImage.bounds.height / 2 + 65, width: tabBackground.bounds.width, height: tabBackground.bounds.height)
        
        // 待邮寄
        tobeMailedBtn = UIButton()
        tobeMailedBtn.setBackgroundImage(UIImage(named: "待邮寄未点"), for: .normal)
        tobeMailedBtn.setBackgroundImage(UIImage(named: "待邮寄未点"), for: .highlighted)
        tobeMailedBtn.setBackgroundImage(UIImage(named: "待邮寄已点"), for: .selected)
        tobeMailedBtn.sizeToFit()
        
        addSubview(tobeMailedBtn)
        tobeMailedBtn.addTarget(self, action: #selector(changeSelectTab), for: .touchUpInside)
        tobeMailedBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(tabBackground)
            make.left.equalTo(tabBackground).offset(2)
        }
        
        tobeMailedBtn.isUserInteractionEnabled = false
        tobeMailedBtn.isSelected = true
        
        // 已邮寄
        hasbeenMailedBtn = UIButton()
        hasbeenMailedBtn.setBackgroundImage(UIImage(named: "已邮寄未点"), for: .normal)
        hasbeenMailedBtn.setBackgroundImage(UIImage(named: "已邮寄未点"), for: .highlighted)
        hasbeenMailedBtn.setBackgroundImage(UIImage(named: "已邮寄已点"), for: .selected)
        hasbeenMailedBtn.sizeToFit()
        addSubview(hasbeenMailedBtn)
        hasbeenMailedBtn.addTarget(self, action: #selector(changeSelectTab), for: .touchUpInside)
        hasbeenMailedBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(tabBackground)
            make.left.equalTo(self.bounds.width/2)
        }
        
        // 去邮寄
        toMailedBtn = UIButton(type: .custom)
        toMailedBtn.setBackgroundImage(UIImage(named: "按钮我要邮寄"), for: .normal)
        toMailedBtn.sizeToFit()
        addSubview(toMailedBtn)
        
        toMailedBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImage).offset(toMailedBtn.bounds.height/2 - 5)
            make.centerX.equalTo(self)
        }
        
        toMailedBtn.addTarget(self, action: #selector(showMailedConfirmDialog), for: .touchUpInside)
        
        mailedConfirmDialog = FCMailedConfirmDialog(frame: self.bounds)
        
        /// 没数据的view
        noValueImageView = UIImageView(image: UIImage(named: "没奖品"))
        noValueImageView.sizeToFit()
        addSubview(noValueImageView)
        
        noValueImageView.center = backgroundImage.center
        
        noValueImageView.isHidden = true
        
        setupTabViews()
        
        addDialogToWindow()
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
        mailedConfirmDialog.createView()
        mailedConfirmDialog.show()
    }
    
    func reBackShowMailedConfirm(userInfo:String, phoneNumber:String, address:String) -> () {
        /// 组装数据
        var sendData = [JSON]()
        for key in Array(tobeMailedDelegate.selectList.keys) {
            sendData.append(tobeMailedDelegate.dataSource[key])
        }
        
        mailedConfirmDialog.userInfoData = userInfo
        mailedConfirmDialog.phoneNumberData = phoneNumber
        mailedConfirmDialog.addressData = address
        
        mailedConfirmDialog.sendData.removeAll()
        mailedConfirmDialog.sendData = sendData
        
        mailedConfirmDialog.mailedSuccessCallback = { [weak self] in
            self?.getTobeMailedGiftList(isRefresh: true)
            self?.getMailedGiftList(isRefresh: true)
        }
        
        mailedConfirmDialog.createView()
        mailedConfirmDialog.show()

    }
    
    /// 未邮寄数据
    fileprivate var tobeMailedListData = [JSON]()
    
    override func hide() {
        super.hide()
        for subView in subviews {
            subView.removeFromSuperview()
        }
        self.tobeMailedDelegate.dataSource.removeAll()
        self.hasBeenMailedDelegate.dataSource.removeAll()
        editAddressDialog = nil
    }
    
}

// 顶部tab切换逻辑
extension MyGiftDialog{
    
    @objc func changeSelectTab() -> () {
        if isSelectTobe {
            isSelectTobe = false
            tobeMailedBtn.isUserInteractionEnabled = true
            hasbeenMailedBtn.isUserInteractionEnabled = false
            tobeMailedBtn.isSelected = false
            hasbeenMailedBtn.isSelected = true
            
            tobeMailedTabView.isHidden = true
            hasbeenMailedTabView.isHidden = false
            
            if hasBeenMailedDelegate.dataSource.count <= 0 {
                noValueImageView.isHidden = false
            }else{
                noValueImageView.isHidden = true
            }
            
        }else {
            isSelectTobe = true
            tobeMailedBtn.isUserInteractionEnabled = false
            hasbeenMailedBtn.isUserInteractionEnabled = true
            tobeMailedBtn.isSelected = true
            hasbeenMailedBtn.isSelected = false
            
            tobeMailedTabView.isHidden = false
            hasbeenMailedTabView.isHidden = true
            
            if tobeMailedDelegate.dataSource.count <= 0 {
                noValueImageView.isHidden = false
            }else{
                noValueImageView.isHidden = true
            }
            
        }
    }
    
}

// tabview
extension MyGiftDialog{
    
    func setupTabViews() -> () {
        
        // 待邮寄
        tobeMailedDelegate = FCMyGiftToBeMailedTabViewDelegate()
        
        tobeMailedTabView = UITableView()
        addSubview(tobeMailedTabView)
        tobeMailedTabView.backgroundColor = UIColor.clear
        tobeMailedTabView.delegate = tobeMailedDelegate
        tobeMailedTabView.dataSource = tobeMailedDelegate
        tobeMailedTabView.separatorColor = UIColor.clear
        tobeMailedTabView.showsVerticalScrollIndicator = false
        tobeMailedTabView.register(FCMyGiftCell.self, forCellReuseIdentifier: "cellId")
        
        tobeMailedTabView.snp.makeConstraints { (make) in
            make.top.equalTo(tabBackground).offset(tabBackground.bounds.height + 10)
            make.centerX.equalTo(self)
            make.bottom.equalTo(backgroundImage).offset(-50)
            make.width.equalTo((UIImage(named: "内容块")?.size.width)!)
        }
        
        // 已邮寄
        hasBeenMailedDelegate = FCMyGiftHasBeenMailedTabViewDelegate()
        
        let hasBeenContentBackgroundImage = UIImage(named: "has_been_content_background")
        
        hasbeenMailedTabView = UITableView()
        addSubview(hasbeenMailedTabView)
        hasbeenMailedTabView.backgroundColor = UIColor.clear
        hasbeenMailedTabView.separatorColor = UIColor.clear
        hasbeenMailedTabView.showsVerticalScrollIndicator = false
        
        hasbeenMailedTabView.delegate = hasBeenMailedDelegate
        hasbeenMailedTabView.dataSource = hasBeenMailedDelegate
        hasbeenMailedTabView.register(FCMyGiftHasBeenMailedCell.self, forCellReuseIdentifier: "cellId")
        
        hasbeenMailedTabView.snp.makeConstraints { (make) in
            make.top.equalTo(tabBackground).offset(tabBackground.bounds.height + 10)
            make.centerX.equalTo(self)
            make.bottom.equalTo(backgroundImage).offset(-50)
            make.width.equalTo((hasBeenContentBackgroundImage!.size.width))
        }
        
        hasbeenMailedTabView.isHidden = true
        
        getTobeMailedGiftList(isRefresh: true)
        
        getMailedGiftList(isRefresh: true)
    }
}

// MARK: - 获取未邮寄礼物列表
extension MyGiftDialog{
    
    func getTobeMailedGiftList(isRefresh:Bool) -> () {
        getUserAddress()
        
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "150"
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
                
                self.tobeMailedTabView.reloadData()
                
                self.showTobeMailedNoValue()
                
            }else{
                self.showTobeMailedNoValue()
            }
        }
    }
    
    func showTobeMailedNoValue() -> () {
        /// 如果list是隐藏状态，就不用继续进行操作了
        if tobeMailedTabView.isHidden != false {
            return
        }
        
        if self.tobeMailedDelegate.dataSource.count <= 0 {
            self.noValueImageView.isHidden = false
        }else{
            self.noValueImageView.isHidden = true
        }
    }
    
    func setupTobeMailedGiftListData() -> () {
        
    }
}

/// 获取已邮寄的列表
extension MyGiftDialog{
    
    func getMailedGiftList(isRefresh:Bool) -> () {
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "150"
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
            noValueImageView.isHidden = false
        }else{
            noValueImageView.isHidden = true
        }
    }
    
}

// MARK: - 获取用户的地址信息
extension MyGiftDialog{
    
    func getUserAddress() -> () {
//        ToastUtils.showLoadingToast(msg: "请稍后……")
//        Alamofire.request(Constants.Network.Gift.GET_USER_ADDRESS, method: .post, parameters: NetWorkUtils.createBaseParams(), encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
//            let json = JSON(response.result.value!)
//            self.addressData = json["data"].stringValue
//            print("result:\(response.result.value)")
//            ToastUtils.hide()
//        }
    }
    
}













