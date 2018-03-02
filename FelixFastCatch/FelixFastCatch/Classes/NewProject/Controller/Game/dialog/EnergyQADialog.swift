//
//  EnergyQADialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/2/28.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class EnergyQADialog: BasicDialog {

    override func createView() {
        createBackgroundImage(imageName: "什么是能量值？")
        
        let closeBtn = UIButton.init(type: UIButtonType.custom)
        closeBtn.frame.size = CGSize.init(width: 150, height: 150)
        closeBtn.addTarget(self, action: #selector(hide), for: UIControlEvents.touchUpInside)
        addSubview(closeBtn)
        
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage)
            make.right.equalTo(backgroundImage)
        }
        
        let closeBtn2 = UIButton.init(type: UIButtonType.custom)
        closeBtn2.frame.size = CGSize.init(width: backgroundImage.bounds.width, height: 150)
        closeBtn2.frame.origin = CGPoint.init(x: backgroundImage.frame.origin.x, y: backgroundImage.bounds.height)
        closeBtn2.addTarget(self, action: #selector(hide), for: UIControlEvents.touchUpInside)
        addSubview(closeBtn2)
        
        
        
        addDialogToWindow()
    }
    
}
