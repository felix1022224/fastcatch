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

class MainViewController: UIViewController {

    // 背景图
    fileprivate lazy var backgroundImage:UIImageView = UIImageView()
    
    /// banner images
    fileprivate lazy var bannerView:UIScrollView = UIScrollView()
    
    // banner 指示器
    fileprivate lazy var pageControl:UIPageControl = UIPageControl()
    
    // 数据列表
    fileprivate var dataList:UICollectionView!
    
    // 边距
    fileprivate let dataListPadding:CGFloat = 8
    
    // 计时器
    fileprivate var timer:Timer!
    
    // banner数据
    fileprivate var mainBannersData:[JSON]!
    
    // 首页列表的数据
    fileprivate lazy var mainListData:[JSON] = [JSON]()
    
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
    
    /// 我的礼物
    fileprivate var myGift:MyGiftDialog!
    
    // 设置按钮的集合view
    fileprivate var settingsGroupView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        backgroundImage.image = UIImage(named: "main_background")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(backgroundImage)
        
        setupUI()
    }

    /// 在加载显示完首页的viewcontroller之后，需要调用该方法来成功获取系统的window
    func loadDialogToWindow() -> () {
        fastLoginDialog = FastLoginDialog(frame: UIScreen.main.bounds)
        
        if Constants.User.USER_ID == "" {
            fastLoginDialog.createView()
            fastLoginDialog.show()
        }
        
        /// 购买钻石的dialog
        payGemDialog = PayListDialog(frame: UIScreen.main.bounds)
        
        /// 用户信息
        userInfoDialog = UserInfoDialog(frame: UIScreen.main.bounds)
        
        /// 我的礼物
        myGift = MyGiftDialog(frame: UIScreen.main.bounds)
        
    }
    
    func test() -> () {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show(withStatus: "正在下单……")
        
        var params = NetWorkUtils.createBaseParams()
        params["rp"] = "1"
        
        Alamofire.request(Constants.Network.ALIPAY_URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print("result:\(response.result.value)")
        }
//        Alamofire.request(Constants.Network.WECHAT_PAY_URL + "?rp=1").responseJSON { (response) in
//            
//            if response.error != nil{
//                print("error: \(String(describing: response.error))")
//                ToastUtils.showErrorToast(msg: "网络错误，请稍后重试")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { 
//                    SVProgressHUD.dismiss()
//                })
//                return
//            }
//            
//            if let data = response.data {
//                let json = JSON(data: data)
//                WeChatShared.pay(to: "main", json["data"], resultHandle: { (result, identifier) in
//                    print("result:\(result)")
//                    print("indentifier:\(identifier)")
//                })
//            }
//            SVProgressHUD.dismiss()
//        }
    }
    
    /// 初始化
    func setupUI() -> () {
        createBannerView()
        
        createDataList()
        
        createMainBtns()
    }
    
    override func removeFromParentViewController() {
        timer.invalidate()
        timer = nil
        super.removeFromParentViewController()
    }
}



// MARK: - Banner Images
extension MainViewController:UIScrollViewDelegate{
    
    /// 创建banner的view
    func createBannerView() -> () {
        //设置banner图view的属性
        bannerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: getBannerHeight())
        bannerView.contentSize = CGSize(width: CGFloat(4) * self.view.bounds.width, height: getBannerHeight())
        bannerView.backgroundColor = UIColor.gray
        bannerView.bounces = false
        bannerView.isPagingEnabled = true
        bannerView.showsHorizontalScrollIndicator = false
        bannerView.showsVerticalScrollIndicator = false
        view.addSubview(bannerView)

        // 设置代理
        bannerView.delegate = self
        
        view.addSubview(pageControl)
        
        // 设置指示器的约束
        pageControl.frame = CGRect(x: self.view.bounds.width/2 - pageControl.bounds.width/2, y: bannerView.bounds.height - pageControl.bounds.height, width: pageControl.bounds.width, height: pageControl.bounds.height)
        
        getBannerList()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5)
        pageControl.currentPage = page
    }
    
    /// 获取banner图的高度
    ///
    /// - Returns: banner图的高度是整体view的高的20%
    func getBannerHeight() -> CGFloat {
        return UIScreen.main.bounds.height * 0.22
    }
    
    //创建轮播图定时器
    func creatTimer() {
        timer =  Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.timerManager), userInfo: nil, repeats: true)
        
        //这句话实现多线程，如果你的ScrollView是作为TableView的headerView的话，在拖动tableView的时候让轮播图仍然能轮播就需要用到这句话
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        
    }
    
    //创建定时器管理者
    func timerManager() {
        let contentOffsetX = self.bannerView.contentOffset.x + self.view.frame.size.width
        let count = CGFloat(mainBannersData.count)
        
        if contentOffsetX > self.view.frame.size.width * CGFloat(count) {
            // 当前视图显示的是第三个的时候，设置bottomView的偏移量为0
            self.bannerView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }else{
            self.bannerView.setContentOffset(CGPoint(x:contentOffsetX,y:0), animated: true)
        }
    }
    
    func setupImages() -> () {
        //循环增加图片到scrollview当中
        for i:Int in 0..<mainBannersData.count{
            let iv = UIImageView()
            iv.frame = CGRect(x: CGFloat(i) * bannerView.bounds.width, y: 0, width: bannerView.bounds.width, height: getBannerHeight())
            bannerView.addSubview(iv)
            iv.contentMode = .scaleAspectFill
            iv.kf.setImage(with: URL(string: mainBannersData[i]["bannerBigImg"].string!))
        }
        
        // 设置指示器的属性
        pageControl.numberOfPages = mainBannersData.count
        pageControl.backgroundColor = UIColor.clear
        pageControl.currentPage = 0
        pageControl.sizeToFit()
        pageControl.currentPageIndicatorTintColor = UIColor.yellow
        pageControl.pageIndicatorTintColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.8)
        
        if mainBannersData.count <= 1 {
            return
        }
        creatTimer()
    }
    
}

// MARK: - 从网络获取banner图数据
extension MainViewController{
    
    /// 获取banner图的数据列表
    fileprivate func getBannerList(){
        Alamofire.request(Constants.Network.MAIN_BANNER_LIST, method: .post, parameters: NetWorkUtils.createBaseParams()).responseJSON { (response) in
            if response.error == nil {
                
                let jsonObject = JSON(response.data!)
                self.mainBannersData = jsonObject["data"].array
                
                self.setupImages()
                
            }else{
                print("error:\(String(describing: response.error))")
            }
        }
    }
    
}

// MARK: - 装载首页的列表数据
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{

    // 创建首页的数据列表
    func createDataList() -> () {
        
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(dataListPadding, dataListPadding, dataListPadding, dataListPadding);
        
        // 設置每一行的間距
        layout.minimumLineSpacing = dataListPadding + 1
        
        let main = UIScreen.main.bounds
        // 設置 header 及 footer 的尺寸
        layout.footerReferenceSize = CGSize(width: CGFloat(4) * main.width, height: 80)
        
        // item的宽度
        let itemWidth = (CGFloat(UIScreen.main.bounds.width) - dataListPadding*2)/2 - 5
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.3)
        
        dataList = UICollectionView(frame: CGRect(x: 0, y: bannerView.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height - bannerView.bounds.height), collectionViewLayout: layout)
        dataList.backgroundColor = UIColor.clear
        
        view.addSubview(dataList)
        
        dataList.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        
        //下拉刷新相关设置
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header.lastUpdatedTimeLabel.isHidden = true // 隐藏时间
        //隐藏状态
        header.stateLabel.isHidden = true
        dataList!.mj_header = header
        
        getMainListData()
    }
    
    //顶部下拉刷新
    func headerRefresh(){
        page = 0
        isRefresh = true
        getMainListData()
        //结束刷新
        self.dataList!.mj_header.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainListData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as? MainCollectionViewCell
        
        let itemData = mainListData[indexPath.row]
        
        cell?.playBtn.tag = Int(itemData["deviceId"].string!)!
        cell?.addPlayBtnClick(target: self, action: #selector(showPlay))
        
        cell?.productImage.kf.setImage(with: URL(string: itemData["activity"]["bannerBigImg"].string!))
        cell?.titleLabel.text = itemData["award"]["title"].string!
        cell?.gemNumberLabel.text = String(itemData["perDiamondsCount"].int!) + "钻"
        
        return cell!
    }
    
    
    /// 显示游戏界面
    func showPlay(sender: UIButton) -> () {
        if Constants.User.USER_ID == "" {
            fastLoginDialog.createView()
            fastLoginDialog.show()
            return
        }
        let playView = PlayViewController()
        playView.deviceId = String(sender.tag)
        navigationController?.pushViewController(playView, animated: true)
        
//        test()
    }

}


// MARK: - 从网络获取首页的网络数据
extension MainViewController{
    
    
    /// 获取首页的数据
    func getMainListData() -> () {
        var params = NetWorkUtils.createBaseParams()
        params["size"] = "10"
        params["page"] = String(page)
        
        Alamofire.request(Constants.Network.MAIN_LIST, method: .post, parameters: params).responseJSON { (response) in
            if response.error == nil {
                let jsonObject = JSON(response.data!)
                if self.isRefresh {
                    self.mainListData.removeAll()
                    self.isRefresh = false
                }
                self.mainListData = self.mainListData + jsonObject["data"]["content"].array!
                
                self.dataList.delegate = self
                self.dataList.dataSource = self
                self.dataList.reloadData()
                
//                print("result:\(jsonObject)")
                
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
        }
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
    func reLoadNetworkData() -> () {
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
        
        let settingsBtn = MainFloatMenu(frame: CGRect(x: 10, y: UIScreen.main.bounds.height - 80, width: settingImage.bounds.width, height: 80), image: settingImage.image, actionTitle: "设置")
        view.addSubview(settingsBtn)  
        
        settingsBtn.addBtnClickAction(target: self, action: #selector(settingsClick))
        
        /// 礼物按钮
        let giftBtn = MainFloatMenu(frame: CGRect(x: self.view.bounds.width - 10 - settingsBtn.bounds.width, y: UIScreen.main.bounds.height - 80, width: settingsBtn.bounds.width, height: settingsBtn.bounds.height), image: UIImage(named: "Leaderboard-btn"), actionTitle: "礼物")
        view.addSubview(giftBtn)
        giftBtn.addBtnClickAction(target: self, action: #selector(showMyGift))
        
        /// 购买钻石按钮
        let payGemBtn = MainFloatMenu(frame: CGRect(x: self.view.bounds.width - 10 - settingsBtn.bounds.width * 2, y: UIScreen.main.bounds.height - 80, width: settingsBtn.bounds.width, height: settingsBtn.bounds.height), image: UIImage(named: "Plus-btn"), actionTitle: "购钻")
        view.addSubview(payGemBtn)
        
        payGemBtn.addBtnClickAction(target: self, action: #selector(showPayDialog))
        
    }
    
    /// 显示我的礼物
    func showMyGift() -> () {
        myGift.createView()
        myGift.show()
    }
    
    func showFastLogin() -> () {
        fastLoginDialog.createView()
        fastLoginDialog.show()
    }
    
    /// 显示购买的dialog
    func showPayDialog() -> () {
        payGemDialog.createView()
        payGemDialog.show()
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
        
        
        let settingsY = UIScreen.main.bounds.height - (80 - testImage.bounds.height) - 150 - 10
        let settingsWidth = testImage.bounds.width - 10
        
        settingsGroupView = UIView(frame: CGRect(x: 15, y: settingsY, width: settingsWidth, height: 150))
        settingsGroupView.layer.cornerRadius = 25
        settingsGroupView.layer.masksToBounds = true
        settingsGroupView.backgroundColor = UIColor(red: 99/255.0, green: 168/255.0, blue: 205/255.0, alpha: 1)
        view.addSubview(settingsGroupView)
        
        let userIcon = UIButton(type: .custom)
        userIcon.frame = CGRect(x: settingsWidth/2-testUserIconImage.bounds.width/2, y: 10, width: 0, height: 0)
        userIcon.setBackgroundImage(UIImage(named: "daeva_profile"), for: .normal)
        userIcon.sizeToFit()
        settingsGroupView.addSubview(userIcon)
        userIcon.addTarget(self, action: #selector(showUserInfoDialog), for: .touchUpInside)
        
        let infoIcon = UIImageView(frame: CGRect(x: settingsWidth/2-testInfoIconImage.bounds.width/2, y: 20 + testUserIconImage.bounds.height, width: 0, height: 0))
        infoIcon.image = UIImage(named: "Info-icon")
        infoIcon.sizeToFit()
        settingsGroupView.addSubview(infoIcon)
        
        settingsGroupView.isHidden = true
    }
    
    /// 显示用户信息
    func showUserInfoDialog() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        userInfoDialog.createView()
        userInfoDialog.show()
    }
    
}



































