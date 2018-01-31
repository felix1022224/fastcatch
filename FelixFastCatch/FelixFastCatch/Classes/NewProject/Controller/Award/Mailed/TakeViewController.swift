
//
//  TakeViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/30.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class TakeViewController: BaseActionBarViewController {

    var sendData = [JSON]()
    
    var isOnline = false
    
    /// 未填写地址的view
    var notValueView = UIView()
    
    /// 已填写地址的view
    var addressValueView = UIView()
    
    var addressName = UILabel()
    var addressPhoneNumber = UILabel()
    var addressInfo = UILabel()
    
    /// 发货内容的view
    var centerGroupView = UIView()
    var collectionView:UICollectionView!
    
    let mailedPriceNumberLabel = UILabel()
    let freeMailedPriceNumberLabel = UILabel.init()
    
    var freePostageNumber = 0
    var postageCashNumber = 0
    
    var mailedCallback:(()->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isOnline {
            actionTitleLabel.text = "确认提取"
        }else{
            actionTitleLabel.text = "确认订单"
        }
        
        createNotAddress()
        createAdress()
        
        if Constants.User.addressId == "" {
            // 没有地址
            notValueView.isHidden = false
            addressValueView.isHidden = true
        }else{
            notValueView.isHidden = true
            addressValueView.isHidden = false
        }
        
        notValueView.isUserInteractionEnabled = true
        addressValueView.isUserInteractionEnabled = true
        
        let showEditView = UITapGestureRecognizer.init(target: self, action: #selector(showEditAddressVC))
        notValueView.addGestureRecognizer(showEditView)
        addressValueView.addGestureRecognizer(showEditView)
        
        createContentGroupView()
    }
    
    /// 创建未邮寄的地址
    func createNotAddress() {
        notValueView.frame = CGRect.init(x: 0, y: headView.bounds.height + 5, width: UIScreen.main.bounds.width, height: 50)
        notValueView.backgroundColor = UIColor.white
        view.addSubview(notValueView)
        
        let iconImage = UIImageView.init(image: UIImage.init(named: "地址"))
        iconImage.sizeToFit()
        iconImage.frame.origin = CGPoint.init(x: 15, y: notValueView.bounds.height/2 - iconImage.bounds.height/2)
        notValueView.addSubview(iconImage)
        
        let addressLabel = UILabel()
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        let attrText = NSMutableAttributedString.init(string: "收货地址: 请填写您的收货地址")
        attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray, range: NSRange(location: 6, length:9))
        addressLabel.attributedText = attrText
        addressLabel.sizeToFit()
        addressLabel.frame.origin = CGPoint.init(x: iconImage.frame.origin.x + iconImage.bounds.width + 15, y: notValueView.bounds.height/2 - addressLabel.bounds.height/2)
        notValueView.addSubview(addressLabel)
        
        let arrowIcon = UIImageView()
        arrowIcon.image = UIImage.init(named: "我的item箭头")
        arrowIcon.sizeToFit()
        arrowIcon.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 15 - arrowIcon.bounds.width, y: notValueView.bounds.height/2 - arrowIcon.bounds.height/2)
        notValueView.addSubview(arrowIcon)
    }
    
    /// 创建邮寄地址的view
    func createAdress() {
        addressValueView.frame = CGRect.init(x: 0, y: headView.bounds.height + 5, width: UIScreen.main.bounds.width, height: 100)
        addressValueView.backgroundColor = UIColor.white
        view.addSubview(addressValueView)
        
        let iconImage = UIImageView.init(image: UIImage.init(named: "地址"))
        iconImage.sizeToFit()
        iconImage.frame.origin = CGPoint.init(x: 15, y: addressValueView.bounds.height - iconImage.bounds.height - 30)
        addressValueView.addSubview(iconImage)
        
        let lineView = UIImageView.init()
        lineView.frame.size = CGSize.init(width: UIScreen.main.bounds.width, height: 3)
        lineView.image = UIImage.init(named: "地址下划线")
        lineView.frame.origin = CGPoint.init(x: 0, y: addressValueView.bounds.height - lineView.bounds.height)
        addressValueView.addSubview(lineView)
        
        addressName.text = "收货人:\(Constants.User.addrName)"
        addressName.font = UIFont.systemFont(ofSize: 14)
        addressName.sizeToFit()
        addressName.numberOfLines = 1
        addressName.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.4, height: addressName.bounds.height)
        addressName.frame.origin = CGPoint.init(x: 30 + iconImage.bounds.width, y: 15)
        addressValueView.addSubview(addressName)
        
        addressPhoneNumber.text = Constants.User.addrPhone
        addressPhoneNumber.font = UIFont.systemFont(ofSize: 14)
        addressPhoneNumber.sizeToFit()
        addressPhoneNumber.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 25 - addressPhoneNumber.bounds.width, y: 15)
        addressValueView.addSubview(addressPhoneNumber)
        
        addressInfo.text = Constants.User.addr
        addressInfo.font = UIFont.systemFont(ofSize: 14)
        addressInfo.numberOfLines = 2
        addressInfo.sizeToFit()
        addressInfo.frame = CGRect.init(x: addressName.frame.origin.x, y: addressName.bounds.height + addressName.frame.origin.y + 5, width: UIScreen.main.bounds.width - addressName.frame.origin.x * 2, height: addressInfo.bounds.height * 2)
        addressValueView.addSubview(addressInfo)
        
        let arrowIcon = UIImageView()
        arrowIcon.image = UIImage.init(named: "我的item箭头")
        arrowIcon.sizeToFit()
        arrowIcon.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 15 - arrowIcon.bounds.width, y: addressValueView.bounds.height/2 - arrowIcon.bounds.height/2)
        addressValueView.addSubview(arrowIcon)
    }
    
    @objc func showEditAddressVC() {
        let editAddressVC = EditAddressViewController()
        self.navigationController?.pushViewController(editAddressVC, animated: true)
    }
    
    /// 创建内容集合的view
    func createContentGroupView() {
        centerGroupView.backgroundColor = UIColor.white
        
        let productNumber = UILabel.init()
        productNumber.text = "邮寄奖品共 \(sendData.count) 件"
        productNumber.font = UIFont.systemFont(ofSize: 16)
        productNumber.sizeToFit()
        productNumber.frame.origin = CGPoint.init(x: 15, y: 15)
        centerGroupView.addSubview(productNumber)
        
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 10
        let collectionWidth = UIScreen.main.bounds.width - 30
        layout.itemSize = CGSize.init(width: collectionWidth/4, height: collectionWidth/4)
        
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView = UICollectionView.init(frame: CGRect.init(x: 15, y: productNumber.bounds.height + 35, width: collectionWidth, height: (collectionWidth)/4) , collectionViewLayout: layout)
        
        self.collectionView.isPagingEnabled = true;
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.backgroundColor = UIColor.white
        
        self.collectionView.register(TakeProductImageCell.self, forCellWithReuseIdentifier: "cellId")
        centerGroupView.addSubview(collectionView)
        
        if Constants.User.addressId != "" {
            self.centerGroupView.frame.origin = CGPoint.init(x: 0, y: addressValueView.frame.origin.y + addressValueView.bounds.height + 15)
        }else{
            self.centerGroupView.frame.origin = CGPoint.init(x: 0, y: notValueView.frame.origin.y + notValueView.bounds.height + 15)
        }
        
        let line1 = UIView()
        line1.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.95, height: 1)
        line1.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        line1.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width * 0.025, y: collectionView.frame.origin.y + collectionView.bounds.height + 15)
        centerGroupView.addSubview(line1)
        
        let mailedPriceLabel = UILabel()
        mailedPriceLabel.text = "邮费"
        mailedPriceLabel.font = UIFont.systemFont(ofSize: 14)
        mailedPriceLabel.textColor = UIColor.lightGray
        mailedPriceLabel.sizeToFit()
        mailedPriceLabel.frame.origin = CGPoint.init(x: 15, y: line1.frame.origin.y + 50/2 - mailedPriceLabel.bounds.height/2)
        centerGroupView.addSubview(mailedPriceLabel)
        
        if freePostageNumber <= 0 {
            mailedPriceNumberLabel.text = "\(postageCashNumber)代币"
        }else{
            mailedPriceNumberLabel.text = "免费"
        }
        
        mailedPriceNumberLabel.font = UIFont.systemFont(ofSize: 14)
        mailedPriceNumberLabel.sizeToFit()
        mailedPriceNumberLabel.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 15 - mailedPriceNumberLabel.bounds.width, y: line1.frame.origin.y + 50/2 - mailedPriceLabel.bounds.height/2)
        centerGroupView.addSubview(mailedPriceNumberLabel)
        
        let line2 = UIView()
        line2.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.95, height: 1)
        line2.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        line2.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width * 0.025, y: line1.frame.origin.y + 50)
        centerGroupView.addSubview(line2)
        
        let freeMailedPriceLabel = UILabel.init()
        freeMailedPriceLabel.text = "本月免邮次数"
        freeMailedPriceLabel.font = UIFont.systemFont(ofSize: 14)
        freeMailedPriceLabel.textColor = UIColor.gray
        freeMailedPriceLabel.sizeToFit()
        freeMailedPriceLabel.frame.origin = CGPoint.init(x: 15, y: line2.frame.origin.y + 15)
        centerGroupView.addSubview(freeMailedPriceLabel)
        
        freeMailedPriceNumberLabel.text = "\(freePostageNumber)次"
        freeMailedPriceNumberLabel.font = UIFont.systemFont(ofSize: 14)
        freeMailedPriceNumberLabel.sizeToFit()
        freeMailedPriceNumberLabel.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 15 - freeMailedPriceNumberLabel.bounds.width, y: line2.frame.origin.y + 15)
        centerGroupView.addSubview(freeMailedPriceNumberLabel)
        
        centerGroupView.frame.size = CGSize.init(width: UIScreen.main.bounds.width, height: productNumber.bounds.height + 35 + collectionWidth/4 + 15 + 100)
        view.addSubview(centerGroupView)
        
        /// 邮寄按钮
        let confirmButton = UIButton.init(type: UIButtonType.custom)
        confirmButton.setBackgroundImage(UIImage.init(named: "确认邮寄"), for: UIControlState.normal)
        confirmButton.sizeToFit()
        view.addSubview(confirmButton)
        
        confirmButton.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width/2 - confirmButton.bounds.width/2, y: centerGroupView.frame.origin.y + centerGroupView.bounds.height + 25)
        
        confirmButton.addTarget(self, action: #selector(maild), for: UIControlEvents.touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addressName.text = "收货人:\(Constants.User.addrName)"
        addressPhoneNumber.text = Constants.User.addrPhone
        addressInfo.text = Constants.User.addr
        
        addressName.sizeToFit()
        addressPhoneNumber.sizeToFit()
        addressInfo.sizeToFit()
    }
    
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
                let jsonData = JSON(data: response.data!)
                if jsonData["code"].int! == 0 {
                    ToastUtils.showSuccessToast(msg: "发货成功")
                    if self.mailedCallback != nil {
                        self.mailedCallback!()
                    }
                    self.back()
                }else if jsonData["code"].int! == -302 {
                    print("用户身份异常，重新登录")
                    LoginViewController.showLoginVC()
                    LocalDataUtils.clearLoaclData()
                }else if jsonData["code"].int! == -1 {
                    /// 邮费不足
                    ToastUtils.showErrorToast(msg: "代币不足")
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
        return true
    }

}

extension TakeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sendData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! TakeProductImageCell
        
        cell.image.kf.setImage(with: URL.init(string: sendData[indexPath.row]["img"].stringValue))
        
        return cell
    }
    
    
}

