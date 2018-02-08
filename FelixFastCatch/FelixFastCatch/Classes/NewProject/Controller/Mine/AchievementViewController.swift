//
//  AchievementViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/2/1.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

/// 我的成就
class AchievementViewController: UIViewController {

    var centerGroupView = UIView()
    
    var numberLabel = UILabel()
    
    var achievementList : UICollectionView!
    
    var titlesDataSource = [JSON]()
    
    var headerList = [JSON]()
    
    /// 没有数据的图片
    var noValueImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let backgroundImage = UIImageView.init()
        backgroundImage.frame = CGRect.init(x: -(UIScreen.main.bounds.width * 0.025), y: 0, width: UIScreen.main.bounds.width * 1.05, height: UIScreen.main.bounds.height)
        backgroundImage.image = UIImage.init(named: "成就背景")
        view.addSubview(backgroundImage)
        
        let backbutton = UIButton.init(type: UIButtonType.custom)
        backbutton.setBackgroundImage(UIImage.init(named: "游戏界面返回"), for: UIControlState.normal)
        backbutton.sizeToFit()
        view.addSubview(backbutton)
        
        backbutton.frame.origin = CGPoint.init(x: 15, y: UIApplication.shared.statusBarFrame.height + 15)
        backbutton.addTarget(self, action: #selector(close), for: UIControlEvents.touchUpInside)
        
        let nickNameLabel = UILabel()
        nickNameLabel.text = Constants.User.USER_NICK_NAME
        nickNameLabel.font = UIFont.systemFont(ofSize: 18)
        nickNameLabel.textColor = UIColor.white
        nickNameLabel.numberOfLines = 1
        nickNameLabel.sizeToFit()
        let nickNameWidth = nickNameLabel.bounds.width > UIScreen.main.bounds.width * 0.35 ? UIScreen.main.bounds.width * 0.35 : nickNameLabel.bounds.width
        nickNameLabel.frame = CGRect.init(x: 30 + backbutton.bounds.width, y: backbutton.frame.origin.y + backbutton.bounds.height/2 - nickNameLabel.bounds.height/2, width: nickNameWidth, height: nickNameLabel.bounds.height)
        view.addSubview(nickNameLabel)
        
        numberLabel.text = "，已获成就0个"
        numberLabel.font = UIFont.systemFont(ofSize: 18)
        numberLabel.textColor = UIColor.white
        numberLabel.sizeToFit()
        numberLabel.frame = CGRect.init(x: nickNameLabel.frame.origin.x + 10 + nickNameLabel.bounds.width, y:nickNameLabel.frame.origin.y, width: UIScreen.main.bounds.width * 0.5, height: numberLabel.bounds.height)
        view.addSubview(numberLabel)
        
        getTitlesList()
    }
    
    /// 创建成就list
    func createAchievementList() {
        print(self.titlesDataSource)
        
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 10
        let collectionWidth = UIScreen.main.bounds.width * 0.9
        
        layout.itemSize = CGSize.init(width: (collectionWidth - 50)/4, height: (collectionWidth - 40)/4)
        
        layout.headerReferenceSize = CGSize.init(width: collectionWidth, height: CGFloat(100 * headerList.count) + 40)
        layout.footerReferenceSize = CGSize.init(width: collectionWidth, height: 20)
        
        achievementList = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: collectionWidth, height: UIScreen.main.bounds.height * 0.85) , collectionViewLayout: layout)
        
        self.achievementList.delegate = self
        self.achievementList.dataSource = self
        
        self.achievementList.backgroundColor = UIColor.white
        
        self.achievementList.register(AchievementHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        self.achievementList.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        self.achievementList.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        
        achievementList.frame.origin = CGPoint.init(x: UIScreen.main.bounds.width * 0.05, y: UIScreen.main.bounds.height * 0.15)
        
        view.addSubview(self.achievementList)
        
        noValueImage.image = UIImage.init(named: "成就空")
        noValueImage.sizeToFit()
        view.addSubview(noValueImage)
        
        noValueImage.center = achievementList.center
        
        noValueImage.isHidden = false
        achievementList.isHidden = true
    }
    
    func getTitlesList() -> () {
        Alamofire.request(Constants.Network.User.GET_USER_TITLES_LIST, method: .post, parameters: NetWorkUtils.createBaseParams())
            .responseJSON { (dataResponse) in
                if NetWorkUtils.checkReponse(response: dataResponse) {
                    let resultJson = JSON(data: dataResponse.data!)
                    let titlesArray = resultJson["data"].array!
                    if !titlesArray.isEmpty {
                        for item in titlesArray {
                            if item["achievements"].arrayValue.count > 0 {
                                self.headerList.append(item)
                            }else{
                                self.titlesDataSource.append(item)
                            }
                        }
                    }
                    self.numberLabel.text = "已获成就\(self.headerList.count + self.titlesDataSource.count)个"
                    self.createAchievementList()
                    
                    if titlesArray.count <= 0 {
                        self.noValueImage.isHidden = false
                        self.achievementList.isHidden = true
                    }else{
                        self.noValueImage.isHidden = true
                        self.achievementList.isHidden = false
                    }
                }
        }
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension AchievementViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        
        let achievementImg = UIImageView()
        achievementImg.frame.size = CGSize.init(width: cell.bounds.width * 0.9, height: cell.bounds.height * 0.9)
        achievementImg.frame.origin = CGPoint.init(x: cell.bounds.width * 0.05, y: cell.bounds.height * 0.05)
        achievementImg.kf.setImage(with: URL.init(string: titlesDataSource[indexPath.row]["achievementImg"].stringValue))
        cell.addSubview(achievementImg)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
            let tips = UILabel.init()
            tips.textColor = UIColor.gray
            tips.font = UIFont.systemFont(ofSize: 12)
            tips.text = "更多成就敬请期待"
            tips.sizeToFit()
            tips.frame.origin = CGPoint.init(x: achievementList.bounds.width/2 - tips.bounds.width/2, y: 8)
            reusableView.addSubview(tips)
            return reusableView
        }else{
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! AchievementHeaderCollectionReusableView
            reusableView.dataSources = headerList
            reusableView.createGroupView()
            return reusableView
        }
        
    }
    
}




