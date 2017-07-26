//
//  MainFloatMenu.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/26.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class MainFloatMenu: UIView {

    // 动作按钮
    private var actionBtn:UIButton!
    
    // 动作文字
    private var actionLabel:MainCustomerLabel!
    
    init(frame: CGRect, image:UIImage?, actionTitle:String) {
        super.init(frame: frame)
        
        actionBtn = UIButton(type: .custom)
        actionBtn.setImage(image, for: .normal)
        actionBtn.sizeToFit()
        addSubview(actionBtn)
        
        actionLabel = MainCustomerLabel()
        actionLabel.text = actionTitle
        actionLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        actionLabel.outTextColor = UIColor.white
        actionLabel.outLienTextColor = Constants.UI.OUT_LINE_COLOR
        actionLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        actionLabel.textAlignment = .center
        actionLabel.sizeToFit()
        actionLabel.frame = CGRect(x: 0, y: actionBtn.bounds.height, width: actionBtn.bounds.width, height: actionLabel.bounds.height)
        addSubview(actionLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
