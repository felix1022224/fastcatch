//
//  UserTitlesGroup.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/10/13.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class UserTitlesGroup: NSObject {

}

extension UserCenterViewController{
    
    /// 创建称号的集合
    func createTitlesGroup() -> () {
        titlesGroupView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 30 - UIScreen.main.bounds.height * 0.3 - 5)
        titlesGroupView.image = UIImage(named: "我的成就底")
        bottomGroupView.addSubview(titlesGroupView)
        
        /// 称号集合的标题
        let titlesGroupTitleLabel = MainCustomerLabel()
        titlesGroupTitleLabel.font = UIFont(name: "FZY4K--GBK1-0", size: CGFloat(20))
        titlesGroupTitleLabel.outLineWidth = Constants.UI.OUT_LINE_WIDTH
        titlesGroupTitleLabel.outTextColor = UIColor.white
        titlesGroupTitleLabel.outLienTextColor = UIColor(red: 28/255.0, green: 107/255.0, blue: 101/255.0, alpha: 1)
        titlesGroupTitleLabel.numberOfLines = 1
        titlesGroupTitleLabel.text = "我的成就"
        titlesGroupTitleLabel.sizeToFit()
        bottomGroupView.addSubview(titlesGroupTitleLabel)
        
        titlesGroupTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titlesGroupView).offset(25)
            make.centerX.equalTo(view).offset(1)
        }
        
        createTitlesGroupList(titlesLabel: titlesGroupTitleLabel)
    }
}

// MARK: - 用户的称号集合
extension UserCenterViewController{
    
    /// 创建称号集合列表
    func createTitlesGroupList(titlesLabel:MainCustomerLabel) -> () {
        
        let dataListPadding = CGFloat(8)
        
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(dataListPadding, dataListPadding, dataListPadding, dataListPadding);
        
        // 設置每一行的間距
        layout.minimumLineSpacing = dataListPadding + 1
        
//        let main = UIScreen.main.bounds
//        // 設置 header 及 footer 的尺寸
//        layout.footerReferenceSize = CGSize(width: CGFloat(4) * main.width, height: 90)
        
        // item的宽度
        let itemWidth = (CGFloat(self.titlesGroupView.bounds.width * 0.92) - dataListPadding*2)/3 - 8
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.65)
        
        titlesList = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.titlesGroupView.bounds.width * 0.92, height: self.titlesGroupView.bounds.height - titlesLabel.bounds.height - 15 - 25), collectionViewLayout: layout)
        titlesList.backgroundColor = UIColor.clear
        
        self.titlesList.delegate = self
        self.titlesList.dataSource = self
        
        titlesList.frame = CGRect(x: (UIScreen.main.bounds.width - titlesList.bounds.width)/2 + 1, y: titlesLabel.bounds.height + 10 + 20, width: titlesList.bounds.width, height: titlesList.bounds.height - 20)
        
        bottomGroupView.addSubview(titlesList)
        
        titlesList.register(TitlesCell.self, forCellWithReuseIdentifier: "CellId")
        
        getTitlesList()
    }
    
}

extension UserCenterViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesDataSource.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as? TitlesCell
        
        if indexPath.row == titlesDataSource.count {
            // 最后一个敬请期待
            cell?.awaitImage.isHidden = false
        }else{
            cell?.awaitImage.isHidden = true
            
            let item = titlesDataSource[indexPath.row]
            
            cell?.title.text = item["name"].stringValue
            cell?.info.attributedText = cell?.getAttributeStringWithString(item["description"].stringValue, lineSpace: 4)
            cell?.image.kf.setImage(with: URL(string: item["achievementImg"].stringValue))
            
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != titlesDataSource.count {
            // 点击查看成就详情
            
            userTitlesInfoDialog.createView()
            userTitlesInfoDialog.show2(list: titlesDataSource[indexPath.row]["achievements"].arrayValue)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

// MARK: - 从网络获取成就的list
extension UserCenterViewController{
    
    func getTitlesList() -> () {
        Alamofire.request(Constants.Network.User.GET_USER_TITLES_LIST, method: .post, parameters: NetWorkUtils.createBaseParams())
            .responseJSON { (dataResponse) in
                if NetWorkUtils.checkReponse(response: dataResponse) {
                    print("result:\(dataResponse.result.value!)")
                    let resultJson = JSON(data: dataResponse.data!)
                    let titlesArray = resultJson["data"].array!
                    if !titlesArray.isEmpty {
                        self.titlesDataSource = self.titlesDataSource + titlesArray
                        self.titlesList.reloadData()
                    }
                }
        }
    }
    
}














