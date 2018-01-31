//
//  TakeProductImageCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/30.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class TakeProductImageCell: UICollectionViewCell {
    
    var image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        image.frame.size = CGSize.init(width: self.bounds.height * 0.9, height: self.bounds.height * 0.9)
        image.layer.cornerRadius = 15
        image.layer.masksToBounds = true
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.borderWidth = 0.5
        addSubview(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
