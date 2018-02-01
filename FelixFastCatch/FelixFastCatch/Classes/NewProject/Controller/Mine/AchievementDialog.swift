//
//  AchievementDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/2/1.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

class AchievementDialog: BasicDialog {

    var dataSource = [JSON]()
    
    var collectionView:UICollectionView!
    
    var pageControl:UIPageControl!
    
    override func createView() {
        createBackgroundImage(imageName: "成就详情背景")
        
        let closeBtn = UIButton.init(type: UIButtonType.custom)
        closeBtn.setBackgroundImage(UIImage.init(named: "关闭"), for: UIControlState.normal)
        closeBtn.sizeToFit()
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(backgroundImage).offset(-closeBtn.bounds.width)
            make.top.equalTo(backgroundImage).offset(closeBtn.bounds.height)
        }
        closeBtn.addTarget(self, action: #selector(hide), for: UIControlEvents.touchUpInside)
        
        let title = UILabel.init()
        title.text = "成就详情"
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        title.sizeToFit()
        addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImage)
            make.top.equalTo(backgroundImage).offset(backgroundImage.bounds.height * 0.15)
        }
        
        let layout = HorizontalPageableLayout()
        
        layout.itemCountPerRow = 3
        layout.rowCount = 2
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 0
        let collectionWidth = backgroundImage.bounds.width * 0.8
        
        layout.itemSize = CGSize.init(width: (collectionWidth)/3, height: (collectionWidth)/3)
        
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView = UICollectionView.init(frame: CGRect.init(x: CGFloat(0), y: CGFloat(0), width: collectionWidth, height: collectionWidth/3 * 2 + 15), collectionViewLayout: layout)
        
        self.collectionView.isPagingEnabled = true;
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.backgroundColor = UIColor.white
        
        self.collectionView.register(AchievementCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView.frame.origin = CGPoint.init(x: backgroundImage.frame.origin.x + backgroundImage.bounds.width/2 - collectionView.bounds.width/2, y: backgroundImage.frame.origin.y + backgroundImage.bounds.height - collectionView.bounds.height - 60)
        
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(self.collectionView)
        
        collectionView.reloadData()
        
        // 设置指示器的属性
        pageControl = UIPageControl()
        pageControl.numberOfPages = Int(dataSource.count/6) + 1
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
        
        if Int(dataSource.count%6) + 1 > 1 {
            pageControl.isHidden = false
        }else{
            pageControl.isHidden = true
        }
        
        addDialogToWindow()
    }
    
}

extension AchievementDialog : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6 * (Int(dataSource.count%6) + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AchievementCollectionViewCell
        
        if indexPath.row < dataSource.count {
            let itemData = dataSource[indexPath.row]
            
            cell.image.kf.setImage(with: URL.init(string: itemData["achievementImg"].stringValue))
            
            cell.name.text = itemData["name"].stringValue
            cell.info.text = itemData["description"].stringValue
            
            cell.image.isHidden = false
            cell.name.isHidden = false
            cell.info.isHidden = false
        }else{
            cell.image.isHidden = true
            cell.name.isHidden = true
            cell.info.isHidden = true
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x - scrollView.bounds.width/2)/scrollView.bounds.width + 1)
        pageControl.currentPage = index
    }
    
}
