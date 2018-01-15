//
//  ZeroCatchView.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/10.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class ZeroCatchView: UIView {

    let backgroundView = UIView()
    
    let backgroundImageView = UIImageView(image: UIImage(named: "游戏成功购买背景"))
    
    let closeView = UIView()
    
    /// 商品图片
    var productImage = UIImageView()
    
    /// 商品名称
    var productTitle = UILabel()
    
    /// 商品简介
    var productDesc = UILabel()
    
    /// 商品抓中价
    var productPrice = UILabel()
    
    /// 商品原价
    var productOriPrice = UILabel()
    
    /// 收入囊中的按钮
    var payButton = UIButton(type: UIButtonType.custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundView.frame = UIScreen.main.bounds
        backgroundView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        addSubview(backgroundView)
        
        backgroundImageView.sizeToFit()
        addSubview(backgroundImageView)
        
        backgroundImageView.center = self.center
        
        addSubview(closeView)
        
        closeView.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundImageView)
            make.top.equalTo(backgroundImageView)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        closeView.isUserInteractionEnabled = true
        closeView.addGestureRecognizer(tap)
        
        let dialogTitle = UILabel()
        dialogTitle.font = UIFont.getCustomeYuanTiFont(fontSize: 18)
        dialogTitle.text = "抓中啦"
        dialogTitle.sizeToFit()
        addSubview(dialogTitle)
        
        dialogTitle.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImageView).offset(10)
            make.centerX.equalTo(backgroundImageView)
        }
        
        
        /// 商品图片
        productImage.frame = CGRect(x: Int(self.bounds.width/2 - 60), y: Int(self.bounds.height/2 - backgroundImageView.bounds.height/2 + 20 + dialogTitle.bounds.height), width: 120, height: 120)
        addSubview(productImage)
        
        ///商品名称
        productTitle.font = UIFont.getCustomeYuanTiFont(fontSize: 18)
        productTitle.text = "MZ美妆盒"
        productTitle.numberOfLines = 1
        productTitle.sizeToFit()
        addSubview(productTitle)
        
        productTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(productImage).offset(productImage.bounds.height + 10)
        }
        
        ///商品简介
        productDesc.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        productDesc.text = "MZ美妆盒"
        productDesc.numberOfLines = 1
        productDesc.textColor = UIColor.gray
        productDesc.sizeToFit()
        addSubview(productDesc)
        
        productDesc.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(productTitle).offset(productTitle.bounds.height + 2)
        }
        
        ///抓中价格
        productPrice.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        productPrice.numberOfLines = 1
        addSubview(productPrice)

        productPrice.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(productDesc).offset(productDesc.bounds.height + 10)
        }
        
        /// 原价
        productOriPrice.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
        productOriPrice.numberOfLines = 1
        productOriPrice.textColor = UIColor.gray
        addSubview(productOriPrice)
        
        updateProductPriceNumber(price: 9.9, oPrice: "京东价：1w")
        
        productOriPrice.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(productPrice).offset(productPrice.bounds.height + 2)
        }
        
        
        
        /// 收入囊中
        payButton.setBackgroundImage(UIImage(named: "收入囊中"), for: .normal)
        payButton.setBackgroundImage(UIImage(named: "收入囊中点击"), for: .highlighted)
        payButton.sizeToFit()
        addSubview(payButton)
        
        payButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundImageView).offset(-20)
            make.centerX.equalTo(backgroundImageView)
        }
    }
    
    /// 更新价格
    func updateProductPriceNumber(price:Double, oPrice:String) {
        let attrText = NSMutableAttributedString.init(string: "秒抓价:\(price)元")
        attrText.addAttribute(NSAttributedStringKey.font, value: UIFont.getCustomeYuanTiFont(fontSize: 16), range: NSRange(location: 4, length:String(price).count))
        attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 4, length:String(price).count))
        productPrice.attributedText = attrText
        productPrice.sizeToFit()
        
        let oAttrText = NSMutableAttributedString.init(string: oPrice)
        oAttrText.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: oPrice.count))
        productOriPrice.attributedText = oAttrText
    }
    
    func show() {
        self.transform = CGAffineTransform(scaleX: 1.2,y: 1.2);
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 1,y: 1)
            self?.isHidden = false
            self?.backgroundView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        }
    }
    
    @objc func hide() {
        self.backgroundView.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.6,y: 0.6)
            self?.alpha = 0.0
        }) { (isEnd) in
            self.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
