//
//  MainCollectionViewCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/25.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import CoreLocation

class MainCollectionViewCell: UICollectionViewCell{
    
    // 根布局
    var rootView:UIView!
    
    // 商品图片
    var productImage:UIImageView!
    
    // 底部布局
    var bottomGroup:UIView!
    
    // 标题文字
    var titleLabel:UILabel!
    
    // 钻石数量
    var gemNumberLabel:UILabel!
    
    // 开始玩的按钮
    var playBtn:UIButton!
    
    /// 异常的view
    var errorStatusView:UIView!
    
    /// 游戏中的view
    var gameingStatusView:UIView!
    
    var errorImage:UIImageView!
    
    /// 游戏中的view
    var gammingImage:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        rootView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        rootView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1)
        
        // 圆角
        rootView.layer.cornerRadius = 10
//        rootView.layer.masksToBounds = true
        
        // 阴影
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        addSubview(rootView)
        
        setupImage()
        createBottomGroup()
        createErrorView()
        createGameingView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - 图片
extension MainCollectionViewCell{
    
    // 装载图片
    fileprivate func setupImage() -> () {
        productImage = UIImageView()
        productImage.frame = CGRect(x: 0, y: 0, width: rootView.bounds.width, height: rootView.bounds.height * 0.75)
        productImage.frame = productImage.frame.insetBy(dx: CGFloat(4), dy: CGFloat(4))
        productImage.layer.cornerRadius = 5
        productImage.layer.masksToBounds = true
        productImage.contentMode = .scaleAspectFill
        addSubview(productImage)
 
    }
    
}


// MARK: - 底部布局
extension MainCollectionViewCell{
    
    // 创建底部布局
    fileprivate func createBottomGroup(){
        let testLabel = UILabel()
        if UIScreen.main.bounds.width > 320 {
            testLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        }else{
            testLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 11)
        }
        testLabel.text = ""
        testLabel.sizeToFit()
        
        let bottomHeight = rootView.bounds.height * 0.28 + 4*2 + testLabel.bounds.height
        
        bottomGroup = UIView()
        bottomGroup.backgroundColor = rootView.backgroundColor
        bottomGroup.frame = CGRect(x: 0, y: rootView.bounds.height - bottomHeight, width: rootView.bounds.width, height: bottomHeight)
        bottomGroup.frame = bottomGroup.frame.insetBy(dx: CGFloat(4), dy: CGFloat(4))
        addSubview(bottomGroup)
        
        createGem()
        
        createTitle()
    }
    
    // 创建title
    fileprivate func createTitle(){
        titleLabel = UILabel()
        if UIScreen.main.bounds.width > 320 {
            titleLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 14)
        }else{
            titleLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 11)
        }
        titleLabel.textColor = UIColor.gray
        titleLabel.text = ""
        titleLabel.sizeToFit()
        titleLabel.numberOfLines = 2
        bottomGroup.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bottomGroup).offset(5)
            make.left.equalTo(bottomGroup).offset(2)
            make.right.equalTo(bottomGroup).offset(-2)
        }
    }
    
    // 钻石
    fileprivate func createGem(){
        let gem = UIImageView(image: UIImage(named: "Gem-icon"))
        gem.sizeToFit()
        bottomGroup.addSubview(gem)
        
        gemNumberLabel = UILabel()
        gemNumberLabel.textColor = Constants.UI.GEM_TEXT_COLOR
        gemNumberLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 12)
        gemNumberLabel.sizeToFit()
        gemNumberLabel.text = ""
        bottomGroup.addSubview(gemNumberLabel)
        
        createPlayBtn()
        
        gem.snp.makeConstraints { (make) in
            make.left.equalTo(bottomGroup).offset(2)
            make.centerY.equalTo(playBtn)
        }
        
        gemNumberLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(gem).offset(2)
            make.left.equalTo(gem).offset(gem.bounds.width + 5)
        }
    }
    
    // 创建开始游戏的按钮
    fileprivate func createPlayBtn(){
        playBtn = UIButton(type: .custom)
        playBtn.setImage(UIImage(named: "Easy"), for: .normal)
        playBtn.sizeToFit()
        bottomGroup.addSubview(playBtn)
        
        playBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bottomGroup).offset(-2)
            make.bottom.equalTo(bottomGroup)
        }
    }
    
    /// 添加游戏的点击事件
    ///
    /// - Parameters:
    ///   - target: 监听父类
    ///   - action: 动作
    func addPlayBtnClick(target:Any? , action: Selector) -> () {
        if playBtn != nil {
            playBtn.addTarget(target, action: action, for: .touchUpInside)
        }
    }
}

// MARK: - 异常的view
extension MainCollectionViewCell{
    
    func createErrorView() -> () {
        errorStatusView = UIView()
        errorStatusView.frame.size = CGSize(width: self.rootView.bounds.width, height: 20)
        errorStatusView.backgroundColor = UIColor(red: 253/255.0, green: 174/255.0, blue: 29/255.0, alpha: 0.8)
        
        let errorStatusLabel = MainCustomerLabel()
        errorStatusLabel.text = "正在补货中"
        errorStatusLabel.outLineWidth = 1
        errorStatusLabel.outTextColor = UIColor.white
        errorStatusLabel.outLienTextColor = UIColor.yellow
        errorStatusLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 11)
        errorStatusLabel.sizeToFit()
        errorStatusView.addSubview(errorStatusLabel)
        
        let errorRoundView = UIView()
        errorRoundView.frame.size = CGSize(width: errorStatusView.bounds.width, height: errorStatusView.bounds.height + 15)
        errorRoundView.frame = errorRoundView.frame.insetBy(dx: CGFloat(4), dy: CGFloat(4))
        errorRoundView.layer.masksToBounds = true
        errorRoundView.layer.cornerRadius = 5
        addSubview(errorRoundView)
        
        errorRoundView.addSubview(errorStatusView)
        
        errorStatusLabel.snp.makeConstraints { (make) in
            make.center.equalTo(errorStatusView)
        }
        
        errorImage = UIImageView(image: UIImage(named: "Heart-icon"))
        addSubview(errorImage)
        
        hideErrorView()
    }
    
    func showErrorView() -> () {
        errorStatusView.isHidden = false
        errorImage.isHidden = false
    }
    
    func hideErrorView() -> () {
        errorStatusView.isHidden = true
        errorImage.isHidden = true
    }
    
    /// 创建游戏中的view
    func createGameingView() -> () {
        gameingStatusView = UIView()
        gameingStatusView.frame.size = CGSize(width: self.rootView.bounds.width, height: 20)
        gameingStatusView.backgroundColor = UIColor(red: 121/255.0, green: 207/255.0, blue: 50/255.0, alpha: 0.8)
        
        let gameingStatusLabel = MainCustomerLabel()
        gameingStatusLabel.text = "正在游戏中"
        gameingStatusLabel.outLineWidth = 1
        gameingStatusLabel.outTextColor = UIColor.white
        gameingStatusLabel.outLienTextColor = UIColor.yellow
        gameingStatusLabel.font = UIFont.getCustomeYuanTiFont(fontSize: 11)
        gameingStatusLabel.sizeToFit()
        gameingStatusView.addSubview(gameingStatusLabel)
        
        let gameingRoundView = UIView()
        gameingRoundView.frame.size = CGSize(width: gameingStatusView.bounds.width, height: gameingStatusView.bounds.height + 15)
        gameingRoundView.frame = gameingRoundView.frame.insetBy(dx: CGFloat(4), dy: CGFloat(4))
        gameingRoundView.layer.masksToBounds = true
        gameingRoundView.layer.cornerRadius = 5
        addSubview(gameingRoundView)
        
        gameingRoundView.addSubview(gameingStatusView)
        
        gameingStatusLabel.snp.makeConstraints { (make) in
            make.center.equalTo(gameingStatusView)
        }
        
        gammingImage = UIImageView(image: UIImage(named: "Star-icon"))
        addSubview(gammingImage)
        
//        hideGameingView()
    }
    
    /// 显示游戏中的view
    func showGameingView() -> () {
        gammingImage.isHidden = false
        gameingStatusView.isHidden = false
        hideErrorView()
    }
    
    /// 隐藏游戏中的view
    func hideGameingView() -> () {
        gammingImage.isHidden = true
        gameingStatusView.isHidden = true
    }
    
}











