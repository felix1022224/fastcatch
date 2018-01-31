//
//  HomeViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/16.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HomeTabViewController: UIViewController, UIScrollViewDelegate {

    /// 根布局滚动view
    private var rootScrollView = UIScrollView()
    
    /// 页面list列表
    private var collectionViews = [UICollectionView]()
    
    /// 页面集合
    private var itemControllers = [UIViewController]()
    
    /// 分页y轴偏移量缓存
    private var offsetYs = [CGFloat]()
    
    private var headerHeight:Float!
    
    var lastTableViewOffsetY:Float = 0.0
    
    var headerView:HomeBannerView!
    
    /// 当前的view
    var currentCollectionView:UICollectionView!
    
    /// 替代状态栏的遮盖view
    var statusBarView:UIView = UIView()
    
    // banner数据
    fileprivate var mainBannersData:[JSON] = [JSON]()
    
    //首页的tab列表
    var tabsDataSource = [JSON]()
    
    /// 顶部的tabview，当滑动到最顶部的时候显示
    var topTabVies = UIView()
    
    let topTabScrollView = UIScrollView()
    
    /// 顶部tabview的label集合
    var topTabLabels = [UILabel]()
    
    /// 顶部tabview的数据集合
    var topTabDataSources = [JSON]()
    
    /// 顶部的滚动条
    var topTabLineView = UIView()
    
    var isHide = false
    
    //自动刷新计时器
    var refreshUserInfoTimer:Timer?
    
    var testDialog:BasicDialog!
    
    /// 签到弹窗
    var myCheckInDialog :MyCheckInDialog!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerHeight = Float(Constants.UI.HOME_HEADER_HEIGHT)
        
        self.view.backgroundColor = UIColor.white
        
        rootScrollView.frame = UIScreen.main.bounds
        rootScrollView.isPagingEnabled = true
        rootScrollView.delegate = self
        
        if #available(iOS 11.0, *) {
            rootScrollView.contentInsetAdjustmentBehavior = .scrollableAxes
        } else {
            // Fallback on earlier versions
        }
        
        view.addSubview(rootScrollView)
        
        getTabData()
        
        headerView = HomeBannerView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: Constants.UI.HOME_HEADER_HEIGHT))
        headerView.tabClickCallback = { (index) in
            self.rootScrollView.scrollRectToVisible(CGRect.init(x: CGFloat(index) * UIScreen.main.bounds.width, y: 0, width: self.rootScrollView.bounds.width, height: self.rootScrollView.bounds.height), animated: true)
        }
        headerView.backgroundColor = UIColor.white
        view.addSubview(headerView)
        
        createStatusBarView()
        
        createTopTabView()
        
        getBannerList()
        
        configureAutoRefeshUserInfoTimer()
        
        let tapBanner = UITapGestureRecognizer.init(target: self, action: #selector(bannerClick))
        headerView.bannerView.addGestureRecognizer(tapBanner)
        
        self.headerView.checkInButton.addTarget(self, action: #selector(showMyCheckInDialog), for: UIControlEvents.touchUpInside)
    }
    
    /// 点击banner
    @objc func bannerClick() {
        let item = headerView.bannerDataSource[self.headerView.currentIndex]
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
            self.navigationController?.pushViewController(webVC, animated: true)
        }else if item["redirectType"].intValue == 2 {
            let link = item["scheme"].intValue
            if link == -1 {
                let payVC = PayWebViewController()
                self.navigationController?.pushViewController(payVC, animated: true)
                return
            }else{
                let gameRoomVC = GameRoomViewController()
                gameRoomVC.deviceId = String(link)
                self.navigationController?.pushViewController(gameRoomVC, animated: true)
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
    
    func configureAutoRefeshUserInfoTimer() {
        //设置一个定时器，每三秒钟滚动一次
        refreshUserInfoTimer = Timer.scheduledTimer(timeInterval: 3, target: self,
                                                selector: #selector(getsUserInfo),
                                                userInfo: nil, repeats: true)
    }
    
    /// 创建覆盖状态栏的view
    func createStatusBarView() {
        statusBarView.backgroundColor = UIColor.clear
        if UIDevice.current.isX() {
            statusBarView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        }else{
            statusBarView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20)
        }
        view.addSubview(statusBarView)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if isHide {
            return
        }
        
        let collectionView = object as? UICollectionView
        
        if keyPath != "contentOffset" {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        let tabviewOffsetY = collectionView?.contentOffset.y
        self.lastTableViewOffsetY = Float(tabviewOffsetY!)
        offsetYs[(collectionView?.tag)!] = tabviewOffsetY!
        
        UIView.animate(withDuration: 0.1) {
            self.statusBarView.backgroundColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: CGFloat(self.lastTableViewOffsetY/100))
        }
        
        let statusHeight:Float = UIDevice.current.isX() ? 44 : 20
        
        let moreHeight:Float = 14 + 45
        
        if lastTableViewOffsetY >= -statusHeight && lastTableViewOffsetY <= headerHeight {
            self.headerView.frame.origin = CGPoint(x: 0, y: Int(-statusHeight - lastTableViewOffsetY))
        }else if lastTableViewOffsetY > headerHeight {
            self.headerView.frame.origin = CGPoint(x: 0, y: Int(-headerHeight))
        }else if lastTableViewOffsetY < statusHeight + moreHeight {
            self.headerView.frame.origin = CGPoint(x: 0, y: 0)
        }
        
        UIView.animate(withDuration: 0.15) {
            if self.lastTableViewOffsetY >= self.headerHeight - statusHeight*2 - 45 {
                self.topTabVies.isHidden = false
            }else{
                self.topTabVies.isHidden = true
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isHide {
            return
        }
        
        if collectionViews.count <= 0 {
            return
        }
        
        let index = Int((scrollView.contentOffset.x - scrollView.bounds.width/2)/scrollView.bounds.width + 1)
        currentCollectionView = collectionViews[index]
        
        let statusHeight:Float = UIDevice.current.isX() ? 44 : 20
        let collectionY = CGFloat(self.headerHeight - statusHeight*2 - 45)
        
        for collectionView in self.collectionViews {
            if self.currentCollectionView.contentOffset.y < CGFloat(collectionY) {
                collectionView.contentOffset = CGPoint(x: 0, y: self.currentCollectionView.contentOffset.y)
            }
            
            if self.currentCollectionView.contentOffset.y > CGFloat(collectionY) {
                if offsetYs[collectionView.tag] > CGFloat(collectionY) {
                    collectionView.contentOffset = CGPoint(x: 0, y: offsetYs[collectionView.tag])
                }else{
                    collectionView.contentOffset = CGPoint(x: 0, y: CGFloat(collectionY))
                }
            }
        }
        
        let lineViewY = headerView.tabScrollView.bounds.height - 8
        let itemWidth = (UIScreen.main.bounds.width - 28)/4
        let x  = itemWidth/2 - headerView.lineView.bounds.width/2 + CGFloat(itemWidth * CGFloat(index))
        
        UIView.animate(withDuration: 0.2) {
            for itemView in self.headerView.tabviews {
                if itemView.tag == index {
                    itemView.tabTitle.textColor = UIColor.red
                }else{
                    itemView.tabTitle.textColor = UIColor.black
                }
            }
            
            for item in self.topTabLabels {
                if item.tag == index {
                    item.textColor = UIColor.red
                }else{
                    item.textColor = UIColor.black
                }
            }
            
            if index == 0 {
                self.headerView.lineView.frame.origin = CGPoint(x: itemWidth/2 - self.headerView.lineView.bounds.width/2, y: lineViewY)
                self.topTabLineView.frame.origin = CGPoint(x: itemWidth/2 - self.headerView.lineView.bounds.width/2, y: self.topTabLineView.frame.origin.y)
            }else{
                self.headerView.lineView.frame.origin = CGPoint(x: x, y: lineViewY)
                self.topTabLineView.frame.origin = CGPoint(x: x, y: self.topTabLineView.frame.origin.y)
                
                self.headerView.tabScrollView.scrollRectToVisible(CGRect.init(x: self.headerView.tabviews[index - 1].frame.minX - 28, y: 0, width: self.headerView.tabScrollView.bounds.width, height: self.headerView.tabScrollView.bounds.width), animated: true)
                
                self.topTabScrollView.scrollRectToVisible(CGRect.init(x: self.topTabLabels[index - 1].frame.minX - 28, y: 0, width: self.topTabScrollView.bounds.width, height: self.topTabScrollView.bounds.height), animated: true)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /// 隐藏自带的navigationBar
        self.navigationController?.isNavigationBarHidden = true
        isHide = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isHide = true
    }
    
}

extension HomeTabViewController {
    
    
    /// 创建
    func createTopTabView() {
        topTabVies = UIView()
        topTabVies.backgroundColor = UIColor.white
        topTabVies.frame = CGRect(x: 0, y: statusBarView.bounds.height, width: UIScreen.main.bounds.width, height: 45)
        view.addSubview(topTabVies)
        
        topTabScrollView.backgroundColor = UIColor.white
        topTabScrollView.frame = CGRect(x: 14, y: 0, width: UIScreen.main.bounds.width - 28, height: 45)
        topTabVies.addSubview(topTabScrollView)
        
        let blackLine = UIView()
        blackLine.backgroundColor = UIColor.gray
        blackLine.frame = CGRect(x: 0, y: topTabVies.bounds.height - 0.2, width: UIScreen.main.bounds.width, height: 0.2)
        topTabVies.addSubview(blackLine)
        
        topTabLineView = UIView()
        topTabLineView.backgroundColor = UIColor.red
        topTabLineView.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width - 28)/10, height: 3)
        topTabLineView.layer.cornerRadius = 2
        topTabLineView.layer.masksToBounds = true
        topTabScrollView.addSubview(topTabLineView)
        
        topTabScrollView.showsVerticalScrollIndicator = false
        topTabScrollView.showsHorizontalScrollIndicator = false
        
        let lineViewY = topTabScrollView.bounds.height - 8
        let itemWidth = (UIScreen.main.bounds.width - 28)/4
        
        topTabVies.isHidden = true
        
        topTabLineView.frame.origin = CGPoint(x: itemWidth/2 - topTabLineView.bounds.width/2, y: lineViewY)
    }
    
    /// 更新顶部的tab
    func udpdateTopTabs() {
        for i in 0..<self.tabsDataSource.count {
            let tabItem = createTopTabItem(index: i, title: self.tabsDataSource[i]["title"].stringValue)
            topTabScrollView.addSubview(tabItem)
            topTabLabels.append(tabItem)
        }
        topTabScrollView.contentSize = CGSize(width: (UIScreen.main.bounds.width - 28)/4 * CGFloat(self.tabsDataSource.count), height: 45)
    }
    
    func createTopTabItem(index:Int, title:String) -> UILabel {
        let titleItem = UILabel()
        titleItem.font = UIFont.systemFont(ofSize: 12)
        if index == 0 {
            titleItem.textColor = UIColor.red
        }else{
            titleItem.textColor = UIColor.black
        }
        titleItem.frame = CGRect(x: CGFloat(index) * (UIScreen.main.bounds.width - 28)/4, y: 0, width: (UIScreen.main.bounds.width - 28)/4, height: 45)
        titleItem.tag = index
        titleItem.text = title
        titleItem.textAlignment = .center
        let tap = UITapGestureRecognizer(target: self, action: #selector(topTabClick(index:)))
        titleItem.addGestureRecognizer(tap)
        titleItem.isUserInteractionEnabled = true
        return titleItem
    }
    
    @objc func topTabClick(index:UITapGestureRecognizer){
        UIView.animate(withDuration: 0.2) {
            self.rootScrollView.scrollRectToVisible(CGRect.init(x: CGFloat((index.view?.tag)!) * UIScreen.main.bounds.width, y: 0, width: self.rootScrollView.bounds.width, height: self.rootScrollView.bounds.height), animated: true)
        }
    }
    
    @objc func showMyCheckInDialog() {
        if myCheckInDialog == nil {
            myCheckInDialog = MyCheckInDialog(frame: UIScreen.main.bounds)
        }
        myCheckInDialog.createView()
        myCheckInDialog.show()
    }
    
}

extension HomeTabViewController{
    
    /// 获取首页tab的数据
    func getTabData() {
        Alamofire.request(Constants.Network.MAIN_TABS, method: HTTPMethod.post, parameters: nil).responseJSON { (dataResponse) in
            if NetWorkUtils.checkReponse(response: dataResponse) {
                let resultJson = JSON(data: dataResponse.data!)
                
                if resultJson["data"].arrayValue.count != 0 {
                    self.tabsDataSource.removeAll()
                    self.tabsDataSource = self.tabsDataSource + resultJson["data"].arrayValue
                    
                    self.topTabDataSources = self.tabsDataSource
                    
                    self.udpdateTopTabs()
                    
                    self.headerView.createTabViews(jsonData: self.tabsDataSource)
                    
                    for i in 0...self.tabsDataSource.count - 1 {
                        let itemPageContent = HomeTabItemViewController()
                        itemPageContent.view.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(i), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        self.rootScrollView.addSubview(itemPageContent.view)
                        
                        itemPageContent.type = self.tabsDataSource[i]["id"].intValue
                        itemPageContent.getHomeTabData()
                        
                        self.itemControllers.append(itemPageContent)
                        self.collectionViews.append(itemPageContent.collectionView)
                        self.offsetYs.append(0.0)
                        
                        itemPageContent.homeViewController = self
                        
                        itemPageContent.collectionView.tag = i
                        
                        itemPageContent.collectionView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
                    }
                    
                    self.rootScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(self.tabsDataSource.count), height: UIScreen.main.bounds.height)
                    
                    self.getsUserInfo()
                }
            }
        }
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
                
                let jsonObject = JSON(response.data!)
                self.mainBannersData = jsonObject["data"].arrayValue
                
                self.headerView.createBannerView(jsonData: self.mainBannersData)
            }
        }
    }
    
    /// 来到首页的时候，读取用户信息
    @objc func getsUserInfo() -> () {
        if Constants.User.USER_ID == "" {
            return
        }
        
        UserTools.getUserInfo(callback: { })
    }
    
}





