//
//  MZCoreKit.swift
//  MZCoreKit
//
//  Created by 卢凡 on 2017/11/21.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

public class MZCoreKit{

    public static let shared = MZCoreKit.init()
    
    private init() {
//        FontExt.loadMyCustomFont("", size: CGFloat)
    }
    
    open func showGameSceneView(){
        UIViewController.init().present(GameSceneViewController(), animated: true, completion: nil)
    }
    
}
