//
//  CustomeFlowLayout.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/12.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class CustomeFlowLayout: UICollectionViewFlowLayout {

    override var collectionViewContentSize: CGSize{
        let width = collectionView!.bounds.size.width - collectionView!.contentInset.left
            - collectionView!.contentInset.right
        let height = CGFloat((collectionView!.numberOfItems(inSection: 0) + 1) / 3)
            * (width / 3 * 2)
        return CGSize(width: width, height: height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //当前单元格布局属性
        let attribute =  UICollectionViewLayoutAttributes(forCellWith:indexPath)
        if indexPath.section % 2 == 0 {
            /// 机器
            // item的宽度
            let itemWidth = (CGFloat(UIScreen.main.bounds.width) - 8*2)/2 - 5
            // 設置每個 cell 的尺寸
            attribute.frame.size = CGSize(width: itemWidth, height: itemWidth * 1.3)
        }else{
            /// 广告
            let itemWidth = (CGFloat(UIScreen.main.bounds.width) - 8*2)
            attribute.frame.size = CGSize(width: itemWidth, height: itemWidth/3)
        }
        return attribute
    }
    
}
