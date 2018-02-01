//
//  BaseActionBarViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/31.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit

class BaseActionBarViewController: UIViewController {

    var actionTitleLabel = UILabel()
    
    var headView = UIView()
    
    let backImageView = UIButton.init(type: UIButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backImageView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + 45/2 - 45/2, width: 45, height: 45)
        backImageView.setImage(UIImage.init(named: "back"), for: UIControlState.normal)
        backImageView.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        
        headView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height + 45))
        headView.backgroundColor = UIColor.white
        view.addSubview(headView)
        
        headView.addSubview(backImageView)
        
        /// title
        actionTitleLabel.font = UIFont.systemFont(ofSize: 16)
        actionTitleLabel.text = "标题"
        actionTitleLabel.textColor = UIColor.black
        headView.addSubview(actionTitleLabel)
        actionTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backImageView)
            make.centerX.equalTo(headView)
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: headView.bounds.height, width: UIScreen.main.bounds.width, height: 0.5))
        lineView.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.8)
        view.addSubview(lineView)
        
        view.backgroundColor = UIColor.init(red: 245/255.0, green: 255/255.0, blue: 251/255.0, alpha: 1.0)
        
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

}
