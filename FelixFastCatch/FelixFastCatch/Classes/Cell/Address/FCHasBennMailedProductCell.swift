//
//  FCHasBennMailedProductCell.swift
//  FastCatch
//
//  Created by 卢凡 on 2017/7/22.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class FCHasBennMailedProductCell: UICollectionViewCell {
    
    private var backgroundImage:UIImageView!
    
    var productImage:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "产品框")
//        backgroundImage.center = self.center
        backgroundImage.sizeToFit()
        addSubview(backgroundImage)
        
        backgroundImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(backgroundImage.bounds.width)
            make.height.equalTo(backgroundImage.bounds.height)
        }
        
        productImage = UIImageView()
        productImage.backgroundColor = UIColor.white
        addSubview(productImage)
        
        productImage.snp.makeConstraints { (make) in
            make.width.equalTo(backgroundImage.bounds.width * 0.85)
            make.height.equalTo(backgroundImage.bounds.height * 0.85)
            make.center.equalTo(backgroundImage)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
