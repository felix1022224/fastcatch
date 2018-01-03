//
//  UIViewController+Extension.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/25.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class UIViewController_Extension: NSObject {

}

extension UIViewController{
    
    /// 设置背景图
    ///
    /// - Parameters:
    ///   - rootView: root view
    ///   - imgName: background image name
    func setBackgroundImage(rootView:UIView, imgName:String) {
        let backgroundImage = UIImageView(image: UIImage(named: imgName))
        backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,
                                       height: UIScreen.main.bounds.height)
        rootView.addSubview(backgroundImage)
    }
    
}
