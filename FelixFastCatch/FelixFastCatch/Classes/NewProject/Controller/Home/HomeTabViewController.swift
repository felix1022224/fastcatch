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
    
    private var headerHeight:CGFloat!
    
    var lastTableViewOffsetY:CGFloat = 0.0
    
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
    
    var isHide = true
    
    //自动刷新计时器
    var refreshUserInfoTimer:Timer?
    
    var testDialog:BasicDialog!
    
    /// 签到弹窗
    var myCheckInDialog :MyCheckInDialog!
    
    /// 是否自动显示过签到了
    var isAutoShowCheckInDialog = false
    
    /// 新用户一元礼包
    var newUserGiftDialog:NewUserGiftDialog!
    
    /// 是否已经显示过了一元礼包
    var isShowNewUserGiftDialog = false
    
    /// 是否偏移量为0
    var isStartOffsetZero = false
    
    var isAddStatus = false
    
    var isShowADV = false
    
    /// 通知的类型
    var notificationType:String = ""
    
    /// 通知的内容,房间号,H5地址
    var notificationContent:String = ""
    var notificationContentDict:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerHeight = CGFloat(Constants.UI.HOME_HEADER_HEIGHT)
        
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
        
        headerView = HomeBannerView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: Int(headerHeight)))
        headerView.tabClickCallback = { (index) in
            self.rootScrollView.scrollRectToVisible(CGRect.init(x: CGFloat(index) * UIScreen.main.bounds.width, y: 0, width: self.rootScrollView.bounds.width, height: UIScreen.main.bounds.height), animated: true)
        }
        headerView.backgroundColor = UIColor.white
        view.addSubview(headerView)
        
        createStatusBarView()
        
        createTopTabView()
        
        configureAutoRefeshUserInfoTimer()
        
        let tapBanner = UITapGestureRecognizer.init(target: self, action: #selector(bannerClick))
        headerView.bannerView.addGestureRecognizer(tapBanner)
        
        self.headerView.checkInButton.addTarget(self, action: #selector(showMyCheckInDialog), for: UIControlEvents.touchUpInside)
    }
    
    func startNotification() {
        if SplashView.isExistsSplashData() == false {
            /// 没广告的情况下
            if notificationType != "" {
                if notificationType == "1" {
                    // H5
                    if notificationContentDict != nil {
                        let webVC = WebViewController()
                        webVC.link = notificationContentDict["scheme"]! as? String ?? ""
                        webVC.shareTitle = notificationContentDict["shareTitle"]! as? String ?? ""
                        webVC.shareInfo = notificationContentDict["shareSubtitle"]! as? String ?? ""
                        webVC.thumbShareImage = notificationContentDict["shareImg"]! as? String ?? ""
                        webVC.actionTitle = notificationContentDict["title"]! as? String ?? ""
                        self.navigationController?.pushViewController(webVC, animated: true)
                    }
                }else if notificationType == "2" {
                    // 跳转到房间
                    let gameRoomVC = GameRoomViewController()
                    gameRoomVC.deviceId = notificationContent
                    self.navigationController?.pushViewController(gameRoomVC, animated: true)
                }else if notificationType == "6" && Constants.User.ID != "" {
                    // 邀请页
                    let inviteVC = InviteViewController()
                    self.navigationController?.pushViewController(inviteVC, animated: true)
                }else if notificationType == "7" && Constants.User.ID != "" {
                    // 我的消息
                    self.navigationController?.pushViewController(MessageListViewController(), animated: true)
                }
            }
        }
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
            webVC.actionTitle = item["shareTitle"].stringValue
            self.navigationController?.pushViewController(webVC, animated: true)
        }else if item["redirectType"].intValue == 2 {
            let link = item["scheme"].intValue
            if link == -1 {
                PayWebViewController.showPayWebVC(isShowBack: true)
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
        
        if isAddStatus == false {
            isAddStatus = true
            if (collectionView?.contentOffset.y)! >= CGFloat(0) {
                isStartOffsetZero = true
            }else{
                isStartOffsetZero = false
            }
        }

        let tabviewOffsetY = collectionView?.contentOffset.y
        self.lastTableViewOffsetY = CGFloat(tabviewOffsetY!)
        offsetYs[(collectionView?.tag)!] = tabviewOffsetY!

        UIView.animate(withDuration: 0.1) {
            self.statusBarView.backgroundColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: CGFloat(self.lastTableViewOffsetY/100))
        }

        let statusHeight:CGFloat = UIDevice.current.isX() ? 44 : 20

        let moreHeight:CGFloat = self.headerView.tabItemHeight
        
        if isStartOffsetZero {
            if lastTableViewOffsetY >= 0 && lastTableViewOffsetY <= headerHeight {
                self.headerView.frame.origin = CGPoint(x: 0, y: Int(0 - lastTableViewOffsetY))
            }else if lastTableViewOffsetY > headerHeight {
                self.headerView.frame.origin = CGPoint(x: 0, y: Int(-headerHeight))
            }else if lastTableViewOffsetY < statusHeight + moreHeight {
                self.headerView.frame.origin = CGPoint(x: 0, y: 0)
            }
        }else{
            if lastTableViewOffsetY >= -statusHeight && lastTableViewOffsetY <= headerHeight {
                self.headerView.frame.origin = CGPoint(x: 0, y: Int(-statusHeight - lastTableViewOffsetY))
            }else if lastTableViewOffsetY > headerHeight {
                self.headerView.frame.origin = CGPoint(x: 0, y: Int(-headerHeight))
            }else if lastTableViewOffsetY < statusHeight + moreHeight {
                self.headerView.frame.origin = CGPoint(x: 0, y: 0)
            }
        }

        let statusHeight2:CGFloat = UIDevice.current.isX() ? 44 : 0
        
        if isStartOffsetZero {
            if self.lastTableViewOffsetY >= CGFloat(self.headerHeight) - self.headerView.tabItemHeight + UIApplication.shared.statusBarFrame.height {
                self.topTabVies.isHidden = false
            }else{
                self.topTabVies.isHidden = true
            }
        }else{
            if self.lastTableViewOffsetY >= CGFloat(self.headerHeight) - statusHeight2 - self.headerView.tabItemHeight {
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

        var collectionY:CGFloat
        if UIDevice.current.isX() {
            collectionY = CGFloat(self.headerHeight) - self.headerView.tabItemHeight + 0.5 - UIApplication.shared.statusBarFrame.height
        }else{
            collectionY = CGFloat(self.headerHeight) - self.headerView.tabItemHeight + 0.5
        }
        
        if isStartOffsetZero {
            collectionY = CGFloat(self.headerHeight) - self.headerView.tabItemHeight + 0.5 + UIApplication.shared.statusBarFrame.height
        }
        
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
                    itemView.tabTitle.textColor = UIColor.init(red: 65/255.0, green: 33/255.0, blue: 15/255.0, alpha: 1.0)
                    itemView.tabTitle.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
                }else{
                    itemView.tabTitle.textColor = UIColor.init(red: 65/255.0, green: 33/255.0, blue: 15/255.0, alpha: 1.0)
                    itemView.tabTitle.font = UIFont.systemFont(ofSize: 12)
                }
            }

            for item in self.topTabLabels {
                if item.tag == index {
                    item.textColor = UIColor.init(red: 65/255.0, green: 33/255.0, blue: 15/255.0, alpha: 1.0)
                    item.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
                }else{
                    item.textColor = UIColor.init(red: 65/255.0, green: 33/255.0, blue: 15/255.0, alpha: 1.0)
                    item.font = UIFont.systemFont(ofSize: 12)
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
        
        if isShowADV {
            isHide = false
            isShowADV = true
            
            updateHome()
            return
        }
        if SplashView.isExistsSplashData() == false {
            isHide = false
            isShowADV = true
            
            updateHome()
            return
        }
        SplashView.showSplashView(duration: 5, defaultImage: UIImage(named: "Launchplaceholder"), tapSplashImageBlock: { (resultStr) in
            if resultStr != "" {
                switch UserDefaults.standard.integer(forKey: SplashView.OPEN_ADV_URL_TYPE) {
                case 1:
                    let link = resultStr
                    // 跳转到网页
                    if link == "" {
                        return
                    }
                    let webVC = WebViewController()
                    webVC.link = link
                    webVC.shareTitle = UserDefaults.standard.string(forKey: SplashView.OPEN_ADV_SHARE_TITLE)
                    webVC.shareInfo = UserDefaults.standard.string(forKey: SplashView.OPEN_ADV_SHARE_INFO)
                    webVC.thumbShareImage = UserDefaults.standard.string(forKey: SplashView.OPEN_ADV_SHARE_THUMBIMAGE)
                    webVC.actionTitle = UserDefaults.standard.string(forKey: SplashView.OPEN_ADV_URL_TITLE)
                    self.navigationController?.pushViewController(webVC, animated: true)
                    break
                case 2:
                    let link = Int(resultStr!)
                    if link == -1 {
                        let payVC = PayViewController()
                        self.navigationController?.pushViewController(payVC, animated: true)
                    }
                    break
                case 3:
                    //跳转到外部链接
                    if let url = URL(string: resultStr!) {
                        //根据iOS系统版本，分别处理
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url, options: [:],completionHandler: {(success) in })
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    break
                default: break
                    //什么都不干
                }
            }
        }) { (isDiss) in
            self.isShowADV = true
            self.isHide = false
            
            self.updateHome()
            
            /// 没广告的情况下
            if self.notificationType != "" {
                if self.notificationType == "1" {
                    // H5
                    if self.notificationContentDict != nil {
                        let webVC = WebViewController()
                        webVC.link = self.notificationContentDict["scheme"]! as? String ?? ""
                        webVC.shareTitle = self.notificationContentDict["shareTitle"]! as? String ?? ""
                        webVC.shareInfo = self.notificationContentDict["shareSubtitle"]! as? String ?? ""
                        webVC.thumbShareImage = self.notificationContentDict["shareImg"]! as? String ?? ""
                        webVC.actionTitle = self.notificationContentDict["title"]! as? String ?? ""
                        self.navigationController?.pushViewController(webVC, animated: true)
                    }
                }else if self.notificationType == "2" {
                    // 跳转到房间
                    let gameRoomVC = GameRoomViewController()
                    gameRoomVC.deviceId = self.notificationContent
                    self.navigationController?.pushViewController(gameRoomVC, animated: true)
                }else if self.notificationType == "6" && Constants.User.ID != "" {
                    // 邀请页
                    let inviteVC = InviteViewController()
                    self.navigationController?.pushViewController(inviteVC, animated: true)
                }else if self.notificationType == "7" && Constants.User.ID != "" {
                    // 我的消息
                    self.navigationController?.pushViewController(MessageListViewController(), animated: true)
                }
            }
        }
    }
    
    func updateHome() {
        if self.mainBannersData.count <= 0 {
            self.getTabData()
            
            self.getBannerList()
        }
        
        if self.isAutoShowCheckInDialog == false && Constants.User.todayChecked == false {
            self.isAutoShowCheckInDialog = true
            self.showMyCheckInDialog()
        }
        if self.isShowNewUserGiftDialog == false && Constants.User.ID != "" {
            self.showNewUserGiftDialog()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isHide = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isHide = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isHide = false
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
        topTabLineView.backgroundColor = UIColor.init(red: 255/255.0, green: 194/255.0, blue: 53/255.0, alpha: 1.0)
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
        if index == 0 {
            titleItem.textColor = UIColor.init(red: 65/255.0, green: 33/255.0, blue: 15/255.0, alpha: 1.0)
            titleItem.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        }else{
            titleItem.textColor = UIColor.init(red: 65/255.0, green: 33/255.0, blue: 15/255.0, alpha: 1.0)
            titleItem.font = UIFont.systemFont(ofSize: 12)
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
        if Constants.User.ID == "" {
            LoginViewController.showLoginVC()
            return
        }
        myCheckInDialog = MyCheckInDialog(frame: UIScreen.main.bounds)
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
                    
                    self.rootScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(self.tabsDataSource.count), height: 1)
                    
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
    
    @objc func showNewUserGiftDialog(){
        if isShowNewUserGiftDialog {
            return
        }
        Alamofire.request(Constants.Network.Gift.IS_NEW_USER_GIFT).responseJSON { (dataReponse) in
            if NetWorkUtils.checkReponse(response: dataReponse) {
                let result = JSON.init(data: dataReponse.data!)
                if result["data"].boolValue == false {
                    self.newUserGiftDialog = nil
                    self.newUserGiftDialog = NewUserGiftDialog(frame: UIScreen.main.bounds)
                    self.newUserGiftDialog.createView()
                    self.newUserGiftDialog.show()
                    self.isShowNewUserGiftDialog = true
                }
            }
        }
    }
    
}





