//
//  TaijiViewController.swift
//  AllSmallDemo
//
//  Created by Super on 2017/6/14.
//  Copyright © 2017年 Super. All rights reserved.
//

import UIKit

@objc
class TaijiViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
       let widthOfScreen:CGFloat  = UIScreen.main.bounds.size.width
        let heightOfScreen:CGFloat  = UIScreen.main.bounds.size.height
        let taiji : TaijiView = TaijiView.init(frame: CGRect(x: 25, y: (heightOfScreen - widthOfScreen - 50) / 2, width:  widthOfScreen - 50, height:  widthOfScreen - 50))
        view.addSubview(taiji)
        taiji.setAnimationWithTimeInterval(0.02)
    }


}
