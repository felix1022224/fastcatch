//
//  CustomerBannerWidget.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/12/25.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

protocol BannerDelegate {
    /// 获取数据源
    func getBannerDataSource() -> [String]
    
    /// 点击一个banner
    func clickBannerItem(index:Int)
    
    /// 是否圆角显示
    func isRoundCorners() -> Bool
}

class CustomerBannerWidget: UIView, UIScrollViewDelegate , UIGestureRecognizerDelegate{

    /// 数据代理
    var delegate:BannerDelegate!
    
    /// 数据
    private var dataSource:[String]!
    
    /// 滑动的view
    private var scrollerView:UIScrollView!
    
    /// 当前下标
    var currentIndex:Int = 0
    
    /// 左中右的图片view
    private var middleImage,leftImage,rightImage:UIImageView!
    
    // banner 指示器
    fileprivate lazy var pageControl:UIPageControl = UIPageControl()
    
    let scrollItemWidth = UIScreen.main.bounds.width
    let scrollItemHeight = UIScreen.main.bounds.width * 0.45
    
    //自动滚动计时器
    var autoScrollTimer:Timer?
    
    init(frame: CGRect, delegate:BannerDelegate) {
        super.init(frame: frame)
        self.delegate = delegate
        setupUI()
    }
    
    /// 装载UI
    func setupUI() -> () {
        let topImage = UIImageView(image: UIImage(named: "首页顶部矩形"))
        topImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5)
        addSubview(topImage)
        
        dataSource = delegate.getBannerDataSource()
        
        initScrollerView()
        
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
        let offset = CGPoint(x: 2 * scrollItemWidth, y: 0)
        self.scrollerView?.setContentOffset(offset, animated: true)
    }
    
    /// 初始化scrollview
    func initScrollerView() -> () {
        self.scrollerView = UIScrollView()
        
        self.scrollerView.delegate = self
        
        // 圆角
        if delegate.isRoundCorners() {
            self.scrollerView.layer.cornerRadius = 10
        }
        
        self.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.6)
        self.scrollerView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: scrollItemWidth, height: scrollItemHeight)
        
//        self.scrollerView.center = self.center
        
        self.addSubview(self.scrollerView)
        
        self.scrollerView.contentSize = CGSize(width: scrollItemWidth * 3, height: scrollItemHeight)
        self.scrollerView.contentOffset = CGPoint(x: scrollItemWidth, y: 0)
        
        scrollerView.isPagingEnabled = true
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.showsVerticalScrollIndicator = false
        
        initImageViews()
    }
    
    /// 初始化图片的集合
    func initImageViews() -> () {
        self.leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollItemWidth, height: scrollItemHeight))
        self.middleImage = UIImageView(frame: CGRect(x: scrollItemWidth, y: 0, width: scrollItemWidth, height: scrollItemHeight))
        self.rightImage = UIImageView(frame: CGRect(x: scrollItemWidth * 2, y: 0, width: scrollItemWidth, height: scrollItemHeight))
        
        self.scrollerView.addSubview(leftImage)
        self.scrollerView.addSubview(middleImage)
        self.scrollerView.addSubview(rightImage)
        
        if dataSource.count != 0 {
            resetImageSources()
        }
        
        // 设置指示器的属性
        pageControl.numberOfPages = dataSource.count
        pageControl.backgroundColor = UIColor.clear
        pageControl.currentPage = 0
        pageControl.sizeToFit()
        pageControl.currentPageIndicatorTintColor = UIColor.yellow
        pageControl.pageIndicatorTintColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.8)
        
        pageControl.frame = CGRect(x: self.bounds.width/2 - pageControl.bounds.width/2, y: self.bounds.height - 20, width: pageControl.bounds.width, height: pageControl.bounds.height)
        
        self.addSubview(pageControl)
    }
    
    /// 重设图片集合
    func resetImageSources() {
        if currentIndex == 0 {
            /// 第一位
            self.leftImage.kf.setImage(with: URL(string: dataSource.last!))
            self.middleImage.kf.setImage(with: URL(string: dataSource.first!))
            let rightImageIndex = (self.dataSource?.count)!>1 ? 1 : 0 //保护
            self.rightImage.kf.setImage(with: URL(string: dataSource[rightImageIndex]))
        }else if currentIndex == self.dataSource.count - 1 {
            /// 最后
            self.leftImage.kf.setImage(with: URL(string: dataSource[currentIndex - 1]))
            self.middleImage.kf.setImage(with: URL(string: dataSource.last!))
            self.rightImage.kf.setImage(with: URL(string: dataSource.first!))
        }else{
            /// 中间
            self.leftImage.kf.setImage(with: URL(string: dataSource[currentIndex - 1]))
            self.middleImage.kf.setImage(with: URL(string: dataSource[currentIndex]))
            self.rightImage.kf.setImage(with: URL(string: dataSource[currentIndex + 1]))
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取当前偏移量
        let offset = scrollView.contentOffset.x
        
        if(self.dataSource?.count != 0){
            
            //如果向左滑动（显示下一张）
            if(offset >= self.scrollItemWidth * 2){
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollItemWidth, y: 0)
                //视图索引+1
                self.currentIndex = self.currentIndex + 1
                
                if self.currentIndex == self.dataSource?.count {
                    self.currentIndex = 0
                }
            }
            
            //如果向右滑动（显示上一张）
            if(offset <= 0){
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollItemWidth, y: 0)
                //视图索引-1
                self.currentIndex = self.currentIndex - 1
                
                if self.currentIndex == -1 {
                    self.currentIndex = (self.dataSource?.count)! - 1
                }
            }
            
            if self.dataSource.count != 0 {
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
    
    //重新加载数据
    func reloadData() {
        //索引重置
        self.currentIndex = 0
        //重新获取数据
        self.dataSource =  self.delegate.getBannerDataSource()
        //页控制器更新
        self.pageControl.numberOfPages = self.dataSource.count
        self.pageControl.currentPage = 0
        //如果banner个数少于等于1，隐藏指示器
        if self.dataSource.count <= 1 {
            self.pageControl.isHidden = true
        }else{
            self.pageControl.isHidden = false
        }
        //重新设置各个imageView的图片
        resetImageSources()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
