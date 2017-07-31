//
//  PayListDialog.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/31.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class PayListDialog: BaseDialog {

    /// 商品列表
    fileprivate lazy var payList:UITableView = UITableView()
    
    /// 购买列表的数据
    fileprivate lazy var payListDataSource = [["rp":"1","pay_info":"70钻送20钻","pay_btn_image_named": "pay_10"],
                                              ["rp":"2","pay_info":"150钻送20钻","pay_btn_image_named": "pay_20"],
                                              ["rp":"3","pay_info":"420钻送120钻","pay_btn_image_named": "pay_50"],
                                              ["rp":"4","pay_info":"900钻送420钻","pay_btn_image_named": "pay_100"]]
    
    override func createView() {
        createBackgroundImage(imageName: "pay_background")
        createCloseBtn()
        
        /// 创建购买列表
        createPayList()
        
        addDialogToWindow()
    }
    
    /// 创建购买列表的tabview
    func createPayList() -> () {
        payList.backgroundColor = UIColor.clear
        payList.register(PayItemTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        payList.separatorColor = UIColor.clear
        payList.showsVerticalScrollIndicator = false
        
        payList.delegate = self
        payList.dataSource = self
        
        addSubview(payList)
        
        let topContentHeight = UIImage(named: "pay_item_background")
        
        payList.snp.makeConstraints { (make) in
            make.width.equalTo(topContentHeight!.size.width)
            make.height.equalTo(topContentHeight!.size.height * 4)
            make.center.equalTo(backgroundImage)
        }

    }
    
}

// MARK: - 列表的代理
extension PayListDialog:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payListDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? PayItemTableViewCell
        
        let dataItem = payListDataSource[indexPath.row]
        
        cell?.payBtn.tag = Int(dataItem["rp"]!)!
        
        cell?.gemInfo.text = dataItem["pay_info"]
        cell?.payBtn.setImage(UIImage(named: dataItem["pay_btn_image_named"]!), for: .normal)
        
        cell?.payBtn.addTarget(self, action: #selector(payClick(sender:)), for: .touchUpInside)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let topContentHeight = UIImage(named: "pay_item_background")
        
        return (topContentHeight?.size.height)! + 10
    }
    
    /// 点击购买按钮
    ///
    /// - Parameter sender: 按钮
    func payClick(sender:UIButton) -> () {
        print("rp:\(sender.tag)")
    }
    
}







