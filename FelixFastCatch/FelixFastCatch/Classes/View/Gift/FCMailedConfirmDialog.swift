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
    
    override func createView() {
        createBackgroundImage(imageName: "信息确认背景")
        createCloseBtn()
   
        editAddressDialog = EditAddressDialog(frame: UIScreen.main.bounds)
        
        print("sendData:\(sendData)")
        
        contentImagesLine = sendData.count/4
        
        if contentImagesLine <= 0 {
            contentImagesLine = 1
        }
        
        scrollRootView.frame = CGRect(x: self.bounds.width/2 - backgroundImage.bounds.width/2 + 20, y: self.bounds.height/2 - backgroundImage.bounds.height/2 + 70, width: backgroundImage.bounds.width - 40, height:  backgroundImage.bounds.height - 85)
        
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
        userInfo.outLineWidth = 2
        userInfo.outTextColor = UIColor.white
        userInfo.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        userInfo.font = UIFont.systemFont(ofSize: CGFloat(12))
        userInfo.text = "收货人 : " + userInfoData
        userInfo.numberOfLines = 1
        userInfo.sizeToFit()
        scrollRootView.addSubview(userInfo)
        userInfo.frame = CGRect(x: 0, y: 0, width: scrollRootView.bounds.width - 30, height: userInfo.bounds.height)
        
        // 手机号
        phoneNumber = MainCustomerLabel()
        phoneNumber.outLineWidth = 2
        phoneNumber.outTextColor = UIColor.white
        phoneNumber.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        phoneNumber.font = UIFont.systemFont(ofSize: CGFloat(12))
        phoneNumber.text = "手机号 : " + phoneNumberData
        phoneNumber.numberOfLines = 1
        phoneNumber.sizeToFit()
        scrollRootView.addSubview(phoneNumber)
        
        phoneNumber.frame = CGRect(x: 0, y: userInfo.bounds.height + 10, width: scrollRootView.bounds.width, height: phoneNumber.bounds.height)
        
        // 地址
        address = MainCustomerLabel()
        address.outLineWidth = 2
        address.outTextColor = UIColor.white
        address.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        address.font = UIFont.systemFont(ofSize: CGFloat(12))
        address.text = "地址 : " + addressData
        address.numberOfLines = 2
        let paraph = NSMutableParagraphStyle()
        //行间距
        paraph.lineSpacing = 5
        paraph.alignment = .left
        //样式属性集合
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                          NSParagraphStyleAttributeName: paraph]
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
        postageTitleLabel.outLineWidth = 2
        postageTitleLabel.outTextColor = UIColor.white
        postageTitleLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        postageTitleLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        postageTitleLabel.text = "邮费"
        postageTitleLabel.sizeToFit()
        scrollRootView.addSubview(postageTitleLabel)
        
        postageTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(postageHelper).offset(postageHelper.bounds.width + 2)
            make.centerY.equalTo(postageHelper)
        }
        
        //邮费
        postageLabel.outLineWidth = 2
        postageLabel.outTextColor = UIColor.white
        postageLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        postageLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        postageLabel.text = "免邮"
        postageLabel.textAlignment = .right
        postageLabel.sizeToFit()
        scrollRootView.addSubview(postageLabel)
        
        postageLabel.frame = CGRect(x: 0, y: postageHelperY + 2, width: scrollRootView.bounds.width, height: postageLabel.bounds.height)
        
        // 免邮
        freemailNumberLabel.outLineWidth = 2
        freemailNumberLabel.outTextColor = UIColor.white
        freemailNumberLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        freemailNumberLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        freemailNumberLabel.text = "本月剩余免邮次数:1次"
        freemailNumberLabel.sizeToFit()
        scrollRootView.addSubview(freemailNumberLabel)
        
        freemailNumberLabel.frame = CGRect(x: 0, y: postageHelperY + postageHelper.bounds.height + 10, width: scrollRootView.bounds.width, height: postageLabel.bounds.height)
        
        let rootHeightSize = postageHelperY + postageHelper.bounds.height + 10 + freemailNumberLabel.bounds.height
        
        scrollRootView.contentSize = CGSize(width: backgroundImage.bounds.width - 35, height: rootHeightSize)
        
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
        confirmBtn.setImage(UIImage(named:"邮寄信息确认按钮"), for: .normal)
        confirmBtn.sizeToFit()
        addSubview(confirmBtn)
        
        confirmBtn.addTarget(self, action: #selector(maild), for: .touchUpInside)
        
        confirmBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImage).offset(confirmBtn.bounds.height/2)
            make.centerX.equalTo(backgroundImage)
        }
        
        addDialogToWindow()
    }
    
    func editAddress() -> () {
        editAddressDialog.userName = userInfoData
        editAddressDialog.phoneNumber = phoneNumberData
        editAddressDialog.address = addressData
        
        editAddressDialog.createView()
        editAddressDialog.show()
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
        hasBeenContentBackgroundImage = UIImage(named: "has_been_content_background")
        contentBacngroundImage = UIImageView()
        contentBacngroundImage.image = hasBeenContentBackgroundImage
        scrollRootView.addSubview(contentBacngroundImage)
        
        let hasBeenProductBackground = UIImage(named: "已邮寄产品框")
        
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(4, 0, 4, 0);
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 4
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: CGFloat((scrollRootView.bounds.width - 20)/4-12), height: CGFloat((hasBeenProductBackground?.size.height)!))
        
        let groupY = userInfo.bounds.height + phoneNumber.bounds.height + address.bounds.height + 10 + 2
        productsGroup = UICollectionView(frame: CGRect(x: 10, y: groupY, width: scrollRootView.bounds.width - 20, height: (hasBeenProductBackground?.size.height)! * CGFloat(contentImagesLine) + CGFloat(4 * contentImagesLine) + 4), collectionViewLayout: layout)
        productsGroup.backgroundColor = UIColor.clear
        
        productsGroup.delegate = self
        productsGroup.dataSource = self
        
        productsGroup.register(FCHasBennMailedProductCell.self, forCellWithReuseIdentifier: "cellId")
        
        productsGroup.isScrollEnabled = false
        
        contentBacngroundImage.frame = CGRect(x: 0, y: groupY, width: scrollRootView.bounds.width, height: productsGroup.bounds.height)
        
        scrollRootView.addSubview(productsGroup)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sendData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? FCHasBennMailedProductCell
        return cell!
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

// MARK: - btns
extension FCMailedConfirmDialog{
    
    /// 通知后台，开始邮寄
    func maild() -> () {
        ToastUtils.showLoadingToast(msg: "请稍后……")
        
        var ids = ""
        for item in sendData {
            ids.append("id=" + String(item["id"].stringValue) + "&")
        }
        
        var params = NetWorkUtils.createBaseParams()
        params["id"] = ids
        
        Alamofire.request(Constants.Network.Gift.CREATE_POSTAGE, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
//                print("result:\(response.result.value)")
            }
            ToastUtils.hide()
        }
    }
    
}












