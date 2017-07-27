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

class MainViewController: UIViewController {

    // 背景图
    fileprivate lazy var backgroundImage:UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        backgroundImage.image = UIImage(named: "main_background")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(backgroundImage)
        
        setupUI()
    
    }

    func test() -> () {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show(withStatus: "正在下单……")
        Alamofire.request(Constants.Network.WECHAT_PAY_URL + "?rp=1").responseJSON { (response) in
            
            if response.error != nil{
                print("error: \(String(describing: response.error))")
                ToastUtils.showErrorToast(msg: "网络错误，请稍后重试")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { 
                    SVProgressHUD.dismiss()
                })
                return
            }
            
            if let data = response.data {
                let json = JSON(data: data)
                WeChatShared.pay(to: "main", json["data"], resultHandle: { (result, identifier) in
                    print("result:\(result)")
                    print("indentifier:\(identifier)")
                })
            }
            SVProgressHUD.dismiss()
        }
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
}



// MARK: - Banner Images
extension MainViewController:UIScrollViewDelegate{
    
    /// 创建banner的view
    func createBannerView() -> () {
        //设置banner图view的属性
        bannerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: getBannerHeight())
        bannerView.contentSize = CGSize(width: CGFloat(4) * self.view.bounds.width, height: getBannerHeight())
        bannerView.backgroundColor = UIColor.red
        bannerView.bounces = false
        bannerView.isPagingEnabled = true
        bannerView.showsHorizontalScrollIndicator = false
        bannerView.showsVerticalScrollIndicator = false
        view.addSubview(bannerView)
        
        //循环增加图片到scrollview当中
        for i in 0..<4 {
            let iv = UIImageView(image: UIImage(named: "test_banner.jpg"))
            iv.frame = CGRect(x: CGFloat(i) * bannerView.bounds.width, y: 0, width: bannerView.bounds.width, height: getBannerHeight())
            bannerView.addSubview(iv)
            iv.contentMode = .scaleAspectFill
            iv.kf.setImage(with: URL(string: "http://img.zcool.cn/community/012719572881db6ac72538122486fd.jpg"))
        }

        // 设置指示器的属性
        pageControl.numberOfPages = 4
        pageControl.backgroundColor = UIColor.clear
        pageControl.currentPage = 0
        pageControl.sizeToFit()
        pageControl.currentPageIndicatorTintColor = UIColor.yellow
        pageControl.pageIndicatorTintColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.8)

        // 设置代理
        bannerView.delegate = self
        
        view.addSubview(pageControl)
        
        // 设置指示器的约束
        pageControl.frame = CGRect(x: self.view.bounds.width/2 - pageControl.bounds.width/2, y: bannerView.bounds.height - pageControl.bounds.height, width: pageControl.bounds.width, height: pageControl.bounds.height)
        
        creatTimer()
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
        if contentOffsetX > self.view.frame.size.width * 3 {
            // 当前视图显示的是第三个的时候，设置bottomView的偏移量为0
            self.bannerView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }else{
            self.bannerView.setContentOffset(CGPoint(x:contentOffsetX,y:0), animated: true)
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
        dataList.delegate = self
        dataList.dataSource = self
        view.addSubview(dataList)
        
        dataList.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as? MainCollectionViewCell
        
        cell?.addPlayBtnClick(target: self, action: #selector(showPlay))
        
        return cell!
    }
    
    
    /// 显示游戏界面
    func showPlay() -> () {
        navigationController?.pushViewController(PlayViewController(), animated: true)
    }

}


// MARK: - 按钮集合
extension MainViewController{
    
    // 创建首页的按钮
    func createMainBtns() -> () {
        let settingImage = UIImageView(image: UIImage(named: "Settings-btn"))
        let settingsBtn = MainFloatMenu(frame: CGRect(x: 10, y: UIScreen.main.bounds.height - 80, width: settingImage.bounds.width, height: 80), image: settingImage.image, actionTitle: "设置")
        view.addSubview(settingsBtn)
        
    }
    
}





































