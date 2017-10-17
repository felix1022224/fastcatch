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
    
//    fileprivate var splitMachineList:[String: ]
    
    fileprivate var isShowADV = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        backgroundImage.image = UIImage(named: "main_background")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(backgroundImage)
        
        setupUI()
        
//        SplashView.updateSplashData(imgUrl: "http://img0.zgtuku.com/images/front/v/d3/59/235563250418.jpg", actUrl: "http://www.baidu.com")
//        SplashView.simpleShowSplashView()
        
        getOpenAdv()
    }

    override func viewWillAppear(_ animated: Bool) {
        if isShowADV {
            isShowADV = true
            return
        }
        SplashView.showSplashView(duration: 5, defaultImage: UIImage(named: "Launchplaceholder"), tapSplashImageBlock: { (resultStr) in
            if let url = URL(string: resultStr!) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],completionHandler: {(success) in })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }) { (isDiss) in
            print("diss\(isDiss)")
            self.isShowADV = true
            
            if Constants.User.USER_ID == "" {
                //            fastLoginDialog.createView()
                //            fastLoginDialog.show()
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
        
        /// 我的礼物
//        myGift = MyGiftDialog(frame: UIScreen.main.bounds)
        
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
    }
}

// MARK: - Banner Images
extension MainViewController:UIScrollViewDelegate{
    
    /// 创建banner的view
    func createBannerView() -> () {
        //设置banner图view的属性
        bannerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: getBannerHeight())
        bannerView.contentSize = CGSize(width: self.view.bounds.width, height: getBannerHeight())
        bannerView.backgroundColor = UIColor.white
        bannerView.bounces = false
        bannerView.isPagingEnabled = true
        bannerView.showsHorizontalScrollIndicator = false
        bannerView.showsVerticalScrollIndicator = false
        view.addSubview(bannerView)

        // 设置代理
        bannerView.delegate = self
        
        view.addSubview(pageControl)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if bannerViewIsTouch {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = page
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
    }
    
    /// 获取banner图的高度
    ///
    /// - Returns: banner图的高度是整体view的高的20%
    func getBannerHeight() -> CGFloat {
        return UIScreen.main.bounds.width * 0.45 - 1
    }
    
    //创建轮播图定时器
    func creatTimer() {
        
        print("createTime")
        
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        timer =  Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.timerManager), userInfo: nil, repeats: true)
        
        //这句话实现多线程，如果你的ScrollView是作为TableView的headerView的话，在拖动tableView的时候让轮播图仍然能轮播就需要用到这句话
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        bannerView.delaysContentTouches = false
        bannerView.touchBeganFunc = {[weak self] in
            if self?.timer != nil {
                self?.timer.invalidate()
                self?.timer = nil
            }
            self?.bannerViewIsTouch = true
        }
        
        bannerView.touchEndFunc = {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self?.creatTimer()
                self?.bannerViewIsTouch = false
            })
        }
        
    }
    
    //创建定时器管理者
    @objc func timerManager() {
        let contentOffsetX = self.bannerView.contentOffset.x + self.view.frame.size.width
        let count = CGFloat(mainBannersData.count) - 1
        
        if contentOffsetX > self.view.frame.size.width * CGFloat(count) {
            // 当前视图显示的是第三个的时候，设置bottomView的偏移量为0
            self.bannerView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        }else{
            self.bannerView.setContentOffset(CGPoint(x:contentOffsetX,y:0), animated: true)
        }
    }
    
    func setupImages() -> () {
        
        print("setupImages")
        
        //循环增加图片到scrollview当中
        for i:Int in 0..<mainBannersData.count{
            let iv = UIImageView()
            iv.frame = CGRect(x: CGFloat(i) * self.view.bounds.width, y: 0, width: self.view.bounds.width, height: getBannerHeight() + 1)
            iv.kf.setImage(with: URL(string: mainBannersData[i]["bannerBigImg"].string!))
            bannerView.addSubview(iv)
            iv.tag = i
            /////设置允许交互属性
            iv.isUserInteractionEnabled = true
            
            /////添加tapGuestureRecognizer手势
            let tapGR = UITapGestureRecognizer(target: self, action:#selector(bannerTap(sender:)))
            iv.addGestureRecognizer(tapGR)
        }
        
        bannerView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(mainBannersData.count), height: getBannerHeight())
        
        // 设置指示器的属性
        pageControl.numberOfPages = mainBannersData.count
        pageControl.backgroundColor = UIColor.clear
        pageControl.currentPage = 0
        pageControl.sizeToFit()
        pageControl.currentPageIndicatorTintColor = UIColor.yellow
        pageControl.pageIndicatorTintColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.8)
        
        // 设置指示器的约束
        pageControl.frame = CGRect(x: self.view.bounds.width/2 - pageControl.bounds.width/2, y: bannerView.bounds.height - pageControl.bounds.height, width: pageControl.bounds.width, height: pageControl.bounds.height)
        
        if mainBannersData.count <= 1 {
            return
        }
        creatTimer()
    }
    
    @objc func bannerTap(sender:UITapGestureRecognizer) -> () {
        if self.mainBannersData[(sender.view?.tag)!]["redirectType"].intValue == 1 {
            let link = self.mainBannersData[(sender.view?.tag)!]["scheme"].stringValue
            // 跳转到网页
            if link == "" {
                return
            }
            let webVC = WebViewController()
            webVC.mainVC = self
            webVC.link = link
            webVC.actionTitle = self.mainBannersData[(sender.view?.tag)!]["title"].stringValue
            self.navigationController?.pushViewController(webVC, animated: true)
        }else if self.mainBannersData[(sender.view?.tag)!]["redirectType"].intValue == 2 {
            let link = self.mainBannersData[(sender.view?.tag)!]["scheme"].intValue
            if link == -1 {
                showPayDialog()
                return
            }else{
                itemClick(index: link)
            }
        }
    }
    
}

// MARK: - 从网络获取banner图数据
extension MainViewController{
    
    /// 获取banner图的数据列表
    fileprivate func getBannerList(){
        Alamofire.request(Constants.Network.MAIN_BANNER_LIST, method: .post, parameters: NetWorkUtils.createBaseParams()).responseJSON { (response) in
            if response.error == nil {
                print("bannerList:\(response.result.value!)")
                self.mainBannersData.removeAll()
                
                let jsonObject = JSON(response.data!)
                self.mainBannersData = jsonObject["data"].arrayValue
                
                self.setupImages()
                
            }else{
                print("error:\(String(describing: response.error))")
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
        
//        let main = UIScreen.main.bounds
        // 設置 header 及 footer 的尺寸
//        layout.footerReferenceSize = CGSize(width: CGFloat(4) * main.width, height: 90)
        
        // item的宽度
//        let itemWidth = (CGFloat(UIScreen.main.bounds.width) - dataListPadding*2)/2 - 5
        
        // 設置每個 cell 的尺寸
//        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.3)
        
        dataList = UICollectionView(frame: CGRect(x: 0, y: bannerView.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height - bannerView.bounds.height), collectionViewLayout: layout)
        dataList.backgroundColor = UIColor.clear
        
        self.dataList.delegate = self
        self.dataList.dataSource = self
        
        view.addSubview(dataList)
        
        dataList.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        dataList.register(MainADVCell.self, forCellWithReuseIdentifier: "AdvCell")
        dataList.register(MainFooterCell.self, forCellWithReuseIdentifier: "FooterCell")
//        dataList.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
//        dataList.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        
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
//                print("index:\(advList[(indexPath.section - 1)/2]["sequence"].intValue)")
                itemData = mainListData[indexPath.row + advList[indexPath.section/2-1]["sequence"].intValue]
                cell?.titleLabel.text = itemData["award"]["title"].string!
            }
            
            cell?.playBtn.tag = indexPath.row
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
                
//                advCell?.advImage.tag = (indexPath.section-1)/2
//
//                advCell?.advImage.isUserInteractionEnabled = true
//                let advTouch = UITapGestureRecognizer(target: self, action: #selector(advItemClick(itemImage:)))
//                advCell?.advImage.addGestureRecognizer(advTouch)
                
                return advCell!
            }
        }

        return cell!
    }
    
//    /// 点击广告
//    @objc func advItemClick(itemImage:UIImageView) -> () {
//        print("advList:\(advList[itemImage.tag])")
//        if advList[itemImage.tag]["redirectType"].intValue == 1 {
//            let link = advList[itemImage.tag]["scheme"].stringValue
//            // 跳转到网页
//            if link == "" {
//                return
//            }
//            let webVC = WebViewController()
//            webVC.link = link
//            webVC.actionTitle = advList[itemImage.tag]["name"].stringValue
//            present(webVC, animated: true, completion: nil)
//        }else if advList[itemImage.tag]["redirectType"].intValue == 2 {
//            let link = advList[itemImage.tag]["scheme"].intValue
//            if link == -1 {
//                showPayDialog()
//                return
//            }else{
//                itemClick(index: link)
//            }
//        }
//    }
    
    /// 点击广告
    func advItemClick(item:JSON) -> () {
        if item["redirectType"].intValue == 1 {
            let link = item["scheme"].stringValue
            // 跳转到网页
            if link == "" {
                return
            }
            let webVC = WebViewController()
            webVC.mainVC = self
            webVC.link = link
            webVC.actionTitle = item["name"].stringValue
//            present(webVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(webVC, animated: true)
        }else if item["redirectType"].intValue == 2 {
            let link = item["scheme"].intValue
            if link == -1 {
                showPayDialog()
                return
            }else{
                itemClick(index: link)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var footer = UICollectionReusableView()
        
        if kind == UICollectionElementKindSectionFooter {
            footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
            footer.backgroundColor = UIColor.red
            if indexPath.section == advList.count * 2 + 1 {
                footer.isHidden = false
            }else{
                footer.isHidden = true
            }
        }
        
        return footer
    }
    
    func loadMore() -> () {
//        if isLoadingMore == false {
//            isLoadingMore = true
//            getMainListData()
//        }
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
        
        let playView = PlayViewController()
        playView.deviceId = mainListData[sender.tag]["deviceId"].stringValue
        playView.darwCount = mainListData[sender.tag]["darwCount"].intValue
        
        playView.needLogin = { [weak self] in
            self?.fastLoginDialog.createView()
            self?.fastLoginDialog.show()
        }
        
        playView.mainVC = self
        
        playView.bottomAwardCardImagePath = mainListData[sender.tag]["award"]["img"].stringValue
        playView.bootomAwardDescription = mainListData[sender.tag]["award"]["description"].stringValue
        playView.bottomAwardTitle = mainListData[sender.tag]["award"]["title"].stringValue
        
        playView.bootomBannerCardImagePath = mainListData[sender.tag]["activity"]["bannerSmallImg"].stringValue
        playView.bottomBannerCardScheme = mainListData[sender.tag]["activity"]["scheme"].stringValue
        
        navigationController?.pushViewController(playView, animated: true)
        
    }
    
    func itemClick(index:Int) -> () {
        if !checkDeviceStatus(status: mainListData[index]["status"].intValue) {
            return
        }
        
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
        
        navigationController?.pushViewController(playView, animated: true)
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
        params["size"] = "100"
        params["page"] = String(page)
        
        Alamofire.request(Constants.Network.MAIN_LIST, method: .post, parameters: params).responseJSON { (response) in
//            print("main_list:\(String(describing: response.result.value))")
            self.isLoadingMore = false
            if response.error == nil {
                let jsonObject = JSON(response.data!)
                
                if jsonObject["data"]["content"].arrayValue.count <= 0 {
                    return
                }
                
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
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: { [weak self] in
                self?.page = 0
                self?.isRefresh = true
                self?.isLoadingMainData = false
                self?.getMainListData()
            })
            
            SVProgressHUD.dismiss()
        }
        
        if mainBannersData.count <= 0 {
            getBannerList()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [weak self] in
            self?.getsUserInfo()
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
        inviteDialog.show2(mainController: self)
    }
    
    /// 显示我的礼物
    @objc func showMyGift() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
//        myGift.createView()
//        myGift.show()
        let mailingListVC = MailingListViewController()
        self.navigationController?.pushViewController(mailingListVC, animated: true)
    }
    
    func showFastLogin() -> () {
        fastLoginDialog.createView()
        fastLoginDialog.show2(mainViewController: self)
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
//        if WeChatShared.isInstall() == false {
//            ToastUtils.showErrorToast(msg: "充值支付出错，您还没有安装微信")
//            return
//        }
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
        let testInfoIconImage = UIImageView(image: UIImage(named: "Info-icon"))
        
        
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
        
        /// 帮助
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
//        userInfoDialog.createView()
//        userInfoDialog.show2(mainViewController: self)
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
//            print("versionValue:\(response.result.value!)")
            if NetWorkUtils.checkReponse(response: response) {
                let json = JSON(data: response.data!)
                let infoDictionary = Bundle.main.infoDictionary!
                if let buildVersion = (infoDictionary["CFBundleVersion"] as? NSString)?.doubleValue {
//                    print("buildVersion:\(buildVersion)")
                    if json["data"].doubleValue >= buildVersion {
                        print("正式")
                        self.payGemBtn.isHidden = false
//                        Constants.isShowPay = true
                    }else{
                        print("提审")
                        
//                        self.payGemBtn.isHidden = true
//                        Constants.isShowPay = false
                    }
                }else {
//                    self.payGemBtn.isHidden = true
//                    Constants.isShowPay = false
                }
            }else{
                /// 发生异常
//                self.payGemBtn.isHidden = true
//                Constants.isShowPay = false
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
                    SplashView.updateSplashData(imgUrl: json["data"].arrayValue[0]["advertiseBigImg"].stringValue, actUrl: json["data"].arrayValue[0]["scheme"].stringValue)
                }else{
                    UserDefaults.standard.removeObject(forKey: SplashView.IMG_URL)
                    UserDefaults.standard.removeObject(forKey: SplashView.ACT_URL)
                }
            }
        }
    }
    
}






























