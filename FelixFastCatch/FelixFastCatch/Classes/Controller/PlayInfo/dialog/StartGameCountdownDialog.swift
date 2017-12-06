//
//  StartGameCountdownDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/1.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class StartGameCountdownDialog: BaseDialog {

    override func createView() {
        
//        let countdownImage = UIImage.gif(name: "横屏开始游戏loading")

        let countdownImageView = UIImageView()
        countdownImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        addSubview(countdownImageView)
        
        countdownImageView.center = self.center
        
        guard let path = Bundle.main.path(forResource: "横屏开始游戏loading.gif", ofType: nil),
            let data = NSData(contentsOfFile: path),
            let imageSource = CGImageSourceCreateWithData(data, nil) else { return }
        
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0..<CGImageSourceGetCount(imageSource) {
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            i == 0 ? countdownImageView.image = image : ()
            images.append(image)
            
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary,
                let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary,
                let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
        }
        
        countdownImageView.animationImages = images
        countdownImageView.animationDuration = totalDuration/2
        countdownImageView.animationRepeatCount = 0
        
        countdownImageView.startAnimating()
        
        addDialogToWindow()
    }

}
