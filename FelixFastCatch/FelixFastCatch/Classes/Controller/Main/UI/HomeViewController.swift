//
//  HomeViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/26.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HomeViewController: SPCoverController {

    /// 自定义banner的view
    var bannerView:CustomerBannerWidget!
    
    // banner数据
    fileprivate var mainBannersData:[JSON] = [JSON]()
    fileprivate var mainBannersImages:[String] = [String]()
    
    fileprivate var pagerContentController = [MainListWidget]()
    
    var statusBar:UIView!
    var tabBackgroundView:UIView!
    
    var isShowADV = false
    
    //首页的tab列表
    var tabsDataSource = [JSON]()
    
    /// 快速登录
    var fastLoginDialog:FastLoginDialog!
    
    /// 购买钻石
    var payGemDialog:PayListDialog!
    
    /// 用户信息
    var userInfoDialog:UserInfoDialog!
    
    // 设置按钮的集合view
    var settingsGroupView:UIView!
    
    /// 签到界面
    var checkInDialog:CheckInDialog!
    
    /// 邀请界面
    var inviteDialog:InviteDialog!
    
    /// 钻石btn
    var payGemBtn:MainFloatMenu!
    
    /// 是否正在加载更多
    var isLoadingMore = false
    
    /// 帮助的dialog
    var helpDialog:HelpDialog!
    
    /// 版本号显示
    var versionLabel:UILabel!
    
    /// 购买引导
    var payGuidView:MainBeginnerGuidPayView!
    
    /// 自动刷新的定时器
    var autoRefreshTimer:Timer?
    
    override func viewDidLoad() {
        
        statusBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height))
        statusBar.backgroundColor = UIColor.white
        
        createTopBackgroundView()
        
        super.viewDidLoad()
        
        bannerView = CustomerBannerWidget(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: getBannerHeight()), delegate: self)
        bannerView.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action:#selector(bannerTap))
        bannerView.addGestureRecognizer(tapGR)
        
        getHomeTabs()
        
        setupUI()
        
        self.minYPullUp = UIApplication.shared.statusBarFrame.height
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.isNavigationBarHidden = true;
        
        getBannerList()
        
        getOpenAdv()
    }

    /// banner图的点击效果
    @objc func bannerTap(){
        clickBannerItem(index: bannerView.currentIndex)
    }
    
    /// 创建顶部的背景图片
    func createTopBackgroundView() {
        tabBackgroundView = UIView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.14))
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: tabBackgroundView.bounds.height))
        let rightView = UIView(frame: CGRect(x: UIScreen.main.bounds.width - 7, y: 0, width: 7, height: tabBackgroundView.bounds.height))
        
        leftView.backgroundColor = UIColor.white
        rightView.backgroundColor = UIColor.white
        
        tabBackgroundView.backgroundColor = UIColor.clear
        tabBackgroundView.addSubview(leftView)
        tabBackgroundView.addSubview(rightView)
        
        tabBackgroundView.isUserInteractionEnabled = true
    }
    
    override func preferCoverView() -> UIView! {
        return bannerView
    }

    override func preferCoverStyle() -> CoverScrollStyle {
        return CoverScrollStyle.top
    }
    
    override func image(for index: Int) -> String! {
        return self.tabsDataSource[index]["img"].stringValue
    }
    
    override func title(for index: Int) -> String! {
        return "普通抓"
    }
    
    override func preferTabY() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height + getBannerHeight() + 4
    }
    
    override func preferCoverFrame() -> CGRect {
        return CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height - 2, width: UIScreen.main.bounds.width, height: getBannerHeight() + 4)
    }
    
    override func preferTabH(at index: Int) -> CGFloat {
        return UIScreen.main.bounds.width * 0.14
    }
    
    override func preferPageFirstAtIndex() -> Int {
        return 0
    }
    
    override func numberOfControllers() -> Int {
        return self.tabsDataSource.count
    }
    
    override func controller(at index: Int) -> UIViewController! {
        if pagerContentController.count <= 0 {
            return MainListWidget()
        }
        return pagerContentController[index]
    }
    
    override func isSubPageCanScroll(for index: Int) -> Bool {
        return true
    }
    
    override func isPreLoad() -> Bool {
        return true
    }
    
    override func needMarkView() -> Bool {
        return true
    }
    
    override func tabWidth(for index: Int) -> CGFloat {
        return (UIScreen.main.bounds.width) / 4 - 2
    }
    
    override func titleHighlightColor(for index: Int) -> UIColor! {
        return UIColor.blue
    }
    
    override func preferTabX() -> CGFloat {
        return 7
    }
    
    override func preferTabW() -> CGFloat {
        return UIScreen.main.bounds.width - 14
    }
    
    override func scroll(withPageOffset realOffset: CGFloat, index: Int) {
        super.scroll(withPageOffset: realOffset, index: index)
        UIView.animate(withDuration: 0.1) {[weak self] in
            if realOffset >= -(UIApplication.shared.statusBarFrame.height + UIScreen.main.bounds.width * 0.14) {
                self?.statusBar.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
                self?.tabBackgroundView.isHidden = false
                
                self?.tabView.layer.cornerRadius = 0
            }else {
                self?.tabView.layer.cornerRadius = 10
                self?.statusBar.backgroundColor = UIColor.clear
                
                self?.tabBackgroundView.isHidden = true
            }
        }
    }
    
    override func scrollViewContentOffset(withRatio ratio: CGFloat, draging: Bool) {
        super.scrollViewContentOffset(withRatio: ratio, draging: draging)
    }
    
    /// 显示购买的dialog
    @objc func showPayDialog() -> () {
        if Constants.isShowPay == false {
            return
        }
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        let payViewController = PayViewController()
        self.navigationController?.pushViewController(payViewController, animated: true)
    }
    
}

/// 获取首页的tab
extension HomeViewController {
    
    ///从服务器拉取tab列表
    func getHomeTabs() -> () {
        Alamofire.request(Constants.Network.MAIN_TABS, method: HTTPMethod.post, parameters: nil).responseJSON { (dataResponse) in
            if NetWorkUtils.checkReponse(response: dataResponse) {
                let resultJson = JSON(data: dataResponse.data!)
                
                if resultJson["data"].arrayValue.count != 0 {
                    self.tabsDataSource.removeAll()
                    self.tabsDataSource = self.tabsDataSource + resultJson["data"].arrayValue
                    
                    self.pagerContentController.removeAll()
                    for i in 0...self.tabsDataSource.count - 1 {
                        let itemPageContent = MainListWidget()
                        itemPageContent.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + UIApplication.shared.statusBarFrame.height)
                        itemPageContent.index = i
                        itemPageContent.listType = self.tabsDataSource[i]["id"].intValue
                        itemPageContent.homeViewController = self
                        itemPageContent.getMainData()
                        self.pagerContentController.append(itemPageContent)
                    }
                    
                    self.view.addSubview(self.tabBackgroundView)
                    self.reloadData()
                    self.view.addSubview((self.statusBar)!)
                    
                    
                    self.createRefreshTime()
                }
            }
        }
    }
    
    /// 创建自动刷新的
    func createRefreshTime() {
        if autoRefreshTimer != nil {
            return
        }
        autoRefreshTimer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                                selector: #selector(refreshListData),
                                                userInfo: nil, repeats: true)
    }
    
    /// 刷新当前数据
    @objc func refreshListData() {
        var params = NetWorkUtils.createBaseParams()
        params["awardTypeId"] = String(self.pagerContentController[self.pageController.currentPageIndex].listType)

        Alamofire.request(Constants.Network.MAIN_LIST, method: HTTPMethod.post, parameters: params).responseJSON { (dataResponse) in
            if NetWorkUtils.checkReponse(response: dataResponse) {
                //获取数据成功
                let resultJsonData = JSON(dataResponse.data!)//返回的数据

                //如果数据小于0，直接返回，不执行下一步操作
                if resultJsonData["data"]["content"].arrayValue.count <= 0 {
                    return
                }
                
                for itemController in self.pagerContentController {
                    if itemController.listType == resultJsonData["data"]["awardTypeId"].intValue {
                        itemController.advList.removeAll()
                        itemController.mainListData.removeAll()
                        if let resultAdvList = resultJsonData["data"]["advertiseVO"].array {
                            itemController.advList = itemController.advList + resultAdvList
                        }
                        
                        itemController.mainListData = itemController.mainListData + resultJsonData["data"]["content"].arrayValue
                        
                        if itemController.collectionView != nil {
                            itemController.collectionView.reloadData()
                        }
                        break
                    }
                }
            }
        }
        
        getsUserInfo()
    }
    
}

/// 首页banner 的代理
extension HomeViewController: BannerDelegate{
    
    func getBannerDataSource() -> [String] {
        return self.mainBannersImages
    }
    
    func clickBannerItem(index: Int) {
        if self.mainBannersData[index]["redirectType"].intValue == 1 {
            let link = self.mainBannersData[index]["scheme"].stringValue
            // 跳转到网页
            if link == "" {
                return
            }
            let webVC = WebViewController()
            webVC.mainVC = self
            webVC.link = link
            webVC.shareTitle = self.mainBannersData[index]["shareTitle"].stringValue
            webVC.shareInfo = self.mainBannersData[index]["shareSubtitle"].stringValue
            webVC.thumbShareImage = self.mainBannersData[index]["shareImg"].stringValue
            webVC.actionTitle = self.mainBannersData[index]["title"].stringValue
            self.navigationController?.pushViewController(webVC, animated: true)
        }else if self.mainBannersData[index]["redirectType"].intValue == 2 {
            let link = self.mainBannersData[index]["scheme"].intValue
            if link == -1 {
                showPayDialog()
                return
            }else{
                getDataByDeviceId(deviceId: String(link))
            }
        }else if self.mainBannersData[index]["redirectType"].intValue == 3 {
            if let url = URL(string: self.mainBannersData[index]["scheme"].stringValue) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],completionHandler: {(success) in })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    func isRoundCorners() -> Bool {
        return true
    }
    
    /// 获取banner图的数据列表
    fileprivate func getBannerList(){
        if self.mainBannersData.count != 0 {
            return
        }
        var params = NetWorkUtils.createBaseParams()
        params["startswith"] = "1000"
        
        Alamofire.request(Constants.Network.MAIN_BANNER_LIST, method: .post, parameters: params).responseJSON { (response) in
            if response.error == nil {
                self.mainBannersData.removeAll()
                self.mainBannersImages.removeAll()
                
                let jsonObject = JSON(response.data!)
                self.mainBannersData = jsonObject["data"].arrayValue
                
                for itemData in self.mainBannersData {
                    self.mainBannersImages.append(itemData["bannerBigImg"].stringValue)
                }
                
                self.bannerView.reloadData()
            }else{
                print("error:\(String(describing: response.error))")
            }
        }
    }
    
    /// 获取banner图的高度
    ///
    /// - Returns: banner图的高度是整体view的高的20%
    func getBannerHeight() -> CGFloat {
        return UIScreen.main.bounds.width * 0.45
    }
    
}

/// 获取单条的数据
extension HomeViewController{
    
    func getDataByDeviceId(deviceId:String) -> () {
        ToastUtils.showLoadingToast(msg: "请稍后……")
        var params = NetWorkUtils.createBaseParams()
        params["deviceids"] = deviceId
        
        Alamofire.request(Constants.Network.REFRESH_LIST_STATUS, method: .post, parameters: params).responseJSON { (dataResponse) in
            ToastUtils.hide()
            if NetWorkUtils.checkReponse(response: dataResponse) {
                let json = JSON(data: dataResponse.data!)
                if json["data"]["content"].arrayValue.count != 0 {
                    self.showItem(item: json["data"]["content"].arrayValue[0])
                }
            }else{
                ToastUtils.showLoadingToast(msg: "发生异常")
            }
        }
    }
    
    func showItem(item:JSON) {
        if !checkDeviceStatus(status: item["status"].intValue) {
            return
        }
        
        let gameSceneViewController = GameSceneViewController()
        gameSceneViewController.deviceId = item["deviceId"].stringValue
        
        gameSceneViewController.needLogin = { [weak self] in
            self?.showFastLogin()
        }
        
        switch item["showType"].intValue {
        case 3:
            ///杜蕾斯版本
            gameSceneViewController.isDurexTheme = true
        default:
            gameSceneViewController.isDurexTheme = false
        }
        
        switch item["gamePeople"].intValue {
        case 2:
            //双人
            gameSceneViewController.isHorizontalGameStuts = true
        default:
            //单人
            gameSceneViewController.isHorizontalGameStuts = false
        }
        
        gameSceneViewController.advertiseImg = item["activity"]["advertiseImg"].stringValue
        
        gameSceneViewController.redirectType = item["activity"]["redirectType"].intValue
        
        gameSceneViewController.shareTitle = item["activity"]["shareTitle"].stringValue
        gameSceneViewController.shareInfo = item["activity"]["shareSubtitle"].stringValue
        gameSceneViewController.thumbShareImage = item["activity"]["shareImg"].stringValue
        gameSceneViewController.startCoinNumber = item["perDiamondsCount"].intValue
        gameSceneViewController.bottomAwardCardImagePath = item["award"]["img"].stringValue
        gameSceneViewController.bootomAwardDescription = item["award"]["description"].stringValue
        gameSceneViewController.bottomAwardTitle = item["award"]["title"].stringValue
        gameSceneViewController.bootomBannerCardImagePath = item["activity"]["bannerSmallImg"].stringValue
        gameSceneViewController.bottomBannerCardScheme = item["activity"]["scheme"].stringValue
        
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

