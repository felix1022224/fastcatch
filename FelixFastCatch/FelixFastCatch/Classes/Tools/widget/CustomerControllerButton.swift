//
//  CustomerControllerButton.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/30.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class CustomerControllerButton: UIButton {
    
    private var controllerDown:(_ sender:CustomerControllerButton)->()!
    private var controllerUp:(_ sender:CustomerControllerButton)->()!
    private var controllerMove:(_ sender:CustomerControllerButton)->()!
    
    init(frame: CGRect, controllerDown:@escaping (_ sender:CustomerControllerButton)->(), controllerUp:@escaping (_ sender:CustomerControllerButton)->(), controllerMove:@escaping (_ sender:CustomerControllerButton)->()) {
        
        self.controllerDown = controllerDown
        self.controllerUp = controllerUp
        self.controllerMove = controllerMove
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.controllerDown(self)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.controllerUp(self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.controllerMove(self)
    }
    
}
