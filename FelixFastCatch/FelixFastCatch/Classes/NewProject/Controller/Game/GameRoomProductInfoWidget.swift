//
//  GameRoomProductInfoWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/22.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

// MARK: - 游戏界面 商品详细信息的view
extension GameRoomViewController{
    
    func createBottomGroupView() {
        productInfoGroupView.frame = CGRect(x: 0, y: liveView.bounds.height + UIScreen.main.bounds.width * 0.7 - liveView.bounds.height * 0.15 + bannerGroupView.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        rootView.addSubview(productInfoGroupView)
        
        let titleGroupView = UIView()
        titleGroupView.frame = CGRect(x: 40, y: 0, width: UIScreen.main.bounds.width - 80, height: 50)
        productInfoGroupView.addSubview(titleGroupView)
        
        let productInfoTitle = UILabel()
        productInfoTitle.text = "商品详情"
        productInfoTitle.font = UIFont.systemFont(ofSize: 14)
        productInfoTitle.sizeToFit()
        productInfoTitle.frame.origin = CGPoint(x: titleGroupView.bounds.width/2 - productInfoTitle.bounds.width/2, y: titleGroupView.bounds.height/2 - productInfoTitle.bounds.height/2)
        titleGroupView.addSubview(productInfoTitle)
        
        let leftLine = UIView()
        leftLine.backgroundColor = UIColor.init(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1.0)
        leftLine.frame = CGRect(x: 0, y: titleGroupView.bounds.height/2 - 0.5, width: titleGroupView.bounds.width / 3, height: 1)
        titleGroupView.addSubview(leftLine)
        
        let rightLine = UIView()
        rightLine.backgroundColor = UIColor.init(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1.0)
        rightLine.frame = CGRect(x: titleGroupView.bounds.width - leftLine.bounds.width, y: titleGroupView.bounds.height/2 - 0.5, width: titleGroupView.bounds.width / 3, height: 1)
        titleGroupView.addSubview(rightLine)
        
        let productName = UILabel()
        productName.text = "商品名称 : "
        productName.font = UIFont.systemFont(ofSize: 14)
        productName.textColor = UIColor.gray
        productName.sizeToFit()
        productName.frame = CGRect(x: 40, y: titleGroupView.bounds.height + 10, width: productName.bounds.width, height: productName.bounds.height)
        productInfoGroupView.addSubview(productName)
        
        productNameLabel.font = UIFont.systemFont(ofSize: 14)
        productNameLabel.textColor = UIColor.black
        productNameLabel.text = gameRoomData["award"]["title"].stringValue
        productNameLabel.sizeToFit()
        productNameLabel.frame = CGRect(x: productName.frame.origin.x + productName.bounds.width + 5, y: productName.frame.origin.y, width: productInfoGroupView.bounds.width - productName.bounds.width - 80, height: productName.bounds.height)
        productInfoGroupView.addSubview(productNameLabel)
        
//        let productInfo = UILabel()
//        productInfo.text = "商品介绍 : "
//        productInfo.font = UIFont.systemFont(ofSize: 14)
//        productInfo.textColor = UIColor.gray
//        productInfo.sizeToFit()
//        productInfo.numberOfLines = 3
//        productInfo.frame = CGRect(x: 40, y: productName.frame.midY + 20, width: productInfo.bounds.width, height: productInfo.bounds.height)
//        productInfoGroupView.addSubview(productInfo)
//
        productInfoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: productInfoGroupView.bounds.width - 80, height: CGFloat.greatestFiniteMagnitude))
        productInfoLabel.font = UIFont.systemFont(ofSize: 14)
        productInfoLabel.textColor = UIColor.gray
        productInfoLabel.numberOfLines = 0
//        productInfoLabel.frame.size = CGSize.init(width: productInfoGroupView.bounds.width - 80, height: heightForView(text: "商品详情 :  \(gameRoomData["award"]["description"].stringValue)", font: UIFont.systemFont(ofSize: 14), width: productInfoGroupView.bounds.width - 80))
//        productInfoLabel.text = "商品详情 :  \(gameRoomData["award"]["description"].stringValue)"
//        productInfoLabel.frame.size = CGSize.init(width: productInfoGroupView.bounds.width - 80, height: productInfoLabel.bounds.height)
//        productInfoLabel.lineBreakMode = .byWordWrapping
//        productInfoLabel.sizeToFit()
        let attrText = NSMutableAttributedString.init(string: "商品详情 :  \(gameRoomData["award"]["description"].stringValue)")
        attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location: 8, length:gameRoomData["award"]["description"].stringValue.count))
        productInfoLabel.attributedText = attrText
        productInfoLabel.lineBreakMode = .byWordWrapping
        productInfoLabel.sizeToFit()
        productInfoLabel.frame.origin = CGPoint.init(x: 40, y: productName.frame.midY + 20)
        productInfoGroupView.addSubview(productInfoLabel)
        
        productImage.frame.origin = CGPoint(x: productInfoLabel.frame.origin.x, y: productInfoLabel.frame.origin.y + productInfoLabel.bounds.height + 20)
        productImage.frame.size = CGSize(width: productInfoGroupView.bounds.width - 80, height: (productInfoGroupView.bounds.width - 80) * 0.6)
        productImage.layer.borderColor = UIColor.white.cgColor
        productImage.layer.borderWidth = 5
        productImage.layer.cornerRadius = 12
        productImage.layer.masksToBounds = true
        productInfoGroupView.addSubview(productImage)
        
        productImage.kf.setImage(with: URL.init(string: gameRoomData["award"]["img"].stringValue))
        
        productInfoGroupView.frame.size = CGSize.init(width: productInfoGroupView.bounds.width, height: productInfoLabel.frame.origin.y + productInfoLabel.bounds.height + 20 + (productInfoGroupView.bounds.width - 80) * 0.6 + 20)
        
        rootView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: liveView.bounds.height + gameControllerGroupView.bounds.height + bannerGroupView.bounds.height + productInfoGroupView.bounds.height + 20)
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
}
