//
//  MainADVCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/12.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class MainADVCell: UICollectionViewCell {

    lazy var advImage = UIImageView()

    // 根布局
    var rootView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        rootView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        rootView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1)
        
        // 圆角
        rootView.layer.cornerRadius = 10
        rootView.layer.masksToBounds = true
        
        // 阴影
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        addSubview(rootView)
        
        advImage.frame = CGRect(x: 0, y: 0, width: rootView.bounds.width, height: rootView.bounds.height)
        rootView.addSubview(advImage)
        advImage.center = rootView.center
        
        // 圆角
        advImage.layer.cornerRadius = 10
        advImage.layer.masksToBounds = true
        
        advImage.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
