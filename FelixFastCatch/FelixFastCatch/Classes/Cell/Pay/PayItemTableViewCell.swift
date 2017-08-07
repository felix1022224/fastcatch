//
//  PayItemTableViewCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/31.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class PayItemTableViewCell: UITableViewCell {

    // 顶部背景
    private var topContentBackground:UIImageView!
    
    // 钻石描述
    lazy var gemInfo:MainCustomerLabel = MainCustomerLabel()
    
    // 购买按钮
    lazy var payBtn:UIButton = UIButton(type: .custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        // 顶部背景
        topContentBackground = UIImageView()
        topContentBackground.image = UIImage(named: "pay_item_background")
        topContentBackground.sizeToFit()
        addSubview(topContentBackground)
        
        // 钻石
        let gem = UIImageView()
        gem.image = UIImage(named: "pay_gem")
        gem.sizeToFit()
        addSubview(gem)
        
        gem.snp.makeConstraints { (make) in
            make.centerY.equalTo(topContentBackground)
            make.left.equalTo(topContentBackground).offset(8)
        }
        
        // 钻石描述
        gemInfo.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(12))
        gemInfo.outLineWidth = 1
        gemInfo.outTextColor = UIColor.white
        gemInfo.outLienTextColor = UIColor.black
        gemInfo.numberOfLines = 1
        
        addSubview(gemInfo)
        
        // 购买按钮
        payBtn.setImage(UIImage(named: "pay_10"), for: .normal)
        payBtn.sizeToFit()
        addSubview(payBtn)
        payBtn.frame = CGRect(x: self.bounds.width/2 + topContentBackground.bounds.width/2 - payBtn.bounds.width * 2 + 10 , y: topContentBackground.bounds.height / 2 - payBtn.bounds.height/2, width: payBtn.bounds.width, height: payBtn.bounds.height)
        
        gemInfo.snp.makeConstraints { (make) in
            make.centerY.equalTo(topContentBackground)
            make.left.equalTo(gem).offset(gem.bounds.width + 5)
            make.right.equalTo(payBtn).offset(-(payBtn.bounds.width + 5))
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
