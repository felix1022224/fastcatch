//
//  InviteListDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class InviteListDialog: BaseDialog {

    override func createView() {
        createBackgroundImage(imageName: "好友背景")
        
        backgroundImage.frame.size = CGSize(width: 290, height: 400)
        backgroundImage.center = self.center
        
        createCloseBtn()
        
        addDialogToWindow()
    }

}
