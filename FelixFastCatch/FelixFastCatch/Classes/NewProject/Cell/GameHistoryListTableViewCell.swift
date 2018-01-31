//
//  GameHistoryListTableViewCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/31.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class GameHistoryListTableViewCell: UITableViewCell {

    var productImage = UIImageView()
    var productName = UILabel()
    var time = UILabel()
    var statusImage = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        productImage.frame.size = CGSize.init(width: 70, height: 70)
        productImage.backgroundColor = UIColor.white
        productImage.layer.borderColor = UIColor.lightGray.cgColor
        productImage.layer.borderWidth = 0.5
        productImage.layer.cornerRadius = 10
        productImage.layer.masksToBounds = true
        productImage.frame.origin = CGPoint.init(x: 15, y: 15)
        addSubview(productImage)
        
        productName.font = UIFont.systemFont(ofSize: 16)
        productName.text = "商品名称"
        productName.numberOfLines = 2
        productName.sizeToFit()
        addSubview(productName)
        
        productName.snp.makeConstraints { (make) in
            make.top.equalTo(productImage)
            make.left.equalTo(productImage).offset(productImage.bounds.width + 15)
            make.width.equalTo(UIScreen.main.bounds.width * 0.5)
            make.height.equalTo(productName.bounds.height * 2)
        }
        
        time.font = UIFont.systemFont(ofSize: 12)
        time.text = "商品名称"
        time.numberOfLines = 1
        time.textColor = UIColor.gray
        time.sizeToFit()
        addSubview(time)
        
        time.snp.makeConstraints { (make) in
            make.bottom.equalTo(productImage)
            make.left.equalTo(productImage).offset(productImage.bounds.width + 15)
        }
        
        statusImage.image = UIImage.init(named: "未抓中印章")
        statusImage.sizeToFit()
        statusImage.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width - 15 - statusImage.bounds.width, y: 100/2 - statusImage.bounds.height/2)
        addSubview(statusImage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
