//
//  CustomerBannerView.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/26.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class CustomerBannerView: UIScrollView {

    var touchBeganFunc:(()->())? = nil
    
    var touchEndFunc:(()->())? = nil
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchBeganFunc != nil {
            touchBeganFunc!()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchEndFunc != nil {
            touchEndFunc!()
        }
    }

}
