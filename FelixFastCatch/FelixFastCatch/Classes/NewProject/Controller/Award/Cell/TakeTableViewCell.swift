//
//  TakeTableViewCell.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/30.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

class TakeTableViewCell: UITableViewCell , UICollectionViewDelegate, UICollectionViewDataSource{

    var timeLabel = UILabel()
    
    var statusLabel = UILabel()
    
    var mailedInfoLabel = UILabel()
    var productNumber = UILabel()
    
    var itemWidth = UIScreen.main.bounds.width * 0.9
    var itemHeight = UIScreen.main.bounds.width * 0.9 * 0.5
    
    /// 商品详情的view
    var collectionView : UICollectionView!
    
    /// 图片数据
    var imgDataSource = [JSON]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.text = "申请时间"
        timeLabel.textColor = UIColor.gray
        timeLabel.sizeToFit()
        addSubview(timeLabel)
        
        timeLabel.frame.origin = CGPoint.init(x: 10, y: 15)
        
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        statusLabel.text = "配货中"
        statusLabel.sizeToFit()
        addSubview(statusLabel)
        
        statusLabel.frame.origin = CGPoint.init(x: itemWidth - 10 - statusLabel.bounds.width, y: 15)
        
        mailedInfoLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        mailedInfoLabel.text = "发货详情: 中通 1232398912389128312"
        mailedInfoLabel.sizeToFit()
        addSubview(mailedInfoLabel)
        
        mailedInfoLabel.frame.origin = CGPoint.init(x: 10, y: itemHeight - mailedInfoLabel.bounds.height - 15)
        
        productNumber.font = UIFont.systemFont(ofSize: 12)
        productNumber.text = "共100件商品"
        productNumber.sizeToFit()
        productNumber.textColor = UIColor.gray
        addSubview(productNumber)
        
        productNumber.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(mailedInfoLabel)
        }
        
        createProductList()
    }
    
    func createProductList(){
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 10
        let collectionWidth = itemWidth
        layout.itemSize = CGSize.init(width: collectionWidth/4, height: collectionWidth/4)
        
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: collectionWidth, height: (collectionWidth)/4) , collectionViewLayout: layout)
        
        self.collectionView.isPagingEnabled = true;
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.backgroundColor = UIColor.white
        
        self.collectionView.register(TakeProductImageCell.self, forCellWithReuseIdentifier: "cellId")
        addSubview(collectionView)
        
        self.collectionView.frame.origin = CGPoint.init(x: 10, y: UIScreen.main.bounds.width * 0.9 * 0.5/2 - collectionWidth/4/2)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! TakeProductImageCell
        
        cell.image.kf.setImage(with: URL.init(string: imgDataSource[indexPath.row]["img"].stringValue))
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
