//
//  TurnRoundMenuViewController.swift
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//
import UIKit
class TurnRoundMenuViewController: UIViewController,ASRadialMenuDelegate{
    var radialMenu:ASRadialMenu!
    var button: UIButton!
    var images:Array = ["01","02","03","04","05","06"]
    override func viewDidLoad() {
        super.viewDidLoad()
        button = UIButton.init(frame: CGRect(x: 200, y: 300, width: 50, height: 50))
        button.setImage(UIImage.init(named:"ball"), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        self.radialMenu = ASRadialMenu()
        self.radialMenu.delegate = self
    }
    func buttonPressed(_ sender: AnyObject) {
        self.radialMenu.buttonsWillAnimateFromButton(sender as! UIButton, frame: self.button.frame, view: self.view)
    }
    func numberOfItemsInRadialMenu (_ radialMenu:ASRadialMenu)->NSInteger {
        return 6
    }
    func arcSizeInRadialMenu (_ radialMenu:ASRadialMenu)->NSInteger {
        return 360
    }
    func arcRadiousForRadialMenu (_ radialMenu:ASRadialMenu)->NSInteger {
        return 80
    }
    func radialMenubuttonForIndex(_ radialMenu:ASRadialMenu,index:NSInteger)->ASRadialButton {
        let button:ASRadialButton = ASRadialButton()
        button.setImage(UIImage(named:images[index-1]), for:UIControlState())
        return button
    }
    func radialMenudidSelectItemAtIndex(_ radialMenu:ASRadialMenu,index:NSInteger) {
        self.radialMenu.itemsWillDisapearIntoButton(self.button)
    }
}

