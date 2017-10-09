//
//  FCMyGiftHasBeenProductsDelegate.swift
//  FastCatch
//
//  Created by 卢凡 on 2017/7/22.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

class FCMyGiftHasBeenProductsDelegate: NSObject {

    var dataSource:[JSON]!
    
    init(dataSource:[JSON]) {
        self.dataSource = dataSource
    }
    
}

extension FCMyGiftHasBeenProductsDelegate: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? FCHasBennMailedProductCell
        
        cell?.productImage.kf.setImage(with: URL(string: self.dataSource[indexPath.row]["img"].stringValue))
        
        return cell!
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
}
