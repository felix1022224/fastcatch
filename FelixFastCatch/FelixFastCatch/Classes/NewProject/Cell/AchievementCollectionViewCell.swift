//
//  AchievementCollectionViewCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/2/1.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class AchievementCollectionViewCell: UICollectionViewCell {
    
    var image = UIImageView()
    
    var name = UILabel()
    
    var info = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        image.frame.size = CGSize.init(width: self.bounds.width * 0.6, height: self.bounds.width * 0.6)
        image.frame.origin = CGPoint.init(x: self.bounds.width/2 - image.bounds.width/2, y: 0)
        addSubview(image)
        
        name.font = UIFont.systemFont(ofSize: 12)
        name.text = "成就名称"
        name.textAlignment = .center
        name.sizeToFit()
        name.frame = CGRect.init(x: 0, y: image.bounds.height + 10, width: self.bounds.width, height: name.bounds.height)
        addSubview(name)
        
        info.font = UIFont.systemFont(ofSize: 10)
        info.text = "成就详情"
        info.textColor = UIColor.gray
        info.textAlignment = .center
        info.sizeToFit()
        info.frame = CGRect.init(x: 0, y: self.bounds.height - info.bounds.height, width: self.bounds.width, height: info.bounds.height)
        addSubview(info)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
