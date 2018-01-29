//
//  TitleCollectionViewCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/26.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    var titleImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleImage.bounds = frame
        
        titleImage.frame.origin = CGPoint.init(x: self.bounds.width/2 - titleImage.bounds.width/2, y: self.bounds.height/2 - titleImage.bounds.height/2)
        
        addSubview(titleImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
