//
//  TouchIDViewController.swift
//  AllSmallDemo
//
//  Created by Super on 2017/6/16.
//  Copyright © 2017年 Super. All rights reserved.
//

import UIKit

import LocalAuthentication
class TouchIDViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //步骤1：检查Touch ID是否可用
        var error: NSError?
        if #available(iOS 8.0, *) {
            let isTouchIdAvailable = LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,error: &error)
            NSLog("恭喜，Touch ID可以使用！")
            //步骤2：获取指纹验证结果
            LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "需要验证您的指纹来确认您的身份信息", reply: {
                (success, error) -> Void in
                if success{
                    NSLog("恭喜，您通过了Touch ID指纹验证！")
                }else{
                    NSLog("抱歉，您未能通过Touch ID指纹验证！\n\(error)")
                }
            })
        }else{
            NSLog("抱歉，Touch ID不可以使用！\n\(error)")
        }
    }

}
