//
//  FCMyGiftHasBeenProductsDelegate.swift
//  FastCatch
//
//  Created by 卢凡 on 2017/7/22.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class FCMyGiftHasBeenProductsDelegate: NSObject {

}

extension FCMyGiftHasBeenProductsDelegate: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? FCHasBennMailedProductCell
        
        return cell!
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
}
