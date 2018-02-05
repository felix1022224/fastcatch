//
//  PayingGameDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/25.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlayingGameDialog: BasicDialog {
    
    /// 头像
    let avaterImage = UIImageView()
    
    /// 昵称
    let userNickName = UILabel()
    
    /// 性别图标
    let sexImage = UIImageView()
    
    /// 星座
    let xingzuoLabel = UILabel()
    
    /// vip 等级
    let vipLevel = UILabel()
    
    /// vip 皇冠
    let crownImage = UIImageView()
    
    /// 显示成就的列表
    var collectionView:UICollectionView!
    
    var pageControl:UIPageControl!
    
    var gameUserDataSource:JSON!
    
    override func createView() {
        createBackgroundImage(imageName: "资料弹框背景")
        
        let closeBtn = UIButton.init(type: UIButtonType.custom)
        closeBtn.setBackgroundImage(UIImage.init(named: "关闭"), for: UIControlState.normal)
        closeBtn.sizeToFit()
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundImage).offset(-(closeBtn.bounds.width))
            make.top.equalTo(backgroundImage).offset(closeBtn.bounds.height)
        }
        closeBtn.addTarget(self, action: #selector(hide), for: UIControlEvents.touchUpInside)
        
        /// 标题
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.bold)
        titleLabel.textColor = UIColor.white
        titleLabel.text = "ta 的资料"
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(backgroundImage).offset(backgroundImage.bounds.height * 0.15)
        }
        
        /// user avater
        avaterImage.frame = CGRect.init(x: backgroundImage.frame.origin.x + backgroundImage.bounds.width * 0.2, y: backgroundImage.frame.origin.y + backgroundImage.bounds.height * 0.4, width: 45, height: 45)
        addSubview(avaterImage)
        
        avaterImage.kf.setImage(with: URL.init(string: gameUserDataSource["avatar"].stringValue), placeholder: UIImage.init(named: "avater_default"), options: nil, progressBlock: nil, completionHandler: nil)
        
        avaterImage.layer.cornerRadius = 4
        avaterImage.layer.masksToBounds = true
        
        /// user title
        userNickName.font = UIFont.systemFont(ofSize: 15)
        userNickName.frame.size = CGSize.init(width: UIScreen.main.bounds.width * 0.35, height: 20)
        userNickName.text = gameUserDataSource["nick"].stringValue
        userNickName.numberOfLines = 1
        addSubview(userNickName)
        
        userNickName.snp.makeConstraints { (make) in
            make.top.equalTo(avaterImage)
            make.left.equalTo(avaterImage).offset(avaterImage.bounds.width + 20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.35)
            make.height.equalTo(20)
        }
        
        /// sexImage
        if gameUserDataSource["gender"].stringValue == "0" {
            sexImage.image = UIImage.init(named: "性别男")
        }else if gameUserDataSource["gender"].stringValue == "-1"{
            sexImage.image = UIImage.init(named: "性别男")
        }else{
            sexImage.image = UIImage.init(named: "性别女")
        }
        sexImage.sizeToFit()
        addSubview(sexImage)
        
        sexImage.snp.makeConstraints { (make) in
            make.left.equalTo(userNickName)
            make.bottom.equalTo(avaterImage)
        }
        
        /// 星座
        xingzuoLabel.font = UIFont.systemFont(ofSize: 12)
        xingzuoLabel.text = gameUserDataSource["constellation"].stringValue
        xingzuoLabel.sizeToFit()
        addSubview(xingzuoLabel)
        
        xingzuoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sexImage).offset(sexImage.bounds.width + 10)
            make.centerY.equalTo(sexImage)
        }
        
        /// vip level
        vipLevel.text = "VIP会员"
        vipLevel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        vipLevel.textColor = UIColor.red
        vipLevel.sizeToFit()
        addSubview(vipLevel)
        
        vipLevel.snp.makeConstraints { (make) in
            make.centerY.equalTo(xingzuoLabel)
            make.left.equalTo(xingzuoLabel).offset(xingzuoLabel.bounds.width + 10)
        }
        
        /// line view
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray
        addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(avaterImage).offset(avaterImage.bounds.height + 25)
            make.width.equalTo(backgroundImage.bounds.width * 0.64)
            make.height.equalTo(0.8)
        }
        
        /// vip 皇冠
        crownImage.image = UIImage.init(named: "vip")
        crownImage.sizeToFit()
        addSubview(crownImage)
        
        crownImage.snp.makeConstraints { (make) in
            make.right.equalTo(avaterImage).offset(crownImage.bounds.width/2)
            make.top.equalTo(avaterImage).offset(-((crownImage.bounds.height/2) + 4))
        }
        
        createCollectionView()
        
        if gameUserDataSource["vip"].intValue == 100000 {
            crownImage.image = UIImage.init(named: "vip")
            vipLevel.text = "VIP会员"
            vipLevel.textColor = UIColor.red
            crownImage.isHidden = false
            vipLevel.isHidden = false
        }else if gameUserDataSource["vip"].intValue == 11000 {
            crownImage.image = UIImage.init(named: "svip")
            vipLevel.text = "SVIP会员"
            vipLevel.textColor = UIColor.purple
            crownImage.isHidden = false
            vipLevel.isHidden = false
        }else{
            crownImage.isHidden = true
            vipLevel.isHidden = true
        }
        
        addDialogToWindow()
    }
    
    func createCollectionView(){
        let layout = HorizontalPageableLayout()
        
        layout.itemCountPerRow = 4
        layout.rowCount = 2
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 10
        let collectionWidth = backgroundImage.bounds.width * 0.6
        
        layout.itemSize = CGSize.init(width: (collectionWidth - 40)/4, height: (collectionWidth - 40)/4)
        
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: collectionWidth, height: (collectionWidth - 40)/4 * 2 + CGFloat(10)) , collectionViewLayout: layout)
        
        self.collectionView.isPagingEnabled = true;
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.backgroundColor = UIColor.white
        
        self.collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView.frame.origin = CGPoint.init(x: backgroundImage.frame.origin.x + backgroundImage.bounds.width/2 - collectionView.bounds.width/2, y: backgroundImage.frame.origin.y + backgroundImage.bounds.height - collectionView.bounds.height - 20)
        
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(self.collectionView)
        
        collectionView.reloadData()
        
        // 设置指示器的属性
        pageControl = UIPageControl()
        pageControl.numberOfPages = Int(gameUserDataSource["achievements"].arrayValue.count/8) + 1
        pageControl.backgroundColor = UIColor.clear
        pageControl.currentPage = 0
        pageControl.sizeToFit()
        addSubview(pageControl)
        
        pageControl.currentPageIndicatorTintColor = UIColor.yellow
        pageControl.pageIndicatorTintColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.8)
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.bottom.equalTo(backgroundImage)
        }
        
        if Int(gameUserDataSource["achievements"].arrayValue.count/8) + 1 > 1 {
            pageControl.isHidden = false
        }else{
            pageControl.isHidden = true
        }
    }
    
    override func hide() {
        super.hide()
        collectionView.removeFromSuperview()
        collectionView = nil
    }

}

extension PlayingGameDialog : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8 * (Int(gameUserDataSource.count/8) + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? TitleCollectionViewCell
        
        if indexPath.row < gameUserDataSource["achievements"].arrayValue.count {
            let itemData = gameUserDataSource["achievements"].arrayValue[indexPath.row]
            cell?.titleImage.kf.setImage(with: URL.init(string: itemData["achievementImg"].stringValue))
            cell?.titleImage.isHidden = false
        }else{
            cell?.titleImage.isHidden = true
        }
        
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x - scrollView.bounds.width/2)/scrollView.bounds.width + 1)
        pageControl.currentPage = index
    }
    
}
