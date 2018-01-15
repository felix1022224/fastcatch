//
//  MainViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/7/25.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import MJRefresh
import StoreKit
import SocketIO

class MainViewController: UIViewController{

    // 背景图
    fileprivate lazy var backgroundImage:UIImageView = UIImageView()
    
    /// banner images
    fileprivate lazy var bannerView:CustomerBannerView = CustomerBannerView()
    
    /// 顶部集合
    fileprivate lazy var bannerGroupView:UIView = UIView()
    
    fileprivate var topBannerView:CustomerBannerWidget!
    
    // banner 指示器
    fileprivate lazy var pageControl:UIPageControl = UIPageControl()
    
    // 数据列表
    fileprivate var dataList:UICollectionView!
    
    // 边距
    fileprivate let dataListPadding:CGFloat = 8
    
    // 计时器
    fileprivate var timer:Timer!
    
    // banner数据
    fileprivate var mainBannersData:[JSON] = [JSON]()
    fileprivate var mainBannersImages:[String] = [String]()
    
    // 首页列表的数据
    lazy var mainListData:[JSON] = [JSON]()
    
    // 当前的页数
    fileprivate var page:Int = 0
    
    // 没有数据时需要展示的view
    fileprivate var noValueBtn:UIButton!
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    
    // 是否是下拉刷新
    fileprivate var isRefresh:Bool = false
    
    /// 快速登录
    fileprivate var fastLoginDialog:FastLoginDialog!
    
    /// 购买钻石
    fileprivate var payGemDialog:PayListDialog!
    
    /// 用户信息
    fileprivate var userInfoDialog:UserInfoDialog!
    
    // 设置按钮的集合view
    fileprivate var settingsGroupView:UIView!
    
    /// 签到界面
    fileprivate var checkInDialog:CheckInDialog!
    
    /// 邀请界面
    fileprivate var inviteDialog:InviteDialog!
    
    /// 钻石btn
    fileprivate var payGemBtn:MainFloatMenu!
    
    /// 是否正在加载更多
    fileprivate var isLoadingMore = false
    
    /// 帮助的dialog
    fileprivate var helpDialog:HelpDialog!
    
    /// 版本号显示
    fileprivate var versionLabel:UILabel!
    
    /// 是否正在加载主页的数据
    fileprivate var isLoadingMainData = false
    
    /// banner的view是否触摸中
    fileprivate var bannerViewIsTouch = false
    
    /// 购买引导
    fileprivate var payGuidView:MainBeginnerGuidPayView!
    
    /// 广告列表
    fileprivate var advList:[JSON] = [JSON]()
    
    /// 记录坐标: 1，section的位置 2，类型 3，广告的位置 4，机器的位置
    fileprivate var positionList:[String: [String: String]] = [String: [String: String]]()
    
    /// section的记录list，来区分类型和长度
    fileprivate var sectionList:[String: [String: String]] = [String: [String: String]]()
    
    fileprivate var spiltMachineList:[String: [JSON]] = [String: [JSON]]()
    
    fileprivate var isShowADV = false
    
    /// 顶部集合
    fileprivate lazy var topView = UIImageView()
    
    /// 换一批的按钮
    fileprivate lazy var changeListBtn = UIButton(type: UIButtonType.custom)
    
    /// 是否允许加载列表的状态
    var isNotAllowedListStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        backgroundImage.image = UIImage(named: "邮寄背景")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(backgroundImage)
        
        setupUI()
        getOpenAdv()
        
    }
    
    /// 切换list
    @objc func changeListData(){
        isRefresh = true
        isNotAllowedListStatus = true
        getMainListData()
    }

    override func viewWillAppear(_ animated: Bool) {
        if isShowADV {
            isShowADV = true
            return
        }
        if SplashView.isExistsSplashData() == false {
            isShowADV = true
            if Constants.User.USER_ID != "" {
                getsUserInfo()
            }
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
//                    webVC.mainVC = self
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
                        self.showPayDialog()
                    }else{
                        self.itemClick(index: link!)
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
            
            if Constants.User.USER_ID == "" {
                
            }else {
                self.getsUserInfo()
            }
        }
    }
    
    /// 在加载显示完首页的viewcontroller之后，需要调用该方法来成功获取系统的window
    func loadDialogToWindow() -> () {
        fastLoginDialog = FastLoginDialog(frame: UIScreen.main.bounds)
        
        /// 购买钻石的dialog
        payGemDialog = PayListDialog(frame: UIScreen.main.bounds)
        
        /// 用户信息
        userInfoDialog = UserInfoDialog(frame: UIScreen.main.bounds)
        
        /// 签到
        checkInDialog = CheckInDialog(frame: UIScreen.main.bounds)
        
        /// 邀请
        inviteDialog = InviteDialog(frame: UIScreen.main.bounds)
        
        /// 帮助
        helpDialog = HelpDialog(frame: UIScreen.main.bounds)
        
        if UserDefaults.standard.bool(forKey: Constants.IS_FIRST_OPEN_MAIN) == false {
            payGuidView = MainBeginnerGuidPayView(frame: UIScreen.main.bounds)
            payGuidView.createView()
            payGuidView.show()
            UserDefaults.standard.set(true, forKey: Constants.IS_FIRST_OPEN_MAIN)
        }
    }
    
    /// 初始化
    func setupUI() -> () {
        createBannerView()
        createDataList()
        createMainBtns()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //每次显示界面，调用一遍获取用户信息的接口
        if Constants.User.USER_ID != "" {
            getsUserInfo()
            if payGemBtn != nil {
                payGemBtn.actionLabel.text = String(Constants.User.diamondsCount)
            }
        }
        
        self.bannerViewIsTouch = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        self.bannerViewIsTouch = true
    }
    
}

// MARK: - Banner Images
extension MainViewController:UIScrollViewDelegate{
    
    /// 创建banner的view
    func createBannerView() -> () {
        //设置banner图view的属性
        topBannerView = CustomerBannerWidget(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: getBannerHeight()), delegate: self)
        topBannerView.isUserInteractionEnabled = true
        view.addSubview(topBannerView)
        
        let tapGR = UITapGestureRecognizer(target: self, action:#selector(bannerTap))
        topBannerView.isUserInteractionEnabled = true
        topBannerView.addGestureRecognizer(tapGR)
    }
    
    /// banner图的点击效果
    @objc func bannerTap(){
        clickBannerItem(index: topBannerView.currentIndex)
    }
    
    /// 获取banner图的高度
    ///
    /// - Returns: banner图的高度是整体view的高的20%
    func getBannerHeight() -> CGFloat {
        return UIScreen.main.bounds.width * 0.45 - 1
    }
}

/// 首页banner 的代理
extension MainViewController: BannerDelegate{
    
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
//            webVC.mainVC = self
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
                itemClick(index: link)
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
    
}

// MARK: - 从网络获取banner图数据
extension MainViewController{
    
    /// 获取banner图的数据列表
    fileprivate func getBannerList(){
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
                
                self.topBannerView.reloadData()
            }else{
                
            }
        }
    }
    
}

// MARK: - 装载首页的列表数据
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    // 创建首页的数据列表
    func createDataList() -> () {
        
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(dataListPadding/2, dataListPadding, dataListPadding/2, dataListPadding);

        // 設置每一行的間距
        layout.minimumLineSpacing = dataListPadding + 1
        
        // 設置 header 及 footer 的尺寸
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width - 10, height: getBannerHeight() - 15)
        
        dataList = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - topView.bounds.height), collectionViewLayout: layout)
        dataList.backgroundColor = UIColor.clear
        
        self.dataList.delegate = self
        self.dataList.dataSource = self
        
        view.addSubview(dataList)
        
        dataList.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        dataList.register(MainADVCell.self, forCellWithReuseIdentifier: "AdvCell")
        dataList.register(MainFooterCell.self, forCellWithReuseIdentifier: "FooterCell")
        dataList.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
        //下拉刷新相关设置
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header.lastUpdatedTimeLabel.isHidden = true // 隐藏时间
        //隐藏状态
        header.stateLabel.isHidden = true
        
        getMainListData()
    }
    
    //顶部下拉刷新
    @objc func headerRefresh(){
        page = 0
        isRefresh = true
        getMainListData()
    }
    
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
            size = CGSize(width: itemWidth, height: 90)
            return size
        }

        if advList.count <= 0 && indexPath.section == 1 {
            let itemWidth = (CGFloat(UIScreen.main.bounds.width) - 8*2)
            size = CGSize(width: itemWidth, height: 90)
            return size
        }
        return size
    }
    
    /// 返回高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: UIScreen.main.bounds.width - 14, height: getBannerHeight() - 8)
        }
        return CGSize(width: 0, height: 0)
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
//            webVC.mainVC = self
            webVC.link = link
            webVC.shareTitle = item["shareTitle"].stringValue
            webVC.shareInfo = item["shareSubtitle"].stringValue
            webVC.thumbShareImage = item["shareImg"].stringValue
            webVC.actionTitle = item["name"].stringValue
            self.navigationController?.pushViewController(webVC, animated: true)
        }else if item["redirectType"].intValue == 2 {
            let link = item["scheme"].intValue
            if link == -1 {
                showPayDialog()
                return
            }else{
                itemClick(index: link)
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var header = UICollectionReusableView()
        
        if kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            header.addSubview(topBannerView)
            
            if indexPath.section == 0 {
                header.isHidden = false
            }else{
                header.isHidden = true
            }
            
        }
        
        return header
    }
    
    func loadMore() -> () {

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
            self?.fastLoginDialog.createView()
            self?.fastLoginDialog.show()
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
            self?.fastLoginDialog.createView()
            self?.fastLoginDialog.show()
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
    
    func getPlayVC(index:Int) -> PlayViewController? {
        if checkDeviceStatus(status: mainListData[index]["status"].intValue) {
            let playView = PlayViewController()
            playView.deviceId = mainListData[index]["deviceId"].stringValue
            playView.darwCount = mainListData[index]["darwCount"].intValue
            playView.needLogin = { [weak self] in
                self?.fastLoginDialog.createView()
                self?.fastLoginDialog.show()
            }
            
            playView.mainVC = self
            
            playView.bottomAwardCardImagePath = mainListData[index]["award"]["img"].stringValue
            playView.bootomAwardDescription = mainListData[index]["award"]["description"].stringValue
            playView.bottomAwardTitle = mainListData[index]["award"]["title"].stringValue
            
            playView.bootomBannerCardImagePath = mainListData[index]["activity"]["bannerSmallImg"].stringValue
            playView.bottomBannerCardScheme = mainListData[index]["activity"]["scheme"].stringValue
            
            return playView
        }
        return nil
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


// MARK: - 从网络获取首页的网络数据
extension MainViewController{
    /// 获取首页的数据
    func getMainListData() -> () {
        if isLoadingMainData {
            return
        }
        
        isLoadingMainData = true
        
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "1000"
        params["page"] = String(page)
        params["startswith"] = "1000"
        
        Alamofire.request(Constants.Network.MAIN_LIST, method: .post, parameters: params).responseJSON { (response) in
            self.isLoadingMore = false
            self.isLoadingMainData = false
            
            if response.error == nil {
                let jsonObject = JSON(response.data!)
                
                if jsonObject["data"]["content"].arrayValue.count <= 0 {
                    return
                }
                
                self.isNotAllowedListStatus = false
                
                if self.isRefresh {
                    self.mainListData.removeAll()
                    self.advList.removeAll()
                    self.isRefresh = false
                }
                
                if let resultAdvList = jsonObject["data"]["advertiseVO"].array {
                    self.advList = self.advList + resultAdvList
                    self.changeAdvList()
                }
                
                self.mainListData = self.mainListData + jsonObject["data"]["content"].arrayValue
                self.dataList.reloadData()
                
                // 如果数据不等于0 页码+1
                if self.mainListData.count > 0 {
                    self.page += 1
                    if self.noValueBtn != nil {
                        self.noValueBtn.isHidden = true
                    }
                    self.dataList.isHidden = false
                }else{
                    // 没有数据
                    self.setupNoValueView()
                }
            }else {
                // 数量小于等于0
                if self.mainListData.count <= 0 {
                    // 没有数据
                    self.setupNoValueView()
                }
            }
            SVProgressHUD.dismiss()
            
            /// 大于0的情况才进行刷新
            if self.mainListData.count > 0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: { [weak self] in
                    self?.page = 0
                    self?.isRefresh = true
                    self?.isLoadingMainData = false
                    self?.getMainListData()
                    self?.getsUserInfo()
                })
            }
        }
        
        if mainBannersData.count <= 0 {
            getBannerList()
        }
        
    }
    
    /// 根据广告列表计算出位置
    func changeAdvList() -> () {
        /// 取出advlist的数据
        
    }
    
    /// 没有数据，需要展示没有数据的view
    func setupNoValueView() -> () {
        if noValueBtn == nil {
            noValueBtn = UIButton(type: .system)
            noValueBtn.setTitle("发生错误，点击重试", for: .normal)
            noValueBtn.sizeToFit()
            noValueBtn.setTitleColor(UIColor.orange, for: .normal)
            noValueBtn.layer.borderWidth = 1
            noValueBtn.layer.borderColor = UIColor.orange.cgColor
            noValueBtn.layer.cornerRadius = 5
            noValueBtn.layer.masksToBounds = true
            noValueBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(14))
            view.addSubview(noValueBtn)
            
            noValueBtn.frame = CGRect(x: self.view.bounds.width/2 - (noValueBtn.bounds.width*1.2)/2, y: self.view.bounds.height/2 - noValueBtn.bounds.height/2, width: noValueBtn.bounds.width*1.2, height: noValueBtn.bounds.height + noValueBtn.bounds.height/2)
            
            noValueBtn.addTarget(self, action: #selector(reLoadNetworkData), for: .touchUpInside)
        }
        
        noValueBtn.isHidden = false
        dataList.isHidden = true
    }
    
    // 重新获取数据
    @objc func reLoadNetworkData() -> () {
        ToastUtils.showLoadingToast(msg: "加载数据……")
        getMainListData()
    }
    
}

// MARK: - 按钮集合
extension MainViewController{
    
    // 创建首页的按钮
    func createMainBtns() -> () {
        // 设置按钮
        let settingImage = UIImageView(image: UIImage(named: "Settings-btn"))
        
        setupSettings(testImage: settingImage)
        
        let settingsBtn = MainFloatMenu(frame: CGRect(x: self.view.bounds.width - 10 - settingImage.bounds.width, y: UIScreen.main.bounds.height - 90, width: settingImage.bounds.width, height: settingImage.bounds.height), image: settingImage.image, actionTitle: "设置")
        view.addSubview(settingsBtn)  
        
        settingsBtn.addBtnClickAction(target: self, action: #selector(settingsClick))
        
        /// 邀请按钮
        let inviteBtn = MainFloatMenu(frame: CGRect(x: self.view.bounds.width - 10 * 2 - settingsBtn.bounds.width * 2, y: UIScreen.main.bounds.height - 90, width: settingsBtn.bounds.width, height: settingsBtn.bounds.height), image: UIImage(named: "Store-btn"), actionTitle: "邀请")
        view.addSubview(inviteBtn)
        
        inviteBtn.addBtnClickAction(target: self, action: #selector(showInviteDialog))
        
        /// 签到
        let checkInBtn = MainFloatMenu(frame: CGRect(x: self.view.bounds.width - 10 * 3 - settingsBtn.bounds.width * 3, y: UIScreen.main.bounds.height - 90, width: settingsBtn.bounds.width, height: settingsBtn.bounds.height), image: UIImage(named: "Achievements-btn"), actionTitle: "签到")
        view.addSubview(checkInBtn)
        checkInBtn.addBtnClickAction(target: self, action: #selector(showCheckInDialog))
        
        /// 礼物按钮
        let giftBtn = MainFloatMenu(frame: CGRect(x: self.view.bounds.width - 10 * 4 - settingsBtn.bounds.width * 4, y: UIScreen.main.bounds.height - 90, width: settingsBtn.bounds.width, height: settingsBtn.bounds.height), image: UIImage(named: "Leaderboard-btn"), actionTitle: "奖品")
        view.addSubview(giftBtn)
        giftBtn.addBtnClickAction(target: self, action: #selector(showMyGift))
        
        /// 购买钻石按钮
        payGemBtn = MainFloatMenu(frame: CGRect(x: 10, y: UIScreen.main.bounds.height - 90, width: settingImage.bounds.width, height: 90), image: UIImage(named: "Plus-btn"), actionTitle: "0")
        view.addSubview(payGemBtn)
        
        let infoDictionary = Bundle.main.infoDictionary!
        versionLabel = UILabel()
        versionLabel.font = UIFont.systemFont(ofSize: 12)
        versionLabel.textColor = UIColor.lightGray
        versionLabel.text = "V " + (infoDictionary["CFBundleShortVersionString"] as? String)!
        versionLabel.sizeToFit()
        versionLabel.frame = CGRect(x: UIScreen.main.bounds.width - versionLabel.bounds.width, y: UIScreen.main.bounds.height - versionLabel.bounds.height, width: versionLabel.bounds.width, height: versionLabel.bounds.height)
        view.addSubview(versionLabel)
        
        payGemBtn.addBtnClickAction(target: self, action: #selector(showPayDialog))
        
    }
    
    /// 显示邀请界面
    @objc func showInviteDialog() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        inviteDialog.createView()
//        inviteDialog.show2(mainController: self)
    }
    
    /// 显示我的礼物
    @objc func showMyGift() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        let mailingListVC = MailingListViewController()
        self.navigationController?.pushViewController(mailingListVC, animated: true)
    }
    
    func showFastLogin() -> () {
        fastLoginDialog.createView()
//        fastLoginDialog.show2(mainViewController: self)
    }
    
    
    /// 显示签到的dialog
    @objc func showCheckInDialog() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        checkInDialog.createView()
        checkInDialog.initCheckIn7DayView()
        checkInDialog.show2(mainViewController: self)
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
//        let payViewController = PayViewController()
//        self.navigationController?.pushViewController(payViewController, animated: true)
        payGemDialog.createView()
        payGemDialog.show2(mainViewController: self)
    }
    
    // 点击展开隐藏设置按钮
    @objc fileprivate func settingsClick() -> () {
        if settingsGroupView.isHidden {
            settingsGroupView.isHidden = false
        }else {
            settingsGroupView.isHidden = true
        }
    }
    
    // 装载弹出的设置按钮
    func setupSettings(testImage:UIImageView) {
        
        let testUserIconImage = UIImageView(image: UIImage(named: "daeva_profile"))
        _ = UIImageView(image: UIImage(named: "Info-icon"))
        
        let settingsY = UIScreen.main.bounds.height - (80 - testImage.bounds.height) - 250 - 14
        let settingsWidth = testImage.bounds.width - 10
        
        settingsGroupView = UIView(frame: CGRect(x: self.view.bounds.width - testImage.bounds.width - 5, y: settingsY, width: settingsWidth, height: 250))
        settingsGroupView.layer.cornerRadius = 20
        settingsGroupView.layer.masksToBounds = true
        settingsGroupView.backgroundColor = UIColor(red: 99/255.0, green: 168/255.0, blue: 205/255.0, alpha: 1)
        view.addSubview(settingsGroupView)
        
        /// 用户中心
        let userIcon = UIButton(type: .custom)
        userIcon.frame = CGRect(x: settingsWidth/2-testUserIconImage.bounds.width/2, y: 10, width: 0, height: 0)
        userIcon.setBackgroundImage(UIImage(named: "daeva_profile"), for: .normal)
        userIcon.sizeToFit()
        settingsGroupView.addSubview(userIcon)
        userIcon.addTarget(self, action: #selector(showUserInfoDialog), for: .touchUpInside)
        
        /// 游戏记录
        let gameHistroy = UIButton(type: .custom)
        gameHistroy.setBackgroundImage(UIImage(named: "游戏记录"), for: .normal)
        gameHistroy.sizeToFit()
        settingsGroupView.addSubview(gameHistroy)
        
        gameHistroy.addTarget(self, action: #selector(showGameHistoryView), for: .touchUpInside)
        
        gameHistroy.snp.makeConstraints { (make) in
            make.top.equalTo(userIcon).offset(userIcon.bounds.height + 20)
            make.centerX.equalTo(settingsGroupView)
        }
        
        /// 代币记录
        let tokenHistroy = UIButton(type: .custom)
        tokenHistroy.setBackgroundImage(UIImage(named: "代币记录"), for: .normal)
        tokenHistroy.sizeToFit()
        settingsGroupView.addSubview(tokenHistroy)
        
        tokenHistroy.addTarget(self, action: #selector(showTokenHistoryView), for: .touchUpInside)
        
        tokenHistroy.snp.makeConstraints { (make) in
            make.top.equalTo(gameHistroy).offset(gameHistroy.bounds.height + 20)
            make.centerX.equalTo(settingsGroupView)
        }
        
        /// 帮助 （修改为积分商城）
        let infoIcon = UIImageView()
        infoIcon.image = UIImage(named: "Info-icon")
        infoIcon.sizeToFit()
        settingsGroupView.addSubview(infoIcon)
        
        infoIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(settingsGroupView)
            make.top.equalTo(tokenHistroy).offset(tokenHistroy.bounds.height + 20)
        }
        
        infoIcon.isUserInteractionEnabled = true
        
        let infoTap = UITapGestureRecognizer(target: self, action: #selector(showHelpDialog))
        infoTap.numberOfTapsRequired = 1
        infoIcon.addGestureRecognizer(infoTap)
        
        settingsGroupView.isHidden = true
    }
    
    /// 显示用户信息
    @objc func showUserInfoDialog() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        let userCenterVC = UserCenterViewController()
        self.navigationController?.pushViewController(userCenterVC, animated: true)
    }
    
    @objc func showHelpDialog() -> () {
        helpDialog.createView()
        helpDialog.show()
    }
    
    @objc func showGameHistoryView(){
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        let gameHistoryVC = GameHistoryViewController()
        self.navigationController?.pushViewController(gameHistoryVC, animated: true)
    }
    
    @objc func showTokenHistoryView(){
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        let tokenHistoryVC = TokenHistoryViewController()
        self.navigationController?.pushViewController(tokenHistoryVC, animated: true)
    }
    
}

extension MainViewController{
    
    /// 来到首页的时候，读取用户信息
    func getsUserInfo() -> () {
        if Constants.User.USER_ID == "" {
            payGemBtn.actionLabel.text = "0"
            return
        }
        
        if isShowADV == false {
            return
        }
        
        UserTools.getUserInfo(callback: { [weak self] in
            if self?.payGemBtn != nil {
                self?.payGemBtn.actionLabel.text = String(Constants.User.diamondsCount)
            }
        })
    }
    
    /// 清除钻石数量
    func clearGemNumber() -> () {
        payGemBtn.actionLabel.text = "0"
    }
    
}

extension MainViewController{
    
    /// 获取版本号，来判断显不显示支付
    func getAppReleaseVersion() -> () {
        if Constants.User.USER_ID == "" {
            return
        }
        Alamofire.request(Constants.Network.GET_SYS_INFO_VERSION, method: .post, parameters: NetWorkUtils.createBaseParams()).responseJSON { (response) in
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(data: response.data!)
                let infoDictionary = Bundle.main.infoDictionary!
                if let buildVersion = (infoDictionary["CFBundleVersion"] as? NSString)?.doubleValue {
                    if json["data"].doubleValue >= buildVersion {
                        print("正式")
                        self.payGemBtn.isHidden = false
                    }else{
                        print("提审")
                    }
                }
            }
        }
    }
}

// MARK: - 获取开屏页广告
extension MainViewController {
    
    func getOpenAdv() -> () {
        Alamofire.request(Constants.Network.Machine.GET_OPEN_ADV).responseJSON { (dataResponse) in
            if NetWorkUtils.checkReponse(response: dataResponse) {
                let json = JSON(data: dataResponse.data!)
                if json["data"].arrayValue.count > 0 {
                    SplashView.updateSplashData(imgUrl: json["data"].arrayValue[0]["advertiseBigImg"].stringValue, actUrl: json["data"].arrayValue[0]["scheme"].stringValue, shareTitle: json["data"].arrayValue[0]["shareTitle"].stringValue, shareInfo: json["data"].arrayValue[0]["shareSubtitle"].stringValue, shareImage: json["data"].arrayValue[0]["shareImg"].stringValue, urlType: json["data"].arrayValue[0]["redirectType"].intValue, title:json["data"].arrayValue[0]["name"].stringValue )
                }else{
                    UserDefaults.standard.removeObject(forKey: SplashView.IMG_URL)
                    UserDefaults.standard.removeObject(forKey: SplashView.ACT_URL)
                }
            }
        }
    }
    
}

/// 刷新列表状态
extension MainViewController{
    
    func refreshMainViewControllerList() -> () {
        if isNotAllowedListStatus == true || mainListData.count <= 0 {
            return
        }
        
        var params = NetWorkUtils.createBaseParams()
        var deviceids = ""
        for i in 0...mainListData.count - 1 {
            if i == mainListData.count - 1 {
                deviceids = deviceids + mainListData[i]["deviceId"].stringValue
            }else{
                deviceids = deviceids + mainListData[i]["deviceId"].stringValue + ","
            }
        }
        params["deviceids"] = deviceids
        
        Alamofire.request(Constants.Network.REFRESH_LIST_STATUS, method: .post, parameters: params).responseJSON { (dataResponse) in
            if NetWorkUtils.checkReponse(response: dataResponse) && !self.isNotAllowedListStatus {
                let json = JSON(data: dataResponse.data!)
                DispatchQueue.main.async {[weak self] in
                    if json["data"]["content"].arrayValue.count > 0 {
                        self?.mainListData.removeAll()
                        
                        if !(self?.isNotAllowedListStatus)! {
                            self?.mainListData = (self?.mainListData)! + json["data"]["content"].arrayValue
                            
                            UIView.performWithoutAnimation {[weak self] in
                                self?.dataList.reloadData()
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: { [weak self] in
                self?.refreshMainViewControllerList()
            })
        }
    }
}


























