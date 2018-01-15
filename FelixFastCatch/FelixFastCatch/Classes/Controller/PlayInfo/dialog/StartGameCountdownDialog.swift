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
        addSubview(countdownImageView)
        
        guard let path = Bundle.main.path(forResource: "开始游戏loading.gif", ofType: nil),
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
        
        countdownImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.7)
        countdownImageView.center = self.center
        
        countdownImageView.startAnimating() 
        
        addDialogToWindow()
    }

    override func show() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.shadow.alpha = 0.5
            self?.isHidden = false
        }
    }
    
    override func hide() {
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.shadow.alpha = 0.0
            self?.alpha = 0.0
        }) { [weak self] (isHide) in
            self?.alpha = 1
            self?.isHidden = true
            self?.shadow.removeFromSuperview()
            self?.removeFromSuperview()
            for subview in (self?.subviews)! {
                subview.removeFromSuperview()
            }
        }
    }
    
}
