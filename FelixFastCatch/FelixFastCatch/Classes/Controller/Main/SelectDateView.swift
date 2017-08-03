//
//  SelectDateViewController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2017/8/3.
//  Copyright © 2017年 felix. All rights reserved.
//

import UIKit

class SelectDateView: BaseDialog {

    private var rootView:UIView!
    
    private var hideView:HideView!
    
    /// 时间选择
    private var datePicker:UIDatePicker!
    
    private var navigationView:UIView!
    
    override func createView() {
        
        rootView = UIView(frame: CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 200))
        rootView.backgroundColor = UIColor.white
        addSubview(rootView)
        
        hideView = HideView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - rootView.bounds.height), hide: { [weak self] in
            self?.hide()
        })
        addSubview(hideView)
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: rootView.bounds.width, height: rootView.bounds.height))
        datePicker.datePickerMode = .date
        rootView.addSubview(datePicker)
        
        navigationView = UIView(frame: CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 40))
        navigationView.backgroundColor = UIColor.white
        addSubview(navigationView)
    
        let cancelBtn = UIButton(type: .system)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.sizeToFit()
        navigationView.addSubview(cancelBtn)
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(navigationView).offset(15)
            make.centerY.equalTo(navigationView)
        }
        
        cancelBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        let okBtn = UIButton(type: .system)
        okBtn.setTitle("确定", for: .normal)
        okBtn.sizeToFit()
        navigationView.addSubview(okBtn)
        
        okBtn.snp.makeConstraints { (make) in
            make.right.equalTo(navigationView).offset(-15)
            make.centerY.equalTo(navigationView)
        }
        
        okBtn.addTarget(self, action: #selector(okTime), for: .touchUpInside)
        
        addDialogToWindow()
    }
    
    func okTime() -> () {
        let con = ConstellationUtils.calculateWithDate(date: datePicker.date)
        ToastUtils.showSuccessToast(msg: "你的星座是:\(con)")
    }
    
    override func hide() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.shadow.alpha = 0.0
            self?.rootView.transform = CGAffineTransform(translationX: 0, y: 200)
            self?.navigationView.transform = CGAffineTransform(translationX: 0, y: 240)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.51) { [weak self] in
            self?.shadow.removeFromSuperview()
            self?.removeFromSuperview()
            self?.rootView.removeFromSuperview()
            self?.navigationView.removeFromSuperview()
        }
    }
    
    // 显示
    func show2() -> () {
//        rootView.transform = CGAffineTransform(translationX: 0, y: self.bounds.height - 200)
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.shadow.alpha = 0.5
            self?.isHidden = false
            self?.rootView.transform = CGAffineTransform(translationX: 0, y: -200)
            self?.navigationView.transform = CGAffineTransform(translationX: 0, y: -240)
    }
        
//        let duration: TimeInterval = 3 // 动画持续时间
//        let delay: TimeInterval = 0 // 动画延迟时间
//        let options: UIViewAnimationOptions = UIViewAnimationOptions.curveEaseInOut // 动画选项
//        let animations: () -> Void = {() -> Void in
//            self.rootView.transform = CGAffineTransform(translationX: 0, y: -200) // 位移动画, x 移动 0, y 移动 100
//        }
//        UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations) { (finish) -> Void in
//            print(finish)
//        }
    }
    
}
