//
//  ZeroCatchSuccessDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/29.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

/// 0元抓抓中成功的弹窗
class ZeroCatchSuccessDialog: BasicDialog {
    
    var dataSources:JSON!
    
    /// 支付的弹窗
    var zeroCatchPayDialog:ZeroCatchPayDialog!
    
    override func createView() {
        createBackgroundImage(imageName: "抓到啦~")
        
        createCloseBtn()
        
        /// 商品图片
        let productImage = UIImageView()
        let productImageSize = CGSize.init(width: backgroundImage.bounds.width * 0.65, height: (backgroundImage.bounds.width * 0.65) * 0.55)
        productImage.frame = CGRect(x: backgroundImage.frame.origin.x + (backgroundImage.bounds.width/2 - productImageSize.width/2), y: backgroundImage.frame.origin.y + backgroundImage.bounds.height * 0.25, width: productImageSize.width, height: productImageSize.height)
        productImage.backgroundColor = UIColor.white
        productImage.layer.cornerRadius = 10
        productImage.layer.borderWidth = 4
        productImage.layer.borderColor = UIColor.white.cgColor
        productImage.layer.masksToBounds = true
        addSubview(productImage)
        
        productImage.kf.setImage(with: URL.init(string: dataSources["img"].stringValue))
        
        let productName = UILabel()
        productName.text = dataSources["title"].stringValue
        productName.font = UIFont.systemFont(ofSize: 16)
        productName.textAlignment = .center
        productName.sizeToFit()
        productName.frame.size = CGSize.init(width: backgroundImage.bounds.width * 0.8, height: productName.bounds.height)
        productName.frame.origin = CGPoint.init(x: backgroundImage.frame.origin.x + (backgroundImage.bounds.width/2 - productName.bounds.width/2), y: productImage.frame.origin.y + productImage.bounds.height + 10)
        addSubview(productName)
        
        let productInfo = UILabel()
        productInfo.text = dataSources["description"].stringValue
        productInfo.font = UIFont.systemFont(ofSize: 12)
        productInfo.textColor = UIColor.gray
        productInfo.textAlignment = .center
        productInfo.sizeToFit()
        productInfo.numberOfLines = 2
        productInfo.frame.size = CGSize.init(width: backgroundImage.bounds.width * 0.8, height: productInfo.bounds.height * 2)
        productInfo.frame.origin = CGPoint.init(x: backgroundImage.frame.origin.x + (backgroundImage.bounds.width/2 - productInfo.bounds.width/2), y: productName.frame.origin.y + productName.bounds.height + 5)
        addSubview(productInfo)
        
        /// 秒抓价
        let fastCatchNumber = UILabel()
        fastCatchNumber.font = UIFont.systemFont(ofSize: 14)
        let attrText = NSMutableAttributedString.init(string: "秒抓价: ￥\(dataSources["buyPrice"].doubleValue)")
        attrText.addAttribute(NSAttributedStringKey.font, value: UIFont.getCustomeYuanTiFont(fontSize: 16), range: NSRange(location: 5, length:String(dataSources["buyPrice"].floatValue).count + 1))
        attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 5, length:String(dataSources["buyPrice"].floatValue).count + 1))
        fastCatchNumber.attributedText = attrText
        fastCatchNumber.textAlignment = .center
        fastCatchNumber.sizeToFit()
        fastCatchNumber.frame.size = CGSize.init(width: backgroundImage.bounds.width * 0.8, height: fastCatchNumber.bounds.height)
        fastCatchNumber.frame.origin = CGPoint.init(x: backgroundImage.frame.origin.x + (backgroundImage.bounds.width/2 - fastCatchNumber.bounds.width/2), y: productInfo.frame.origin.y + productInfo.bounds.height + 15)
        addSubview(fastCatchNumber)
        
        /// 原价
        let productPrice = UILabel()
        productPrice.font = UIFont.systemFont(ofSize: 12)
        productPrice.textAlignment = .center
        let oAttrText = NSMutableAttributedString.init(string: dataSources["otherPrice"].stringValue)
        oAttrText.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: dataSources["otherPrice"].stringValue.count))
        productPrice.attributedText = oAttrText
        productPrice.sizeToFit()
        productPrice.textColor = UIColor.gray
        productPrice.frame.size = CGSize.init(width: backgroundImage.bounds.width * 0.8, height: productPrice.bounds.height)
        productPrice.frame.origin = CGPoint.init(x: backgroundImage.frame.origin.x + (backgroundImage.bounds.width/2 - productPrice.bounds.width/2), y: fastCatchNumber.frame.origin.y + fastCatchNumber.bounds.height + 5)
        addSubview(productPrice)
        
        /// 收入囊中
        let payButton = UIButton.init(type: UIButtonType.custom)
        payButton.setBackgroundImage(UIImage.init(named: "0元抓收入囊中"), for: UIControlState.normal)
        payButton.sizeToFit()
        payButton.frame.origin = CGPoint.init(x: backgroundImage.frame.origin.x + (backgroundImage.bounds.width/2 - payButton.bounds.width/2), y: backgroundImage.frame.origin.y + backgroundImage.bounds.height - 10 - payButton.bounds.height)
        addSubview(payButton)
        
        payButton.addTarget(self, action: #selector(pay), for: UIControlEvents.touchUpInside)
        
        addDialogToWindow()
    }
    
    /// 点击收入囊中
    @objc func pay() {
        hide()
        zeroCatchPayDialog = nil
        zeroCatchPayDialog = ZeroCatchPayDialog.init(frame: UIScreen.main.bounds)
        zeroCatchPayDialog.dataSource = dataSources
        zeroCatchPayDialog.createView()
        zeroCatchPayDialog.show()
    }

}
