//
//  TitlesCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class TitlesCell: UICollectionViewCell {
    
    lazy var itemBackgroundImage = UIImageView()
    
    /// 标题
    lazy var title = MainCustomerLabel()
    
    /// 图片
    lazy var image = UIImageView()
    
    lazy var info = MainCustomerLabel()
    
    /// 敬请期待
    lazy var awaitImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        itemBackgroundImage.image = UIImage(named: "成就背景")
        itemBackgroundImage.frame.size = CGSize(width: self.bounds.width*0.99, height: self.bounds.height*0.99)
        addSubview(itemBackgroundImage)
        
        title.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        title.outTextColor = UIColor.white
        title.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        title.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(14))
        title.text = "萌新"
        title.textAlignment = .center
        title.sizeToFit()
        addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(itemBackgroundImage).offset(10)
            make.centerX.equalTo(self)
        }
        
        image.frame = CGRect(x: self.bounds.width/2 - 60/2, y: 10 + title.bounds.height + 15, width: 60, height: 60)
        addSubview(image)
        
        info.outLineWidth = 3
        info.outTextColor = UIColor.white
        info.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        info.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(11))
        info.text = "萌新\n123333"
        info.numberOfLines = 2
        info.textAlignment = .center
        info.sizeToFit()
        addSubview(info)
        
        info.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-8)
            make.centerX.equalTo(self)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        
        image.kf.setImage(with: URL(string: "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3525174135,2597372701&fm=200&gp=0.jpg"))
        
        awaitImage.image = UIImage(named: "敬请期待")
        awaitImage.frame.size = CGSize(width: self.bounds.width, height: self.bounds.height)
        addSubview(awaitImage)
        
        awaitImage.isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
