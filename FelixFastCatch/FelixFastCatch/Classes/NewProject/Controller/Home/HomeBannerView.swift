//
//  HomeBannerView.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/18.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeBannerView: UIView {

    let title = UILabel()
    
    /// 存储tab的view
    var tabScrollView = UIScrollView()
    
    /// 存储banner的view
    var bannerView = UIScrollView()
    
    /// 数据
    var bannerDataSource:[JSON]!
    
    /// 左中右的图片view
    private var middleImage,middleImage2,leftImage,rightImage:UIImageView!
    
    // banner 指示器
    fileprivate lazy var pageControl:UIPageControl = UIPageControl()
    
    var scrollItemWidth:CGFloat = 0
    
    /// 指示的view
    var lineView = UIView()
    
    var tabviews = [HomeTabItemView]()
    
    /// 当前下标
    var currentIndex:Int = 0
    
    /// tab点击的回调
    var tabClickCallback:((_ index:Int)->())!
    
    //自动滚动计时器
    var autoScrollTimer:Timer?
    
    /// 签到按钮
    var checkInButton = UIButton.init(type: UIButtonType.custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let backgroundView = UIImageView()
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: (self.bounds.height - 90) * 0.6)
        backgroundView.image = UIImage(named: "首页顶部矩形")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        addSubview(backgroundView)
        
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        title.text = "秒抓 · 一秒抓起所有"
        title.textAlignment = .center
        title.sizeToFit()
        addSubview(title)
        
        checkInButton.setBackgroundImage(UIImage.init(named: "签到icon"), for: UIControlState.normal)
        checkInButton.sizeToFit()
        addSubview(checkInButton)
        
        if UIDevice.current.isX() {
            title.frame = CGRect(x: 0, y: 44, width: UIScreen.main.bounds.width, height: 40)
        }else{
            title.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 40)
        }
        
        checkInButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(title)
            make.right.equalTo(backgroundView).offset(-15)
        }
    }
    
    /// 创建banner view
    func createBannerView(jsonData:[JSON]) {
        let scrollBg = UIView()
        scrollBg.frame = CGRect(x: 0, y: title.frame.origin.y + 50, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.4)
        scrollBg.clipsToBounds = true
        addSubview(scrollBg)
        
        bannerView.backgroundColor = UIColor.clear
        bannerView.frame = CGRect(x: 14, y: 0, width: scrollBg.bounds.width - 28, height: UIScreen.main.bounds.width * 0.4)
        bannerView.showsHorizontalScrollIndicator = false
        bannerView.showsVerticalScrollIndicator = false
        bannerView.isPagingEnabled = true
        bannerView.clipsToBounds = true
        scrollBg.addSubview(bannerView)
        
        scrollItemWidth = (bannerView.bounds.width)
        
        bannerDataSource = jsonData
        
        bannerView.delegate = self

        initImageViews()
        
        
//        for i in 0..<bannerDataSource.count {
//            bannerView.addSubview(createBannerItem(imageUrl: bannerDataSource[i]["bannerBigImg"].stringValue, index: i))
//        }
        
        bannerView.contentSize = CGSize(width: (bannerView.bounds.width) * CGFloat(bannerDataSource.count), height: bannerView.bounds.height)
        
        configureAutoScrollTimer()
    }
    
    func configureAutoScrollTimer() {
        //设置一个定时器，每三秒钟滚动一次
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                               selector: #selector(letItScroll),
                                               userInfo: nil, repeats: true)
    }
    
    /// 计时器时间一到，滚动一张图片
    @objc func letItScroll(){
//        if currentIndex == bannerDataSource.count - 1 {
//            self.bannerView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: self.bannerView.bounds.width, height: self.bannerView.bounds.height), animated: true)
//        }else{
//            self.bannerView.scrollRectToVisible(CGRect.init(x: CGFloat(currentIndex + 1) * self.bannerView.bounds.width, y: 0, width: self.bannerView.bounds.width, height: self.bannerView.bounds.height), animated: true)
//        }
        
        let offset = CGPoint(x: CGFloat(2) * scrollItemWidth, y: 0)
        self.bannerView.setContentOffset(offset, animated: true)
    }
    
    /// 初始化图片的集合
    func initImageViews() -> () {
        let scrollItemHeight = UIScreen.main.bounds.width * 0.4
        
        self.leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollItemWidth, height: scrollItemHeight))
        self.middleImage = UIImageView(frame: CGRect(x: scrollItemWidth, y: 0, width: scrollItemWidth, height: scrollItemHeight))
        self.rightImage = UIImageView(frame: CGRect(x: scrollItemWidth * 2, y: 0, width: scrollItemWidth, height: scrollItemHeight))
        
        self.leftImage.layer.cornerRadius = 10
        self.middleImage.layer.cornerRadius = 10
        self.rightImage.layer.cornerRadius = 10
        
        self.leftImage.backgroundColor = UIColor.white
        self.middleImage.backgroundColor = UIColor.white
        self.rightImage.backgroundColor = UIColor.white
        
        self.leftImage.layer.masksToBounds = true
        self.middleImage.layer.masksToBounds = true
        self.rightImage.layer.masksToBounds = true
        
        self.bannerView.addSubview(leftImage)
        self.bannerView.addSubview(middleImage)
        self.bannerView.addSubview(rightImage)
        
        if bannerDataSource.count != 0 {
            resetImageSources()
        }
        
        // 设置指示器的属性
        pageControl.numberOfPages = bannerDataSource.count
        pageControl.backgroundColor = UIColor.clear
        pageControl.currentPage = 0
        pageControl.sizeToFit()
        
        pageControl.currentPageIndicatorTintColor = UIColor.yellow
        pageControl.pageIndicatorTintColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.8)
        
//        pageControl.setValue(UIImage.init(named: "其他页面圆点"), forKey: "_pageImage")
//        pageControl.setValue(UIImage.init(named: "当前页面圆点"), forKey: "_currentPageImage")
        
//        pageControl.currentPageIndicatorTintColor = UIColor.init(patternImage: UIImage.init(named: "当前页面圆点")!)
//        pageControl.pageIndicatorTintColor = UIColor.init(patternImage: UIImage.init(named: "其他页面圆点")!)
//        pageControl.pageIndicatorTintColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.8)
        
//        pageControl.frame = CGRect(x: self.bounds.width/2 - pageControl.bounds.width/2, y: self.bounds.height - 20, width: pageControl.bounds.width, height: pageControl.bounds.height)

        pageControl.frame = CGRect(x: UIScreen.main.bounds.width/2 - pageControl.bounds.width/2, y: title.frame.origin.y + 50 + bannerView.bounds.height - 30, width: pageControl.bounds.width, height: pageControl.bounds.height)
        
        self.addSubview(pageControl)
        
        bannerView.isUserInteractionEnabled = true
    }
    
    /// 重设图片集合
    func resetImageSources() {
        if currentIndex == 0 {
            /// 第一位
            self.leftImage.kf.setImage(with: URL(string: bannerDataSource.last!["bannerBigImg"].stringValue))
            self.middleImage.kf.setImage(with: URL(string: bannerDataSource.first!["bannerBigImg"].stringValue))
            let rightImageIndex = (self.bannerDataSource?.count)!>1 ? 1 : 0 //保护
            self.rightImage.kf.setImage(with: URL(string: bannerDataSource[rightImageIndex]["bannerBigImg"].stringValue))
        }else if currentIndex == self.bannerDataSource.count - 1 {
            /// 最后
            self.leftImage.kf.setImage(with: URL(string: bannerDataSource[currentIndex - 1]["bannerBigImg"].stringValue))
            self.middleImage.kf.setImage(with: URL(string: bannerDataSource.last!["bannerBigImg"].stringValue))
            self.rightImage.kf.setImage(with: URL(string: bannerDataSource.first!["bannerBigImg"].stringValue))
        }else{
            /// 中间
            self.leftImage.kf.setImage(with: URL(string: bannerDataSource[currentIndex - 1]["bannerBigImg"].stringValue))
            self.middleImage.kf.setImage(with: URL(string: bannerDataSource[currentIndex]["bannerBigImg"].stringValue))
            self.rightImage.kf.setImage(with: URL(string: bannerDataSource[currentIndex + 1]["bannerBigImg"].stringValue))
        }
    }
    
    
    /// 创建单个banner
    ///
    /// - Parameters:
    ///   - imageUrl: 图片地址
    ///   - index: item的下标
    /// - Returns: 单个banner的view
    func createBannerItem(imageUrl:String, index:Int) -> UIView {
        let itemView = UIView()
        let itemImageView = UIImageView()
        itemView.frame = CGRect.init(x: (index + 1) * 14 + Int(bannerView.bounds.width - 14) * index, y: 0, width: Int(bannerView.bounds.width - 14), height: Int(bannerView.bounds.height))
        itemImageView.frame = CGRect.init(x: 0, y: 0, width: itemView.bounds.width, height: itemView.bounds.height)
        itemImageView.kf.setImage(with: URL(string: imageUrl))
        itemView.layer.cornerRadius = 10
        itemView.layer.masksToBounds = true
        itemView.addSubview(itemImageView)
        return itemView
    }
    
    /// 创建tabs
    func createTabViews(jsonData:[JSON]) {
        tabScrollView.backgroundColor = UIColor.white
        tabScrollView.frame = CGRect(x: CGFloat(14), y: self.bounds.height - 90, width: UIScreen.main.bounds.width - 28, height: 90)
        tabScrollView.showsVerticalScrollIndicator = false
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.bounces = false
        addSubview(tabScrollView)
        
        for i in 0..<jsonData.count {
            let item = createTabItem(index: i, imageUrl: jsonData[i]["icon"].stringValue)
            item.tabTitle.text = jsonData[i]["title"].stringValue
            tabScrollView.addSubview(item)
            tabviews.append(item)
            item.tag = i
            item.tabClickCallback = { (index) in
                if self.tabClickCallback != nil {
                    self.tabClickCallback!(index)
                }
            }
            if i == 0 {
                item.tabTitle.textColor = UIColor.red
            }
        }
        
        tabScrollView.contentSize = CGSize(width: ((UIScreen.main.bounds.width - 28)/4) * CGFloat(jsonData.count), height: tabScrollView.bounds.height)
        
        createLineView()
    }
    
    func createLineView() {
        lineView.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width - 28)/10, height: 3)
        lineView.backgroundColor = UIColor.red
        lineView.layer.cornerRadius = 2
        lineView.layer.masksToBounds = true
        tabScrollView.addSubview(lineView)
        
        tabScrollView.isUserInteractionEnabled = true
        
        let lineViewY = tabScrollView.bounds.height - 8
        let itemWidth = (UIScreen.main.bounds.width - 28)/4
        
        lineView.frame.origin = CGPoint(x: itemWidth/2 - lineView.bounds.width/2, y: lineViewY)
    }
    
    /// 创建tab
    ///
    /// - Parameters:
    ///   - index: 下标
    ///   - imageUrl: 图片地址
    /// - Returns: 单独tabview
    func createTabItem(index:Int, imageUrl:String) -> HomeTabItemView {
        let itemWidth = (UIScreen.main.bounds.width - 28)/4
        let itemHeight = 90
        
        let homeTab = HomeTabItemView(frame: CGRect(x: CGFloat(Float(index) * Float(itemWidth)), y: CGFloat(0), width: itemWidth, height: CGFloat(itemHeight)))
        
        homeTab.createView(index: index, imageUrl: imageUrl)
        
        return homeTab
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeBannerView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        currentIndex = Int((scrollView.contentOffset.x - scrollView.bounds.width/2)/scrollView.bounds.width + 1)
        //获取当前偏移量
        let offset = bannerView.contentOffset.x

        if(self.bannerDataSource?.count != 0){

            //如果向左滑动（显示下一张）
            if(offset >= CGFloat(self.bannerView.bounds.width * 2)){
                //还原偏移量
                bannerView.contentOffset = CGPoint(x: self.bannerView.bounds.width, y: 0)
                //视图索引+1
                self.currentIndex = self.currentIndex + 1

                if self.currentIndex == self.bannerDataSource?.count {
                    self.currentIndex = 0
                }
            }

            //如果向右滑动（显示上一张）
            if(offset <= 0){
                //还原偏移量
                bannerView.contentOffset = CGPoint(x: self.bannerView.bounds.width, y: 0)
                //视图索引-1
                self.currentIndex = self.currentIndex - 1

                if self.currentIndex == -1 {
                    self.currentIndex = (self.bannerDataSource?.count)! - 1
                }
            }

            if self.bannerDataSource.count != 0 {
                //重新设置各个imageView的图片
                resetImageSources()
            }

            //设置页控制器当前页码
            self.pageControl.currentPage = self.currentIndex
        }
    }
    
    //手动拖拽滚动开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //使自动滚动计时器失效（防止用户手动移动图片的时候这边也在自动滚动）
        autoScrollTimer?.invalidate()
    }
    
    //手动拖拽滚动结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //重新启动自动滚动计时器
        configureAutoScrollTimer()
    }
    
}


