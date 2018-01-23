//
//  HomeTabItemView.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/18.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class HomeTabItemView: UIView{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /// tab image
    let tabImageView = UIImageView()
    
    /// tab label
    var tabTitle:UILabel!
    
    let clickView = UIView()
    
    var tabClickCallback:((_ index:Int)->())!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func createView(index:Int, imageUrl:String) {
        let itemWidth = (UIScreen.main.bounds.width)/4
        
        tabImageView.image = UIImage(named: "0币抓icon")
        tabImageView.frame = CGRect(x: itemWidth/2 - 30, y: 0, width: 55, height: 55)
        tabImageView.tag = index
        addSubview(tabImageView)
        
        tabTitle = UILabel()
        tabTitle.text = "零元抓"
        tabTitle.font = UIFont.systemFont(ofSize: 12)
        tabTitle.textColor = UIColor.black
        tabTitle.sizeToFit()
        tabTitle.tag = index
        addSubview(tabTitle)
        
        tabTitle.frame.origin = CGPoint(x: itemWidth/2 - tabTitle.bounds.width/2, y: 50)
        
        tabTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(tabImageView)
            make.top.equalTo(tabImageView).offset(tabImageView.bounds.height + 5)
        }
        
        tabImageView.isUserInteractionEnabled = true
        tabTitle.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tabClick(sender:)))
        tap.numberOfTapsRequired = 1
        tabTitle.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tabClick(sender:)))
        tap2.numberOfTapsRequired = 1
        tabImageView.addGestureRecognizer(tap2)
        
        isUserInteractionEnabled = true
    }
    
    @objc func tabClick(sender:UITapGestureRecognizer){
        if tabClickCallback != nil {
            tabClickCallback!((sender.view?.tag)!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
