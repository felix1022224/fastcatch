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
    
    /// 签到界面
    fileprivate var checkInDialog:CheckInDialog!
    
    /// 邀请界面
    fileprivate var inviteDialog:InviteDialog!
    
    /// 分享战绩
    fileprivate var showOffRecordDialog:ShowOffRecordDialog!
    
    /// 钻石btn
    fileprivate var payGemBtn:MainFloatMenu!
    
    /// 是否正在加载更多
    fileprivate var isLoadingMore = false
    
    /// 帮助的dialog
    fileprivate var helpDialog:HelpDialog!
    
    /// 版本号显示
    fileprivate var versionLabel:UILabel!
    
    let socket = SocketIOClient(socketURL: URL(string: "http://192.168.0.186:8080")!, config: [.log(true), .compress])
    
    /// 是否正在加载主页的数据
    fileprivate var isLoadingMainData = false
    
    /// banner的view是否触摸中
    fileprivate var bannerViewIsTouch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.safeAreaLayoutGuide
        
        self.navigationController?.navigationBar.isHidden = true
        
        backgroundImage.image = UIImage(named: "main_background")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(backgroundImage)
        
        setupUI()
        
//        socket.on(clientEvent: .connect) {data, ack in
//            print("socket connected")
//            self.socket.emit("chatevent", "12333")
//        }
//        
//        socket.on(clientEvent: .disconnect) { (data, ack) in
//            print("disconnect")
//        }
//        
//        socket.reconnects = true
//        
//        socket.connect()
        
//        let webVC = WebViewController()
//        webVC.link = "http://www.baidu.com"
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { 
//            self.present(webVC, animated: true, completion: nil)
//        }
        
        
        // 开启内购检测
//        SKPaymentQueue.default().add(self)
        
        /**
         *
         */
//        let familyNames = UIFont.familyNames;
//        for item in familyNames{
//            let fontNames = UIFont.fontNames(forFamilyName: item)
//            for item2 in fontNames{
//                print( "\tFont: \(item2) \n");
//            }
//        }
        
//        if checkPay() {
//            //请求内购商品
//            reuqestProductData(type: "com.meidaojia.secondcatch.b01")
//        }
        
    }
    
//    func checkPay() -> Bool {
//        if(SKPaymentQueue.canMakePayments()){
//            return true
//        }
//        else{
//            print("请允许付费")
//            return false
//        }
//    }
//    
//    private func reuqestProductData(type: String) {
//        let product = [type]
//        let set = NSSet(array: product as [AnyObject])
//        let request = SKProductsRequest(productIdentifiers: set as! Set<String>)
//        request.delegate = self
//        request.start()
//    }
//    
//    // 监听购买结果
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        
//        for tran in transactions {
//            // print(tran.error?.description)
//            
//            switch tran.transactionState {
//            case .purchased:
//                print("购买成功")
//                print("tran:\(tran)")
//                SKPaymentQueue.default().finishTransaction(tran)
//                
//            case .purchasing:
//                print("用户正在购买")
//                
//            case .restored:
//                print("已经购买过商品")
//                
//            case .failed:
//                SKPaymentQueue.default().finishTransaction(tran)
//                print("失败:\(tran.error.debugDescription)")
//                
//            default:
//                break
//            }
//        }
//    }
//    
//    // 收到产品返回的信息
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        if response.products.count == 0 {
//            print("没有商品")
//        }
//        var prod: SKProduct?
//        for pro in response.products {
//            print("------------------")
//            print(pro.localizedDescription)
//            print(pro.localizedTitle)
//            print(pro.price)
//            print(pro.productIdentifier)
//            print("------------------")
//            if pro.productIdentifier == "com.meidaojia.secondcatch.b01" {
//                prod = pro
//            }
//        }
//        // 发送购买请求
//        if let produ = prod {
//            let payment = SKPayment(product: produ)
//            SKPaymentQueue.default().add(payment)
//        }
//    }

    /// 在加载显示完首页的viewcontroller之后，需要调用该方法来成功获取系统的window
    func loadDialogToWindow() -> () {
        fastLoginDialog = FastLoginDialog(frame: UIScreen.main.bounds)
        
        if Constants.User.USER_ID == "" {
            fastLoginDialog.createView()
            fastLoginDialog.show()
        }else {
            getsUserInfo()
        }
        
        /// 购买钻石的dialog
        payGemDialog = PayListDialog(frame: UIScreen.main.bounds)
        
        /// 用户信息
        userInfoDialog = UserInfoDialog(frame: UIScreen.main.bounds)
        
        /// 我的礼物
        myGift = MyGiftDialog(frame: UIScreen.main.bounds)
        
        /// 签到
        checkInDialog = CheckInDialog(frame: UIScreen.main.bounds)
        
        /// 邀请
        inviteDialog = InviteDialog(frame: UIScreen.main.bounds)
        
        /// 分享战绩
        showOffRecordDialog = ShowOffRecordDialog(frame: UIScreen.main.bounds)
        
        /// 帮助
        helpDialog = HelpDialog(frame: UIScreen.main.bounds)
    }
    
    func test() -> () {
//        SVProgressHUD.setDefaultStyle(.dark)
//        SVProgressHUD.show(withStatus: "正在下单……")
        
//        var params = NetWorkUtils.createBaseParams()
//        params["rp"] = "1"
//   
//        Alamofire.request(Constants.Network.ALIPAY_URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
//            print("result:\(response.result.value)")
//            let json = JSON(response.result.value)
//            AlipaySDK.defaultService().payOrder(json["data"]["orderBody"].string, fromScheme: "alipay2017071707787463", callback: { (result) in
//                print("result:\(result)")
//            })
//        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        print("appear")
        //每次显示界面，调用一遍获取用户信息的接口
        if Constants.User.USER_ID != "" {
            getsUserInfo()
            if payGemBtn != nil {
                payGemBtn.actionLabel.text = String(Constants.User.diamondsCount)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
    func timerManager() {
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
    
    func bannerTap(sender:UITapGestureRecognizer) -> () {
        if self.mainBannersData[(sender.view?.tag)!]["redirectType"].intValue == 1 {
            let link = self.mainBannersData[(sender.view?.tag)!]["scheme"].stringValue
            // 跳转到网页
            if link == "" {
                return
            }
            let webVC = WebViewController()
            webVC.link = link
            webVC.actionTitle = self.mainBannersData[(sender.view?.tag)!]["title"].stringValue
            present(webVC, animated: true, completion: nil)
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
        layout.footerReferenceSize = CGSize(width: CGFloat(4) * main.width, height: 90)
        
        // item的宽度
        let itemWidth = (CGFloat(UIScreen.main.bounds.width) - dataListPadding*2)/2 - 5
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.3)
        
        dataList = UICollectionView(frame: CGRect(x: 0, y: bannerView.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height - bannerView.bounds.height), collectionViewLayout: layout)
        dataList.backgroundColor = UIColor.clear
        
        self.dataList.delegate = self
        self.dataList.dataSource = self
        
        view.addSubview(dataList)
        
        dataList.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        dataList.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        
        //下拉刷新相关设置
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header.lastUpdatedTimeLabel.isHidden = true // 隐藏时间
        //隐藏状态
        header.stateLabel.isHidden = true
//        dataList!.mj_header = header
        
        getMainListData()
    }
    
    //顶部下拉刷新
    func headerRefresh(){
        page = 0
        isRefresh = true
        getMainListData()
        //结束刷新
//        self.dataList!.mj_header.endRefreshing()
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
        
        cell?.playBtn.tag = indexPath.row
        cell?.addPlayBtnClick(target: self, action: #selector(showPlay))
        
//        cell?.productImage.kf.setImage(with: URL(string: itemData["img"].stringValue), placeholder: UIImage(named: "main_no_value"), options: nil, progressBlock: nil, completionHandler: nil)
        cell?.productImage.kf.setImage(with: URL(string: itemData["img"].stringValue))
        
        cell?.titleLabel.text = itemData["award"]["title"].string!
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
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var footer = UICollectionReusableView()
        
        if kind == UICollectionElementKindSectionFooter {
            footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
        }
        
        return footer
    }
    
    func loadMore() -> () {
        if isLoadingMore == false {
            isLoadingMore = true
            getMainListData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemClick(index: indexPath.row)
    }
    
    /// 显示游戏界面
    func showPlay(sender: UIButton) -> () {
        if Constants.User.USER_ID == "" {
            fastLoginDialog.createView()
            fastLoginDialog.show()
            return
        }
        
        if !checkDeviceStatus(status: mainListData[sender.tag]["status"].intValue) {
            return
        }
        
        let playView = PlayViewController()
        playView.deviceId = mainListData[sender.tag]["deviceId"].stringValue
        playView.darwCount = mainListData[sender.tag]["darwCount"].intValue
        playView.playSuccess = {[weak self] (deviceId) in
            self?.showShardRecordDialog(deviceId: deviceId)
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
        if Constants.User.USER_ID == "" {
            fastLoginDialog.createView()
            fastLoginDialog.show()
            return
        }
        
        if !checkDeviceStatus(status: mainListData[index]["status"].intValue) {
            return
        }
        
        let playView = PlayViewController()
        playView.deviceId = mainListData[index]["deviceId"].stringValue
        playView.darwCount = mainListData[index]["darwCount"].intValue
        playView.playSuccess = {[weak self] (deviceId) in
            self?.showShardRecordDialog(deviceId: deviceId)
        }
        
        playView.mainVC = self
        
        playView.bottomAwardCardImagePath = mainListData[index]["award"]["img"].stringValue
        playView.bootomAwardDescription = mainListData[index]["award"]["description"].stringValue
        playView.bottomAwardTitle = mainListData[index]["award"]["title"].stringValue
        
        playView.bootomBannerCardImagePath = mainListData[index]["activity"]["bannerSmallImg"].stringValue
        playView.bottomBannerCardScheme = mainListData[index]["activity"]["scheme"].stringValue

        
        navigationController?.pushViewController(playView, animated: true)
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
        
//        print("main_params:\(params)")
        
        Alamofire.request(Constants.Network.MAIN_LIST, method: .post, parameters: params).responseJSON { (response) in
//            print("result:\(String(describing: response.result.value))")
            self.isLoadingMore = false
            if response.error == nil {
                let jsonObject = JSON(response.data!)
                
                if jsonObject["data"]["content"].arrayValue.count <= 0 {
                    return
                }
                
                if self.isRefresh {
                    self.mainListData.removeAll()
                    self.isRefresh = false
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
                
//                self.isLoadingMainData = false
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
        
        let settingsBtn = MainFloatMenu(frame: CGRect(x: self.view.bounds.width - 10 - settingImage.bounds.width, y: UIScreen.main.bounds.height - 90, width: settingImage.bounds.width, height: settingImage.bounds.height), image: settingImage.image, actionTitle: "设置")
        view.addSubview(settingsBtn)  
        
        settingsBtn.addBtnClickAction(target: self, action: #selector(settingsClick))
        
        /// 邀请按钮
        let inviteBtn = MainFloatMenu(frame: CGRect(x: self.view.bounds.width - 10 * 2 - settingsBtn.bounds.width * 2, y: UIScreen.main.bounds.height - 90, width: settingsBtn.bounds.width, height: settingsBtn.bounds.height), image: UIImage(named: "Store-btn"), actionTitle: "邀请")
        view.addSubview(inviteBtn)
        
        inviteBtn.isHidden = true
        
        inviteBtn.addBtnClickAction(target: self, action: #selector(showInviteDialog))
        
        /// 签到
        let checkInBtn = MainFloatMenu(frame: CGRect(x: self.view.bounds.width - 10 * 2 - settingsBtn.bounds.width * 2, y: UIScreen.main.bounds.height - 90, width: settingsBtn.bounds.width, height: settingsBtn.bounds.height), image: UIImage(named: "Achievements-btn"), actionTitle: "签到")
        view.addSubview(checkInBtn)
        checkInBtn.addBtnClickAction(target: self, action: #selector(showCheckInDialog))
        
        /// 礼物按钮
        let giftBtn = MainFloatMenu(frame: CGRect(x: self.view.bounds.width - 10 * 3 - settingsBtn.bounds.width * 3, y: UIScreen.main.bounds.height - 90, width: settingsBtn.bounds.width, height: settingsBtn.bounds.height), image: UIImage(named: "Leaderboard-btn"), actionTitle: "奖品")
        view.addSubview(giftBtn)
        giftBtn.addBtnClickAction(target: self, action: #selector(showMyGift))
        
        /// 购买钻石按钮
        payGemBtn = MainFloatMenu(frame: CGRect(x: 10, y: UIScreen.main.bounds.height - 90, width: settingImage.bounds.width, height: 90), image: UIImage(named: "Plus-btn"), actionTitle: "0")
        view.addSubview(payGemBtn)
//        payGemBtn.isHidden = true
        
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
    func showInviteDialog() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        inviteDialog.createView()
        inviteDialog.show2(mainController: self)
    }
    
    /// 显示我的礼物
    func showMyGift() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        myGift.createView()
        myGift.show()
    }
    
    func showFastLogin() -> () {
        fastLoginDialog.createView()
        fastLoginDialog.show2(mainViewController: self)
    }
    
    
    /// 显示签到的dialog
    func showCheckInDialog() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        checkInDialog.createView()
        checkInDialog.initCheckIn7DayView()
        checkInDialog.show2(mainViewController: self)
    }
    
    /// 显示购买的dialog
    func showPayDialog() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        payGemDialog.createView()
        payGemDialog.show2(mainViewController: self)
    }
    
    /// 显示分享战绩的dialog
    func showShardRecordDialog(deviceId:String) -> () {
        showOffRecordDialog.createView()
        showOffRecordDialog.show2(deviceId: deviceId)
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
        
        
        let settingsY = UIScreen.main.bounds.height - (80 - testImage.bounds.height) - 150 - 14
        let settingsWidth = testImage.bounds.width - 10
        
        settingsGroupView = UIView(frame: CGRect(x: self.view.bounds.width - testImage.bounds.width - 5, y: settingsY, width: settingsWidth, height: 150))
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
        
        let infoIcon = UIImageView(frame: CGRect(x: settingsWidth/2-testInfoIconImage.bounds.width/2, y: 30 + testUserIconImage.bounds.height, width: 0, height: 0))
        infoIcon.image = UIImage(named: "Info-icon")
        infoIcon.sizeToFit()
        settingsGroupView.addSubview(infoIcon)
        
        infoIcon.isUserInteractionEnabled = true
        
        let infoTap = UITapGestureRecognizer(target: self, action: #selector(showHelpDialog))
        infoIcon.addGestureRecognizer(infoTap)
        
        settingsGroupView.isHidden = true
    }
    
    /// 显示用户信息
    func showUserInfoDialog() -> () {
        if Constants.User.USER_ID == "" {
            showFastLogin()
            return
        }
        userInfoDialog.createView()
        userInfoDialog.show2(mainViewController: self)
    }
    
    func showHelpDialog() -> () {
        helpDialog.createView()
        helpDialog.show()
    }
    
}

extension MainViewController{
    
    /// 来到首页的时候，读取用户信息
    func getsUserInfo() -> () {
        if Constants.User.USER_ID == "" {
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

































