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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        rootView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        rootView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1)
        
        // 圆角
        rootView.layer.cornerRadius = 10
        rootView.layer.masksToBounds = true
        
        // 阴影
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        addSubview(rootView)
        
        setupImage()
        createBottomGroup()
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
        productImage.frame = CGRect(x: 0, y: 0, width: rootView.bounds.width, height: rootView.bounds.height * 0.8)
        productImage.backgroundColor = UIColor.lightGray
        productImage.frame = productImage.frame.insetBy(dx: CGFloat(4), dy: CGFloat(4))
        productImage.layer.cornerRadius = 5
        productImage.layer.masksToBounds = true
        productImage.contentMode = .scaleAspectFill
        addSubview(productImage)
        
//        productImage.kf.setImage(with: URL(string: "http://image15.poco.cn/mypoco/myphoto/20150105/22/54827367201501052235372969159251560_026.jpg"))
    }
    
}


// MARK: - 底部布局
extension MainCollectionViewCell{
    
    // 创建底部布局
    fileprivate func createBottomGroup(){
        let testLabel = UILabel()
        if UIScreen.main.bounds.width > 320 {
            testLabel.font = UIFont.systemFont(ofSize: CGFloat(14))
        }else{
            testLabel.font = UIFont.systemFont(ofSize: CGFloat(11))
        }
        testLabel.text = "测试"
        testLabel.sizeToFit()
        
        let bottomHeight = rootView.bounds.height * 0.2 + 4*2 + testLabel.bounds.height
        
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
            titleLabel.font = UIFont.systemFont(ofSize: CGFloat(14))
        }else{
            titleLabel.font = UIFont.systemFont(ofSize: CGFloat(11))
        }
        titleLabel.text = "测试一下，这个新的商品怎么样"
        titleLabel.sizeToFit()
        titleLabel.numberOfLines = 2
        bottomGroup.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bottomGroup).offset(2)
            make.left.equalTo(bottomGroup).offset(2)
            make.right.equalTo(bottomGroup).offset(-2)
            make.bottom.equalTo(playBtn).offset(-(playBtn.bounds.height + 2))
        }
    }
    
    // 钻石
    fileprivate func createGem(){
        let gem = UIImageView(image: UIImage(named: "Gem-icon"))
        gem.sizeToFit()
        bottomGroup.addSubview(gem)
        
        gem.snp.makeConstraints { (make) in
            make.left.equalTo(bottomGroup).offset(2)
            make.bottom.equalTo(bottomGroup).offset(-2)
        }
        
        gemNumberLabel = UILabel()
        gemNumberLabel.textColor = Constants.UI.GEM_TEXT_COLOR
        gemNumberLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        gemNumberLabel.sizeToFit()
        gemNumberLabel.text = "30钻"
        bottomGroup.addSubview(gemNumberLabel)
        
        gemNumberLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(gem)
            make.left.equalTo(gem).offset(gem.bounds.width + 5)
        }
        
        createPlayBtn()
    }
    
    // 创建开始游戏的按钮
    fileprivate func createPlayBtn(){
        playBtn = UIButton(type: .custom)
        playBtn.setImage(UIImage(named: "Easy"), for: .normal)
        playBtn.sizeToFit()
        bottomGroup.addSubview(playBtn)
        
        playBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bottomGroup).offset(-2)
            make.centerY.equalTo(gemNumberLabel)
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



