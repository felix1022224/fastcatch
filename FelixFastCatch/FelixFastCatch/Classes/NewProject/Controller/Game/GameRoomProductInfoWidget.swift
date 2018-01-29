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
        
        rootView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: liveView.bounds.height + gameControllerGroupView.bounds.height + bannerGroupView.bounds.height + productInfoGroupView.bounds.height + 20)
        
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
        leftLine.backgroundColor = UIColor.black
        leftLine.frame = CGRect(x: 0, y: titleGroupView.bounds.height/2 - 0.5, width: titleGroupView.bounds.width / 3, height: 1)
        titleGroupView.addSubview(leftLine)
        
        let rightLine = UIView()
        rightLine.backgroundColor = UIColor.black
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
        
        let productInfo = UILabel()
        productInfo.text = "商品介绍 : "
        productInfo.font = UIFont.systemFont(ofSize: 14)
        productInfo.textColor = UIColor.gray
        productInfo.sizeToFit()
        productInfo.frame = CGRect(x: 40, y: productName.frame.midY + 20, width: productInfo.bounds.width, height: productInfo.bounds.height)
        productInfoGroupView.addSubview(productInfo)
        
        productInfoLabel.font = UIFont.systemFont(ofSize: 14)
        productInfoLabel.textColor = UIColor.black
        productInfoLabel.text = gameRoomData["award"]["description"].stringValue
        productInfoLabel.sizeToFit()
        productInfoLabel.frame = CGRect(x: productNameLabel.frame.origin.x, y: productInfo.frame.origin.y, width: productInfoGroupView.bounds.width - productInfo.bounds.width - 80, height: productInfo.bounds.height)
        productInfoGroupView.addSubview(productInfoLabel)
        
        let productImageBackground = UIView()
        productImageBackground.backgroundColor = UIColor.white
        productImageBackground.layer.cornerRadius = 10
        productImageBackground.frame = CGRect(x: productInfo.frame.origin.x, y: productInfo.frame.origin.y + productInfo.bounds.height + 20, width: productInfoGroupView.bounds.width - 80, height: (productInfoGroupView.bounds.width - productInfo.bounds.width - 80) * 0.8)
        productInfoGroupView.addSubview(productImageBackground)
        
        productImage.frame.origin = CGPoint(x: productImageBackground.frame.origin.x + productImageBackground.bounds.width/2 - productImageBackground.bounds.width * 0.96/2, y: productImageBackground.frame.origin.y + productImageBackground.bounds.height/2 - productImageBackground.bounds.height * 0.96/2)
        productImage.frame.size = CGSize(width: productImageBackground.bounds.width * 0.96, height: productImageBackground.bounds.height * 0.96)
        productImage.layer.cornerRadius = 12
        productImage.layer.masksToBounds = true
        productInfoGroupView.addSubview(productImage)
        
    }
    
}
