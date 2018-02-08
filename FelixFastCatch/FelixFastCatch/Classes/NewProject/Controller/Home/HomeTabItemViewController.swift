//
//  HomeTabItemViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/17.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeTabItemViewController: UIViewController {

    /// 列表的边距
    private let listPadding:CGFloat = 14
    
    var collectionView : UICollectionView!
    
    var dataSources = [JSON]()
    
    var advList = [JSON]()
    
    /// 当前list的类型
    var type = -1
    
    var homeViewController:HomeTabViewController!
    
    //自动刷新计时器
    var refreshDataTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(listPadding, listPadding, listPadding, listPadding);
        
        // 設置每一行的間距
        layout.minimumLineSpacing = listPadding
        
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(Constants.UI.HOME_HEADER_HEIGHT))
        
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.init(red: 245/255.0, green: 255/255.0, blue: 251/255.0, alpha: 1.0)
        
        collectionView.frame.origin.y = 0
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(HomeTabCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        collectionView.register(MainADVCell.self, forCellWithReuseIdentifier: "AdvCell")
        
        if UIDevice.current.isX() {
            collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(CGFloat(Constants.UI.HOME_HEADER_HEIGHT - 44), 0, 0, 0)
        }else{
            collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(CGFloat(Constants.UI.HOME_HEADER_HEIGHT - 20), 0, 0, 0)
        }
        
        view.addSubview(collectionView)
        collectionView.reloadData()
        
    }
    
    func configureAutoScrollTimer() {
        //设置一个定时器，每三秒钟滚动一次
        refreshDataTimer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                               selector: #selector(refreshDataSources),
                                               userInfo: nil, repeats: true)
    }
    
    @objc func refreshDataSources(){
        getHomeTabData()
    }
    
}

extension HomeTabItemViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var isAdv = false
        
        if dataSources[indexPath.row]["deviceId"].stringValue == "" {
            isAdv = true
        }
        
        if isAdv {
            let advCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvCell", for: indexPath) as? MainADVCell
            
            advCell?.advImage.kf.setImage(with: URL(string: dataSources[indexPath.row]["advertiseBigImg"].stringValue))
            
            return advCell!
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as? HomeTabCell
            
            let itemData = dataSources[indexPath.row]
            
            print("itemData:\(itemData)")
            
            cell?.switchStatus(status: itemData["status"].intValue)
            cell?.productImage.kf.setImage(with: URL(string: itemData["img"].stringValue))
            
            cell?.productCoin.text = String(itemData["perDiamondsCount"].intValue)
            cell?.productName.text = itemData["award"]["title"].stringValue
            
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var cell :UICollectionReusableView!
        
        if kind == UICollectionElementKindSectionHeader {
            cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        }else{
            cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
            let notMoreValue = UILabel()
            notMoreValue.font = UIFont.systemFont(ofSize: 12)
            notMoreValue.textColor = UIColor.gray
            notMoreValue.text = "没有更多了~"
            notMoreValue.sizeToFit()
            notMoreValue.frame.origin = CGPoint(x: UIScreen.main.bounds.width/2 - notMoreValue.bounds.width/2, y: 4)
            cell.addSubview(notMoreValue)
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size:CGSize
        
        var isAdv = false

        if dataSources[indexPath.row]["deviceId"].stringValue == "" {
            isAdv = true
        }else{
            isAdv = false
        }

        if !isAdv {
            let itemWidth = (UIScreen.main.bounds.width - 14*3)/2
            // 設置每個 cell 的尺寸
            size = CGSize(width: itemWidth, height: itemWidth * 1.3)
        }else{
            let itemWidth = (UIScreen.main.bounds.width - 14*2)
            // 設置每個 cell 的尺寸
            size = CGSize(width: itemWidth, height: itemWidth * 0.4)
        }
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if UIDevice.current.isX() {
            return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(Constants.UI.HOME_HEADER_HEIGHT - 44))
        }else{
            return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(Constants.UI.HOME_HEADER_HEIGHT - 20))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(90))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemData = self.dataSources[indexPath.row]
        if itemData["deviceId"].stringValue == "" {
            /// 广告
            itemClickByAdv(item: itemData)
        }else{
            print("status:\(itemData)")
            if itemData["status"].intValue >= 2 {
                ToastUtils.showErrorToast(msg: "维护中，请稍后")
                return
            }
            itemGameRoomClick(deviceId: itemData["deviceId"].stringValue)
        }
    }
    
    /// 点击其中一个房间
    func itemGameRoomClick(deviceId:String){
        let gameRoomVC = GameRoomViewController()
        gameRoomVC.deviceId = deviceId
        homeViewController.isHide = true
        self.homeViewController.navigationController?.pushViewController(gameRoomVC, animated: true)
    }
    
    /// 点击广告
    func itemClickByAdv(item:JSON) {
        if item["redirectType"].intValue == 1 {
            let link = item["scheme"].stringValue
            // 跳转到网页
            if link == "" {
                return
            }
            let webVC = WebViewController()
            webVC.link = link
            webVC.shareTitle = item["shareTitle"].stringValue
            webVC.shareInfo = item["shareSubtitle"].stringValue
            webVC.thumbShareImage = item["shareImg"].stringValue
            webVC.actionTitle = item["name"].stringValue
            homeViewController.isHide = true
            self.homeViewController.navigationController?.pushViewController(webVC, animated: true)
        }else if item["redirectType"].intValue == 2 {
            let link = item["scheme"].intValue
            if link == -1 {
                let payVC = PayViewController()
                self.homeViewController.navigationController?.pushViewController(payVC, animated: true)
                return
            }else{
                itemGameRoomClick(deviceId: String(link))
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
    
}

extension HomeTabItemViewController{
    
    /// 获取首页数据
    func getHomeTabData() {
        var params = NetWorkUtils.createBaseParams()
        params["awardTypeId"] = String(type)
        
        Alamofire.request(Constants.Network.MAIN_LIST, method: HTTPMethod.post, parameters: params).responseJSON { (dataResponse) in
            if NetWorkUtils.checkReponse(response: dataResponse) {
                //获取数据成功
                let resultJsonData = JSON(dataResponse.data!)//返回的数据
                
                //如果数据小于0，直接返回，不执行下一步操作
                if resultJsonData["data"]["content"].arrayValue.count <= 0 {
                    return
                }
                
                self.advList.removeAll()
                self.dataSources.removeAll()
                
                if let resultAdvList = resultJsonData["data"]["advertiseVO"].array {
                    self.advList = self.advList + resultAdvList
                }
                
                self.dataSources = self.dataSources + resultJsonData["data"]["content"].arrayValue
                
                for i in 0..<self.advList.count {
                    let index = self.advList[self.advList.count - 1 - i]["sequence"].intValue
                    self.dataSources.insert(self.advList[self.advList.count - 1 - i], at: index)
                }
                
                if self.collectionView != nil {
                    self.collectionView.reloadData()
                }
                
                if self.refreshDataTimer == nil {
                    self.configureAutoScrollTimer()
                }
                
            }
        }
    }
    
}




