//
//  TitlesInfoCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class TitlesInfoCell: UITableViewCell {

    // 顶部背景
    var topContentBackground:UIImageView!
    
    var itemImage = UIImageView()
    
    var title = MainCustomerLabel()
    
    var info = MainCustomerLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        // 顶部背景
        topContentBackground = UIImageView()
        topContentBackground.image = UIImage(named: "成就详情底")
        topContentBackground.sizeToFit()
        addSubview(topContentBackground)
        
        itemImage.frame.size = CGSize(width: 50, height: 50)
        addSubview(itemImage)
        itemImage.frame = CGRect(x: 15, y: (topContentBackground.bounds.height - itemImage.bounds.height)/2, width: itemImage.bounds.width, height: itemImage.bounds.height)
        
        title.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        title.outTextColor = UIColor.white
        title.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        title.font = UIFont.getCustomeYuanTiFont(fontSize: 16)
        title.text = "萌新"
        title.sizeToFit()
        addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(itemImage).offset(itemImage.bounds.width + 10)
            make.centerY.equalTo(itemImage)
        }
        
        info.outLineWidth = 3
        info.outTextColor = UIColor.white
        info.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        info.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
        info.text = "萌新\n123333"
        info.numberOfLines = 2
        info.textAlignment = .center
        info.sizeToFit()
        addSubview(info)
        
        info.snp.makeConstraints { (make) in
            make.centerY.equalTo(itemImage)
            make.right.equalTo(topContentBackground).offset(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
