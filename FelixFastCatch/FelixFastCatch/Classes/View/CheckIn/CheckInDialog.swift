//
//  CheckInDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/7.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class CheckInDialog: BaseDialog {

    override func createView() {
        createBackgroundImage(imageName: "checkin_background")
        
        backgroundImage.frame.size = CGSize(width: 290, height: 200)
        backgroundImage.center = self.center
        
        createCloseBtn()
        
        addDialogToWindow()
    }

}
