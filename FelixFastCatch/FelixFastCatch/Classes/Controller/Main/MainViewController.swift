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

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.white
        
        setupUI()
    }

    
    /// 初始化
    func setupUI() -> () {
        createBannerView()
        
        createDataList()
    }
    
    /// banner images
    fileprivate lazy var bannerView:UIScrollView = UIScrollView()

    // banner 指示器
    fileprivate lazy var pageControl:UIPageControl = UIPageControl()
    
    // 数据列表
    fileprivate var dataList:UICollectionView!
    
    // 边距
    fileprivate let dataListPadding:CGFloat = 8
}



// MARK: - Banner Images
extension MainViewController:UIScrollViewDelegate{
    
    /// 创建banner的view
    func createBannerView() -> () {
        //设置banner图view的属性
        bannerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: getBannerHeight())
        bannerView.contentSize = CGSize(width: CGFloat(4) * self.view.bounds.width, height: getBannerHeight() - UIApplication.shared.statusBarFrame.height)
        bannerView.backgroundColor = UIColor.red
        bannerView.bounces = false
        bannerView.isPagingEnabled = true
        bannerView.showsHorizontalScrollIndicator = false
        bannerView.showsVerticalScrollIndicator = false
        view.addSubview(bannerView)
        
        //循环增加图片到scrollview当中
        for i in 0..<4 {
            let iv = UIImageView(image: UIImage(named: "test_banner.jpg"))
            iv.frame = CGRect(x: CGFloat(i) * bannerView.bounds.width, y: -UIApplication.shared.statusBarFrame.height, width: bannerView.bounds.width, height:bannerView.bounds.height)
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
        pageControl.frame = CGRect(x: self.view.bounds.width/2 - pageControl.bounds.width/2, y: bannerView.bounds.height - pageControl.bounds.height - 5, width: pageControl.bounds.width, height: pageControl.bounds.height)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5)
        pageControl.currentPage = page
    }
    
    /// 获取banner图的高度
    ///
    /// - Returns: banner图的高度是整体view的高的20%
    func getBannerHeight() -> CGFloat {
        return UIScreen.main.bounds.height * 0.25
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
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: (CGFloat(UIScreen.main.bounds.width) - dataListPadding*2)/2 - 5, height: 200)
        
        dataList = UICollectionView(frame: CGRect(x: 0, y: bannerView.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height - bannerView.bounds.height), collectionViewLayout: layout)
        dataList.backgroundColor = UIColor.white
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
        
        return cell!
    }

}







































