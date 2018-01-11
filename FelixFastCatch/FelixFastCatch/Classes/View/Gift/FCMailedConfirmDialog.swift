//
//  FCMailedConfirmDialog.swift
//  FastCatch
//
//  Created by 卢凡 on 2017/7/22.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class FCMailedConfirmDialog: BaseDialog {

    // 购买人信息
    fileprivate var userInfo:MainCustomerLabel!
    
    // 手机号
    fileprivate var phoneNumber:MainCustomerLabel!
    
    // 地址
    fileprivate var address:MainCustomerLabel!
    
    var userInfoData = ""
    var phoneNumberData = ""
    var addressData = ""
    
    /// 是否是线上奖品
    var isOnline = false
    
    /// 要发送的礼品
    var sendData = [JSON]()
    
    /// 根布局
    fileprivate lazy var scrollRootView:UIScrollView = UIScrollView()
    
    /// 邮费
    var postageLabel:MainCustomerLabel = MainCustomerLabel()
    
    /// 免邮次数
    var freemailNumberLabel:MainCustomerLabel = MainCustomerLabel()
    
    /// 中心区域的图片数组占用多少行
    var contentImagesLine:Int!
    
    /// 确认按钮
    var confirmBtn:UIButton = UIButton(type: UIButtonType.custom)
    
    var editAddressDialog:EditAddressDialog!
    
    /// 提交成功的dialog
    fileprivate var successDialog:MailedSuccessDialog!

    /// 邮寄成功的回调，回调上一个接口刷新list
    var mailedSuccessCallback:(()->())? = nil
    
    var freePostageNumber = 0
    var postageCashNumber = 0
    
    /// 邮费不足的dialog
    fileprivate var cashShortDialog:MailedCashShortDialog!
    
    override func createView() {
        if isOnline {
            createBackgroundImage(imageName: "提取信息背景")
        }else{
            createBackgroundImage(imageName: "信息确认背景")
        }
        
        backgroundImage.frame.size = CGSize(width: 290, height: 388)
        backgroundImage.center = self.center
        
        cashShortDialog = MailedCashShortDialog(frame: UIScreen.main.bounds)
        
        createCloseBtn()
   
        editAddressDialog = EditAddressDialog(frame: UIScreen.main.bounds)
        
        contentImagesLine = sendData.count/4
        
        if contentImagesLine <= 0 {
            contentImagesLine = 1
        }else{
            if sendData.count%4 != 0 {
                contentImagesLine = contentImagesLine + 1
            }
        }
        
        scrollRootView.frame = CGRect(x: self.bounds.width/2 - backgroundImage.bounds.width/2 + 20, y: self.bounds.height/2 - backgroundImage.bounds.height/2 + 70, width: backgroundImage.bounds.width - 40, height:  backgroundImage.bounds.height - 105)
        
        scrollRootView.alwaysBounceHorizontal = false
        addSubview(scrollRootView)
        
        // 返回按钮
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "返回"), for: .normal)
        backBtn.sizeToFit()
        addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(backgroundImage).offset(30)
            make.left.equalTo(backgroundImage).offset(-backBtn.bounds.width/2)
        }
        
        backBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        // 购买人
        userInfo = MainCustomerLabel()
        userInfo.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        userInfo.outTextColor = UIColor.white
        userInfo.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        userInfo.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        userInfo.text = "收货人 : " + Constants.User.addrName
        userInfo.numberOfLines = 1
        userInfo.sizeToFit()
        scrollRootView.addSubview(userInfo)
        userInfo.frame = CGRect(x: 0, y: 0, width: scrollRootView.bounds.width - 30, height: userInfo.bounds.height)
        
        // 手机号
        phoneNumber = MainCustomerLabel()
        phoneNumber.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        phoneNumber.outTextColor = UIColor.white
        phoneNumber.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        phoneNumber.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        phoneNumber.text = "手机号 : " + Constants.User.addrPhone
        phoneNumber.numberOfLines = 1
        phoneNumber.sizeToFit()
        scrollRootView.addSubview(phoneNumber)
        
        phoneNumber.frame = CGRect(x: 0, y: userInfo.bounds.height + 10, width: scrollRootView.bounds.width, height: phoneNumber.bounds.height)
        
        // 地址
        address = MainCustomerLabel()
        address.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        address.outTextColor = UIColor.white
        address.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        address.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        address.text = "地址 : " + Constants.User.addr
        address.numberOfLines = 2
        let paraph = NSMutableParagraphStyle()
        //行间距
        paraph.lineSpacing = 5
        paraph.alignment = .left
        //样式属性集合
        let attributes = [
                          NSAttributedStringKey.paragraphStyle: paraph]
        address.attributedText = NSAttributedString(string: address.text!, attributes: attributes)
        address.sizeToFit()
        scrollRootView.addSubview(address)
        
        address.frame = CGRect(x: 0, y: userInfo.bounds.height + phoneNumber.bounds.height + 10, width: scrollRootView.bounds.width, height: address.bounds.height * 2 + 5)
        
        createSendDataGroup()
        
        //qa btn
        let postageHelper = UIButton(type: .custom)
        postageHelper.setImage(UIImage(named: "邮费按钮"), for: .normal)
        postageHelper.sizeToFit()
        
        scrollRootView.addSubview(postageHelper)
        
        let postageHelperY = userInfo.bounds.height + phoneNumber.bounds.height + address.bounds.height + productsGroup.bounds.height + 10*2 + 10
        
        
        postageHelper.frame = CGRect(x: 0, y: postageHelperY, width: postageHelper.bounds.width, height: postageHelper.bounds.height)
        
        // 邮费标题
        let postageTitleLabel = MainCustomerLabel()
        postageTitleLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        postageTitleLabel.outTextColor = UIColor.white
        postageTitleLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        postageTitleLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        postageTitleLabel.text = "邮费"
        postageTitleLabel.sizeToFit()
        scrollRootView.addSubview(postageTitleLabel)
        
        postageTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(postageHelper).offset(postageHelper.bounds.width + 2)
            make.centerY.equalTo(postageHelper)
        }
        
        //邮费
        postageLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        postageLabel.outTextColor = UIColor.white
        postageLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        postageLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        if isOnline {
            postageLabel.text = "免费"
        }else{
            if freePostageNumber <= 0 {
                postageLabel.text = String(postageCashNumber) + "代币"
            }else{
                postageLabel.text = "免费"
            }
        }
        postageLabel.textAlignment = .right
        postageLabel.sizeToFit()
        scrollRootView.addSubview(postageLabel)
        
        postageLabel.frame = CGRect(x: 0, y: postageHelperY + 2, width: scrollRootView.bounds.width, height: postageLabel.bounds.height)
        
        // 免邮
        freemailNumberLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        freemailNumberLabel.outTextColor = UIColor.white
        freemailNumberLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        freemailNumberLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        freemailNumberLabel.text = "9月30日前限时免邮"
        freemailNumberLabel.sizeToFit()
        scrollRootView.addSubview(freemailNumberLabel)
        
        freemailNumberLabel.frame = CGRect(x: 0, y: postageHelperY + postageHelper.bounds.height + 10, width: scrollRootView.bounds.width, height: postageLabel.bounds.height)
        
        freemailNumberLabel.isHidden = true
        
        let rootHeightSize = postageHelperY + postageHelper.bounds.height + 10 + freemailNumberLabel.bounds.height
        
        scrollRootView.contentSize = CGSize(width: backgroundImage.bounds.width - 40, height: rootHeightSize)
        
        /// 编辑地址
        let changeAddressBtn = UIButton(type: .custom)
        changeAddressBtn.setImage(UIImage(named: "编辑按钮"), for: .normal)
        changeAddressBtn.sizeToFit()
        addSubview(changeAddressBtn)
        
        changeAddressBtn.snp.makeConstraints { (make) in
            make.right.equalTo(scrollRootView)
            make.centerY.equalTo(userInfo)
        }
        
        changeAddressBtn.addTarget(self, action: #selector(editAddress), for: .touchUpInside)
        
        /// 确认邮寄按钮
        if isOnline {
            confirmBtn.setImage(UIImage(named:"确认提取按钮"), for: .normal)
        }else{
            confirmBtn.setImage(UIImage(named:"邮寄信息确认按钮"), for: .normal)
        }
        confirmBtn.sizeToFit()
        addSubview(confirmBtn)
        
        confirmBtn.addTarget(self, action: #selector(maild), for: .touchUpInside)
        
        confirmBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImage).offset(confirmBtn.bounds.height/2)
            make.centerX.equalTo(backgroundImage)
        }
        
        addDialogToWindow()
    }
    
    func reloadInfo() -> () {
        userInfo.text = "收货人 : " + Constants.User.addrName
        phoneNumber.text = "手机号 : " + Constants.User.addrPhone
        address.text = "地址 : " + Constants.User.addr
    }
    
    @objc func editAddress() -> () {
        editAddressDialog.userName = userInfoData
        editAddressDialog.phoneNumber = phoneNumberData
        editAddressDialog.address = addressData
        
        editAddressDialog.createView(mailedConfirm: self)
        editAddressDialog.show()
    }
    
    /// 显示成功的dialog
    func showSuccessDialog() -> () {
        if successDialog == nil {
            successDialog = MailedSuccessDialog(frame: UIScreen.main.bounds)
        }
        successDialog.createView()
        successDialog.show()
    }
    
    override func hide() {
        super.hide()
        scrollRootView.removeFromSuperview()
        for subview in scrollRootView.subviews {
            subview.removeFromSuperview()
        }
        for subview in (self.subviews) {
            subview.removeFromSuperview()
        }
    }
    
    fileprivate var hasBeenContentBackgroundImage:UIImage!
    
    // 主要内容的背景图
    fileprivate var contentBacngroundImage:UIImageView!
    
    // 商品图标集合
    fileprivate var productsGroup:UICollectionView!
}

// MARK: - 装载数据内容
extension FCMailedConfirmDialog:UICollectionViewDelegate, UICollectionViewDataSource{
    
    /// 创建发送数据的Group
    func createSendDataGroup() -> () {
        hasBeenContentBackgroundImage = UIImage(named: "has_been_content_background")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        contentBacngroundImage = UIImageView()
        scrollRootView.addSubview(contentBacngroundImage)
        
        let hasBeenProductBackground = UIImage(named: "产品框")
        
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0);
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 3
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: CGFloat((scrollRootView.bounds.width - 20)/4-14), height: CGFloat((hasBeenProductBackground?.size.height)!))
        
        let headerHeight = userInfo.bounds.height + 10
        layout.headerReferenceSize = CGSize(width: scrollRootView.bounds.width, height: headerHeight)
        
        let groupY = userInfo.bounds.height + phoneNumber.bounds.height + address.bounds.height + 10 + 2
        productsGroup = UICollectionView(frame: CGRect(x: 10, y: groupY, width: scrollRootView.bounds.width - 20, height: (hasBeenProductBackground?.size.height)! * CGFloat(contentImagesLine) + CGFloat(3 * contentImagesLine) + 3 + headerHeight), collectionViewLayout: layout)
        productsGroup.backgroundColor = UIColor.clear
        
        productsGroup.delegate = self
        productsGroup.dataSource = self
        
        productsGroup.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        productsGroup.register(FCHasBennMailedProductCell.self, forCellWithReuseIdentifier: "cellId")
        
        productsGroup.isScrollEnabled = false
        
        contentBacngroundImage.frame = CGRect(x: 0, y: groupY, width: scrollRootView.bounds.width, height: productsGroup.bounds.height + 8)
        contentBacngroundImage.image = hasBeenContentBackgroundImage
        
        scrollRootView.addSubview(productsGroup)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sendData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? FCHasBennMailedProductCell
        
        cell?.productImage.kf.setImage(with: URL(string: sendData[indexPath.row]["img"].stringValue))
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusable = UICollectionReusableView()
        
        if kind == UICollectionElementKindSectionHeader {
            reusable = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            let titleLabel = MainCustomerLabel()
            titleLabel.text = "邮寄奖品共（\(sendData.count)）件"
            titleLabel.outLineWidth = 1
            titleLabel.outTextColor = UIColor.white
            titleLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
            titleLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
            titleLabel.sizeToFit()
            titleLabel.frame = CGRect(x: 0, y: 10, width: titleLabel.bounds.width, height: titleLabel.bounds.height)
            reusable.addSubview(titleLabel)
        }
        
        return reusable
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

// MARK: - btns
extension FCMailedConfirmDialog{
    
    /// 通知后台，开始邮寄
    @objc func maild() -> () {
        if !checkAddress() && isOnline == false {
            return /// 非实物奖品，有没有地址无所谓
        }
        
        ToastUtils.showLoadingToast(msg: "请稍后……")
        
        var ids = ""
        for i in 0..<sendData.count {
            let item = sendData[i]
            ids.append("id=" + String(item["id"].stringValue))
            if i != sendData.count - 1 {
                ids.append("&")
            }
        }
        
        var params = NetWorkUtils.createBaseParams()
        params["id"] = ids
        
        Alamofire.request(Constants.Network.Gift.CREATE_POSTAGE + "?" + ids, method: .get).responseJSON { (response) in
            ToastUtils.hide()
            if response.error == nil && response.data != nil {
                print("result:\(response.result.value!)")
                let jsonData = JSON(data: response.data!)
                if jsonData["code"].int! == 0 {
                    if self.mailedSuccessCallback != nil {
                        self.mailedSuccessCallback?()
                    }
                    self.hide()
                    self.showSuccessDialog()
                }else if jsonData["code"].int! == -302 {
                    print("用户身份异常，重新登录")
                    if !Constants.isFastLoginShow {
                        let loginDialog = FastLoginDialog(frame: UIScreen.main.bounds)
                        loginDialog.createView()
                        loginDialog.show()
                    }
                    LocalDataUtils.clearLoaclData()
                }else if jsonData["code"].int! == -1 {
                    /// 邮费不足
                    self.cashShortDialog.createView()
                    self.cashShortDialog.show()
                }
            }else{
                print("error:\(String(describing: response.error))")
            }
        }
    }
    
    func checkAddress() -> Bool {
        if Constants.User.addressId == "" {
            ToastUtils.showErrorToast(msg: "请填写地址")
            return false
        }
        
        if Constants.User.addrName == "" {
            ToastUtils.showErrorToast(msg: "请填写收件人")
            return false
        }
        
        if Constants.User.addrPhone == "" {
            ToastUtils.showErrorToast(msg: "请填写手机号")
            return false
        }
        
        if Constants.User.addr == "" {
            ToastUtils.showErrorToast(msg: "请填写详细地址")
            return false
        }
        
        return true
    }
    
}












