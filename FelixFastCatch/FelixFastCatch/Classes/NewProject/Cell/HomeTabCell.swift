//
//  HomeTabCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/17.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class HomeTabCell: UICollectionViewCell {
    
    /// 景品图
    var productImage:UIImageView = UIImageView()
    
    /// 景品名称
    var productName:UILabel = UILabel()
    
    /// 游戏价格
    var productCoin = UILabel()
    
    /// 状态的图片
    var statusImage = UIImageView()
    
    /// 错误view的遮罩
    var errorShadowView = UIView()
    
    var rootView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        rootView.frame = CGRect(x: 3, y: 0, width: self.bounds.width - 6, height: self.bounds.height)
        addSubview(rootView)
        
        rootView.backgroundColor = UIColor.white
        
        self.rootView.layer.cornerRadius = 10
        self.rootView.layer.masksToBounds = true
        self.rootView.layer.borderWidth = 0.5
        self.rootView.layer.borderColor = UIColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0).cgColor
        
        // 阴影
        layer.shadowColor = UIColor.init(red: 160/255.0, green: 195/255.0, blue: 253/255.0, alpha: 1.0).cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        productImage.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height * 0.72)
        self.rootView.addSubview(productImage)
        
        errorShadowView.frame = productImage.bounds
        errorShadowView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.1)
        self.rootView.addSubview(errorShadowView)
        
        productName = UILabel()
        productName.font = UIFont.systemFont(ofSize: 12)
        productName.frame = CGRect(x: 10, y: productImage.bounds.height + 8, width: self.bounds.width - 20, height: 20)
        productName.text = "我是测试的测试的测试的测试的"
        productName.numberOfLines = 1
        self.rootView.addSubview(productName)
        
        let coinIcon = UIImageView(image: UIImage(named: "金币gold"))
        coinIcon.sizeToFit()
        coinIcon.frame.origin = CGPoint(x: 10, y: productImage.bounds.height + 35)
        self.rootView.addSubview(coinIcon)
        
        productCoin.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        productCoin.text = "10000"
        productCoin.textColor = UIColor.init(red: 241/255.0, green: 176/255.0, blue: 0/255.0, alpha: 1.0)
        productCoin.sizeToFit()
        productCoin.frame.origin = CGPoint(x: coinIcon.frame.midX + 15, y: 0)
        productCoin.center.y = coinIcon.center.y
        self.rootView.addSubview(productCoin)
        
        statusImage.image = UIImage(named: "空闲中")
        statusImage.sizeToFit()
        statusImage.frame.origin = CGPoint(x: self.bounds.width - statusImage.bounds.width, y: 10)
        self.addSubview(statusImage)
        
        switchStatus(status: 1)
        
    }
    
    func switchStatus(status:Int) {
        switch status {
        case 0:
            /// 可以开始游戏
            statusImage.image = UIImage(named: "空闲中")
            errorShadowView.isHidden = true
            break
        case 1:
            /// 游戏中
            statusImage.image = UIImage(named: "游戏中")
            errorShadowView.isHidden = true
            break
        case 2:
            /// 维护中
            statusImage.image = UIImage(named: "补货中")
            errorShadowView.isHidden = false
            break
        default:
            ///维护中
            statusImage.image = UIImage(named: "补货中")
            errorShadowView.isHidden = false
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
