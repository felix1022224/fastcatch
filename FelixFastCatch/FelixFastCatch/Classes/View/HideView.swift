//
//  HideView.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/3.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class HideView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var hide:()->()!
    
    init(frame: CGRect, hide:@escaping ()->()) {
        self.hide = hide
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hide()
    }
    
}
