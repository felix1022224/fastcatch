//
//  CouponHistoryTableViewCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/8.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class CouponHistoryTableViewCell: UITableViewCell {

    var couponTitle:MainCustomerLabel = MainCustomerLabel()
    
    var couponTime:MainCustomerLabel = MainCustomerLabel()
    
    var couponInfo:MainCustomerLabel = MainCustomerLabel()
    
    let backgroundImage = UIImageView()
    
    var discount:UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        selectionStyle = UITableViewCellSelectionStyle.none
        
        backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: (UIScreen.main.bounds.width - 30) * 0.25)
        backgroundImage.image = UIImage(named: "优惠券已过期item")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        addSubview(backgroundImage)
        
        /// 优惠券标题
        couponTitle.font = UIFont.getCustomeYuanTiFont(fontSize: 18)
        couponTitle.outLineWidth = 0
        couponTitle.outTextColor = UIColor(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1.0)
        couponTitle.outLienTextColor = UIColor.clear
        couponTitle.text = "优惠券标题"
        couponTitle.sizeToFit()
        couponTitle.numberOfLines = 1
        addSubview(couponTitle)
        
        couponTitle.frame = CGRect(x: 15, y: 10, width: self.bounds.width * 0.8, height: couponTitle.bounds.height)
        
        /// 优惠券时间
        couponTime.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        couponTime.outLineWidth = 0
        couponTime.outTextColor = UIColor(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1.0)
        couponTime.outLienTextColor = UIColor.clear
        couponTime.text = "优惠券时间"
        couponTime.sizeToFit()
        couponTime.numberOfLines = 1
        addSubview(couponTime)
        
        couponTime.frame = CGRect(x: couponTitle.frame.origin.x, y: couponTitle.frame.origin.y + couponTitle.bounds.height, width: self.bounds.width * 0.8, height: couponTime.bounds.height)
        
        /// 优惠券简介
        couponInfo.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
        couponInfo.outLineWidth = 0
        couponInfo.outTextColor = UIColor(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 1.0)
        couponInfo.outLienTextColor = UIColor.clear
        couponInfo.text = "优惠券简介"
        couponInfo.sizeToFit()
        couponInfo.numberOfLines = 1
        addSubview(couponInfo)
        
        couponInfo.frame = CGRect(x: couponTitle.frame.origin.x, y: couponTime.frame.origin.y + couponTime.bounds.height, width: self.bounds.width * 0.8, height: couponInfo.bounds.height)
        
        /// 折扣
        discount.font = UIFont.getCustomeYuanTiFont(fontSize: 24)
        discount.text = "9.8折"
        discount.textColor = UIColor.white
        discount.sizeToFit()
        discount.numberOfLines = 1
        addSubview(discount)
        
        discount.frame = CGRect(x: backgroundImage.bounds.width * 0.72 + (backgroundImage.bounds.width * 0.28/2 - discount.bounds.width/2), y: backgroundImage.bounds.height/2 - discount.bounds.height/2, width: discount.bounds.width, height: discount.bounds.height)
        
    }
    
    func updateDiscount() {
        discount.sizeToFit()
        discount.frame = CGRect(x: backgroundImage.bounds.width * 0.72 + (backgroundImage.bounds.width * 0.28/2 - discount.bounds.width/2), y: backgroundImage.bounds.height/2 - discount.bounds.height/2, width: discount.bounds.width, height: discount.bounds.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
