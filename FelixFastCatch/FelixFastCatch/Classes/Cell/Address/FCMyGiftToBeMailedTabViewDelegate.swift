//
//  FCMyGiftToBeMailedTabViewDelegate.swift
//  FastCatch
//
//  Created by 卢凡 on 2017/7/21.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class FCMyGiftToBeMailedTabViewDelegate: NSObject {

    

}

extension FCMyGiftToBeMailedTabViewDelegate : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? FCMyGiftCell
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIImage(named: "内容块")
        return CGFloat((height?.size.height)! + 10)
    }
    
}
