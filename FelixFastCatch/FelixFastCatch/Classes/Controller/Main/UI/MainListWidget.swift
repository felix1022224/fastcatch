//
//  MainListWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/26.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainListWidget: UIViewController, SPPageSubControllerDataSource {

    var index:Int = 0
    
    /// 列表的类型
    var listType:Int = 0
    
    var collectionView : UICollectionView!
    
    var homeViewController:HomeViewController!
    
    // 边距
    fileprivate let dataListPadding:CGFloat = 8
    
    // 首页列表的数据
    lazy var mainListData:[JSON] = [JSON]()
    
    /// 广告列表
    var advList:[JSON] = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(dataListPadding, dataListPadding, dataListPadding/2, dataListPadding);
        
        // 設置每一行的間距
        layout.minimumLineSpacing = dataListPadding + 1
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue((0x1<<6) - 1))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.register(MainADVCell.self, forCellWithReuseIdentifier: "AdvCell")
        collectionView.register(MainFooterCell.self, forCellWithReuseIdentifier: "FooterCell")
        
        view.addSubview(collectionView)
    }
    
    func preferScrollView() -> UIScrollView! {
        return collectionView
    }
}

// MARK: - 获取网络数据
extension MainListWidget{
    
    func getMainData() -> () {
        var params = NetWorkUtils.createBaseParams()
        params["awardTypeId"] = String(listType)
        
        Alamofire.request(Constants.Network.MAIN_LIST, method: HTTPMethod.post, parameters: params).responseJSON { (dataResponse) in
            if NetWorkUtils.checkReponse(response: dataResponse) {
                //获取数据成功
                let resultJsonData = JSON(dataResponse.data!)//返回的数据
                
                //如果数据小于0，直接返回，不执行下一步操作
                if resultJsonData["data"]["content"].arrayValue.count <= 0 {
                    return
                }
                
                if let resultAdvList = resultJsonData["data"]["advertiseVO"].array {
                    self.advList = self.advList + resultAdvList
                }
                
                self.mainListData = self.mainListData + resultJsonData["data"]["content"].arrayValue
                
                if self.collectionView != nil {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}

extension MainListWidget:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size:CGSize
        
        if indexPath.section%2 == 0 {
            let itemWidth = (CGFloat(UIScreen.main.bounds.width) - 8*2)/2 - 5
            // 設置每個 cell 的尺寸
            size = CGSize(width: itemWidth, height: itemWidth * 1.3)
        }else{
            let itemWidth = (CGFloat(UIScreen.main.bounds.width) - 8*2)
            size = CGSize(width: itemWidth, height: itemWidth/3)
        }
        
        if advList.count > 0 && indexPath.section >= advList.count*2+1 {
            let itemWidth = (CGFloat(UIScreen.main.bounds.width) - 8*2)
            size = CGSize(width: itemWidth, height: 96)
            return size
        }
        
        if advList.count <= 0 && indexPath.section == 1 {
            let itemWidth = (CGFloat(UIScreen.main.bounds.width) - 8*2)
            size = CGSize(width: itemWidth, height: 96)
            return size
        }
        return size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /// 广告数组没有的情况直接返回机器列表的长度
        if advList.count <= 0 {
            if mainListData.count <= 0 {
                return 0
            }
            if section == 1 {
                return 1
            }
            return mainListData.count
        }
        
        if advList.count * 2 + 1 < section {
            return 1
        }
        
        if section%2 == 0 || section == 0 {
            /// 不是adv, 是机器
            if section/2 > advList.count-1 {
                //最后一行
                return mainListData.count - advList[advList.count-1]["sequence"].intValue
            }
            if section == 0 {
                return advList[section/2]["sequence"].intValue
            }else{
                return advList[section/2]["sequence"].intValue - advList[section/2 - 1]["sequence"].intValue
            }
        }else{
            /// 是adv
            return 1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if advList.count <= 0 {
            return 2
        }
        /// 根据广告来拆分分组，例如 3个广告，那边是7个分组
        return advList.count * 2 + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as? MainCollectionViewCell
        
        if advList.count > 0 {
            if advList[advList.count-1]["sequence"].intValue >= mainListData.count {
                if indexPath.section > advList.count * 2 {
                    let footerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FooterCell", for: indexPath) as? MainFooterCell
                    return footerCell!
                }
            }else{
                if advList.count * 2 + 1 <= indexPath.section {
                    let footerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FooterCell", for: indexPath) as? MainFooterCell
                    return footerCell!
                }
            }
        }else{
            if advList.count <= 0 && indexPath.section == 1 {
                let footerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FooterCell", for: indexPath) as? MainFooterCell
                return footerCell!
            }
        }
        
        if indexPath.section%2 == 0  {
            var itemData:JSON;
            if indexPath.section == 0 {
                itemData = mainListData[indexPath.row]
                cell?.titleLabel.text = itemData["award"]["title"].string!
            }else{
                itemData = mainListData[indexPath.row + advList[indexPath.section/2-1]["sequence"].intValue]
                cell?.titleLabel.text = itemData["award"]["title"].string!
            }
            
            if indexPath.section == 0 {
                cell?.playBtn.tag = indexPath.row
            }else{
                cell?.playBtn.tag = indexPath.row + advList[indexPath.section/2 - 1]["sequence"].intValue
            }
            
            cell?.addPlayBtnClick(target: self, action: #selector(showPlay))
            
            cell?.productImage.kf.setImage(with: URL(string: itemData["img"].stringValue))
            
            cell?.gemNumberLabel.text = String(itemData["perDiamondsCount"].int!)
            
            if itemData["status"].intValue == 0 {
                cell?.hideErrorView()
                cell?.hideGameingView()
                cell?.playBtn.setImage(UIImage(named: "Easy"), for: .normal)
            } else if itemData["status"].intValue == 1 {
                cell?.hideErrorView()
                cell?.showGameingView()
                cell?.playBtn.setImage(UIImage(named: "Easy"), for: .normal)
            }else{
                cell?.hideGameingView()
                cell?.showErrorView()
                cell?.playBtn.setImage(UIImage(named: "维护"), for: .normal)
            }
            
            return cell!
        }else{
            if indexPath.section <= advList.count * 2 {
                let advCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvCell", for: indexPath) as? MainADVCell
                
                advCell?.advImage.kf.setImage(with: URL(string: advList[(indexPath.section-1)/2]["advertiseBigImg"].stringValue))
                return advCell!
            }
        }
        
        return cell!
    }
    
    /// 点击广告
    func advItemClick(item:JSON) -> () {
        if item["redirectType"].intValue == 1 {
            let link = item["scheme"].stringValue
            // 跳转到网页
            if link == "" {
                return
            }
            let webVC = WebViewController()
            webVC.mainVC = homeViewController
            webVC.link = link
            webVC.shareTitle = item["shareTitle"].stringValue
            webVC.shareInfo = item["shareSubtitle"].stringValue
            webVC.thumbShareImage = item["shareImg"].stringValue
            webVC.actionTitle = item["name"].stringValue
            self.navigationController?.pushViewController(webVC, animated: true)
        }else if item["redirectType"].intValue == 2 {
            let link = item["scheme"].intValue
            if link == -1 {
                homeViewController.showPayDialog()
                return
            }else{
                homeViewController.getDataByDeviceId(deviceId: String(link))
            }
        }else if item["redirectType"].intValue == 3 {
            //跳转到外部链接
            if let url = URL(string: item["scheme"].stringValue) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],completionHandler: {(success) in })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section % 2 == 0 {
            if indexPath.section == 0 {
                itemClick(index: indexPath.row)
            }else{
                itemClick(index: indexPath.row + advList[indexPath.section/2 - 1]["sequence"].intValue)
            }
        }else{
            if advList.count > 0 && indexPath.section < advList.count * 2 + 1 {
                advItemClick(item: advList[(indexPath.section - 1)/2])
            }
        }
    }
    
    /// 显示游戏界面
    @objc func showPlay(sender: UIButton) -> () {
        if !checkDeviceStatus(status: mainListData[sender.tag]["status"].intValue) {
            return
        }
        
        let gameSceneViewController = GameSceneViewController()
        
        gameSceneViewController.deviceId = mainListData[sender.tag]["deviceId"].stringValue
        
        gameSceneViewController.needLogin = { [weak self] in
            self?.homeViewController.fastLoginDialog.createView()
            self?.homeViewController.fastLoginDialog.show()
        }
        
        switch mainListData[sender.tag]["showType"].intValue {
        case 3:
            ///杜蕾斯版本
            gameSceneViewController.isDurexTheme = true
        default:
            gameSceneViewController.isDurexTheme = false
        }
        
        switch mainListData[sender.tag]["gamePeople"].intValue {
        case 2:
            //双人
            gameSceneViewController.isHorizontalGameStuts = true
        default:
            //单人
            gameSceneViewController.isHorizontalGameStuts = false
        }
        
        gameSceneViewController.advertiseImg = mainListData[sender.tag]["activity"]["advertiseImg"].stringValue
        
        gameSceneViewController.redirectType = mainListData[sender.tag]["activity"]["redirectType"].intValue
        
        gameSceneViewController.shareTitle = mainListData[sender.tag]["activity"]["shareTitle"].stringValue
        gameSceneViewController.shareInfo = mainListData[sender.tag]["activity"]["shareSubtitle"].stringValue
        gameSceneViewController.thumbShareImage = mainListData[sender.tag]["activity"]["shareImg"].stringValue
        
        gameSceneViewController.startCoinNumber = mainListData[sender.tag]["perDiamondsCount"].intValue
        
        gameSceneViewController.bottomAwardCardImagePath = mainListData[sender.tag]["award"]["img"].stringValue
        gameSceneViewController.bootomAwardDescription = mainListData[sender.tag]["award"]["description"].stringValue
        gameSceneViewController.bottomAwardTitle = mainListData[sender.tag]["award"]["title"].stringValue
        
        gameSceneViewController.bootomBannerCardImagePath = mainListData[sender.tag]["activity"]["bannerSmallImg"].stringValue
        gameSceneViewController.bottomBannerCardScheme = mainListData[sender.tag]["activity"]["scheme"].stringValue
        
        navigationController?.pushViewController(gameSceneViewController, animated: true)
    }
    
    func itemClick(index:Int) -> () {
        if !checkDeviceStatus(status: mainListData[index]["status"].intValue) {
            return
        }
        
        let gameSceneViewController = GameSceneViewController()
        gameSceneViewController.deviceId = mainListData[index]["deviceId"].stringValue
        
        gameSceneViewController.needLogin = { [weak self] in
            self?.homeViewController.fastLoginDialog.createView()
            self?.homeViewController.fastLoginDialog.show()
        }
        
        switch mainListData[index]["showType"].intValue {
        case 3:
            ///杜蕾斯版本
            gameSceneViewController.isDurexTheme = true
        default:
            gameSceneViewController.isDurexTheme = false
        }
        
        switch mainListData[index]["gamePeople"].intValue {
        case 2:
            //双人
            gameSceneViewController.isHorizontalGameStuts = true
        default:
            //单人
            gameSceneViewController.isHorizontalGameStuts = false
        }
        
        gameSceneViewController.advertiseImg = mainListData[index]["activity"]["advertiseImg"].stringValue
        
        gameSceneViewController.redirectType = mainListData[index]["activity"]["redirectType"].intValue
        
        gameSceneViewController.shareTitle = mainListData[index]["activity"]["shareTitle"].stringValue
        gameSceneViewController.shareInfo = mainListData[index]["activity"]["shareSubtitle"].stringValue
        gameSceneViewController.thumbShareImage = mainListData[index]["activity"]["shareImg"].stringValue
        gameSceneViewController.startCoinNumber = mainListData[index]["perDiamondsCount"].intValue
        gameSceneViewController.bottomAwardCardImagePath = mainListData[index]["award"]["img"].stringValue
        gameSceneViewController.bootomAwardDescription = mainListData[index]["award"]["description"].stringValue
        gameSceneViewController.bottomAwardTitle = mainListData[index]["award"]["title"].stringValue
        gameSceneViewController.bootomBannerCardImagePath = mainListData[index]["activity"]["bannerSmallImg"].stringValue
        gameSceneViewController.bottomBannerCardScheme = mainListData[index]["activity"]["scheme"].stringValue
        
        navigationController?.pushViewController(gameSceneViewController, animated: true)
    }
    
    func checkDeviceStatus(status:Int) -> Bool {
        if status == 10 {
            ToastUtils.showErrorToast(msg: "设备维护中")
            return false
        }
        if status == 20 {
            ToastUtils.showErrorToast(msg: "设备异常")
            return false
        }
        if status == 30 {
            ToastUtils.showErrorToast(msg: "设备已下线")
            return false
        }
        return true
    }
    
}





