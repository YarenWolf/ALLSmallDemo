//
//  ASRadialMenu.swift
//  ASRadial
//
//  Created by Alper Senyurt on 1/5/15.
//  Copyright (c) 2015 alperSenyurt. All rights reserved.
//

import UIKit
protocol ASRadialButtonDelegate:class{
    
    func buttonDidFinishAnimation(_ radialButton : ASRadialButton)
}

class ASRadialButton: UIButton {
    
    weak var delegate:ASRadialButtonDelegate?
    var centerPoint:CGPoint!
    var bouncePoint:CGPoint!
    var originPoint:CGPoint!
    
    
    func willAppear () {
        
        
        self.imageView?.transform = CGAffineTransform.identity.rotated(by: 180/180 * CGFloat(Double.pi))
        self.alpha                = 1.0
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.center               = self.bouncePoint
            self.imageView?.transform = CGAffineTransform.identity.rotated(by: 0/180 * CGFloat(Double.pi))
        }) { (finished:Bool) -> Void in
            UIView.animate(withDuration: 0.15, animations: { () -> Void in
                self.center = self.centerPoint
            })
        }
        
    }
    
    func willDisappear () {
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            if let imageView = self.imageView {
                imageView.transform = CGAffineTransform.identity.rotated(by: -180/180 * CGFloat(Double.pi))
            }
            
        })  { (finished:Bool) -> Void in
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.center = self.originPoint
            }, completion: { (finished) -> Void in
                self.alpha = 0
                self.delegate?.buttonDidFinishAnimation(self)
            })        }
        
        
    }
}
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


@objc protocol ASRadialMenuDelegate:class {
    
    func numberOfItemsInRadialMenu (_ radialMenu:ASRadialMenu)->NSInteger
    func arcSizeInRadialMenu (_ radialMenu:ASRadialMenu)->NSInteger
    func arcRadiousForRadialMenu (_ radialMenu:ASRadialMenu)->NSInteger
    func radialMenubuttonForIndex(_ radialMenu:ASRadialMenu,index:NSInteger)->ASRadialButton
    func radialMenudidSelectItemAtIndex(_ radialMenu:ASRadialMenu,index:NSInteger)
    
    @objc optional  func arcStartForRadialMenu (_ radialMenu:ASRadialMenu)->NSInteger
    @objc optional  func buttonSizeForRadialMenu (_ radialMenu:ASRadialMenu)->CGFloat
    
    
    
    
}
class ASRadialMenu: UIView,ASRadialButtonDelegate{
    
    var items:[UIView]! = []
    var animationTimer:Timer?
    weak var delegate:ASRadialMenuDelegate?
    var itemIndex:NSInteger = 0
    
    func itemsWillAppear(_ fromButton:UIButton,frame:CGRect,inView:UIView){
        
        if self.items?.count > 0 {
            
            return
        }
        
        if self.animationTimer != nil {
            return
        }
        
        let itemCount:NSInteger = delegate?.numberOfItemsInRadialMenu(self) ?? -1
        
        if itemCount == -1 {
            
            return
        }
        
        var mutablePopup:[UIView]    = []
        let arc:NSInteger            = self.delegate?.arcSizeInRadialMenu(self) ?? 90
        let radius:NSInteger         = self.delegate?.arcRadiousForRadialMenu(self) ?? 80
        var start:NSInteger          = 0
        
        if let respondArcStartMethod = self.delegate?.arcStartForRadialMenu {
            
            start          = respondArcStartMethod(self)
        }
        
        var  angle:CGFloat = 0
        
        if arc>=360 {
            
            angle         = CGFloat(360)/CGFloat(itemCount)
            
        } else if itemCount>1 {
            
            angle         = CGFloat(arc)/CGFloat((itemCount-1))
        }
        let centerX       = frame.origin.x + (frame.size.height/2);
        let centerY       = frame.origin.y + (frame.size.width/2);
        let origin        = CGPoint(x: centerX, y: centerY);
        
        var buttonSize:CGFloat = 25.0;
        
        if let respondbuttonSizeForRadialMenuMethod = self.delegate?.buttonSizeForRadialMenu {
            
            buttonSize         = respondbuttonSizeForRadialMenuMethod(self)
        }
        
        var currentItem:NSInteger = 1;
        var popupButton:ASRadialButton?;
        
        
        while currentItem <= itemCount {
            
            let radians = (angle * (CGFloat(currentItem) - 1.0) + CGFloat(start)) * (CGFloat(Double.pi)/CGFloat(180))
            
            let x      = round (centerX + CGFloat(radius) * cos(CGFloat(radians)));
            let y      = round (centerY + CGFloat(radius) * sin(CGFloat(radians)));
            let extraX = round (centerX + (CGFloat(radius)*1.07) * cos(CGFloat(radians)));
            let extraY = round (centerY + (CGFloat(radius)*1.07) * sin(CGFloat(radians)));
            
            let popupButtonframe = CGRect(x: centerX-buttonSize*0.5, y: centerY-buttonSize*0.5, width: buttonSize, height: buttonSize);
            let final   = CGPoint(x: x, y: y);
            let bounce  = CGPoint(x: extraX, y: extraY);
            popupButton = self.delegate?.radialMenubuttonForIndex(self, index: currentItem)
            popupButton?.frame = popupButtonframe
            popupButton?.centerPoint = final
            popupButton?.bouncePoint = bounce
            popupButton?.originPoint = origin
            popupButton?.tag         = currentItem
            popupButton?.delegate    = self
            popupButton?.addTarget(self, action: #selector(ASRadialMenu.buttonPressed(_:)), for: UIControlEvents.touchUpInside)
            popupButton.map {inView.insertSubview($0, belowSubview: fromButton)}
            popupButton.map { mutablePopup.append($0)}
            currentItem += 1
            
        }
        
        self.items     = mutablePopup;
        self.itemIndex = 0;
        let maxDuration:CGFloat = 0.50;
        let flingInterval       = maxDuration/CGFloat(self.items.count);
        self.animationTimer     = Timer.scheduledTimer(timeInterval: Double(flingInterval), target: self, selector: #selector(ASRadialMenu.willFlingItem), userInfo: nil, repeats: true)
        let spinDuration        = CGFloat(self.items.count+1) * flingInterval;
        self.shouldRotateButton(fromButton, forDuration: spinDuration, forwardDirection: false)
        
        
    }
    
    
    func itemsWillDisapearIntoButton(_ button:UIButton) {
        
        if self.items?.count == 0 {
            
            return
        }
        
        if let animation =  self.animationTimer  {
            
            animation.invalidate()
            self.animationTimer = nil
            self.itemIndex      = self.items.count
        }
        
        let maxDuration:CGFloat = 0.50
        let flingInterval       = maxDuration / CGFloat(self.items.count)
        self.animationTimer     = Timer.scheduledTimer(timeInterval: Double(flingInterval), target: self, selector: #selector(ASRadialMenu.willRecoilItem), userInfo: nil, repeats: true)
        let spinDuration        = CGFloat(self.items.count + 1) * flingInterval
        self.shouldRotateButton(button, forDuration: spinDuration, forwardDirection: false)
    }
    
    func buttonsWillAnimateFromButton(_ sender:AnyObject,frame:CGRect,view:UIView){
        
        if self.animationTimer != nil {
            
            return
        }
        if self.items?.count > 0 {
            
            self.itemsWillDisapearIntoButton(sender as! UIButton)
        } else {
            
            self.itemsWillAppear(sender as! UIButton, frame: frame, inView: view)
        }
    }
    
    func shouldRotateButton(_ button:UIButton,forDuration:CGFloat, forwardDirection:Bool) {
        
        let spinAnimation            = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.duration       = Double(forDuration)
        spinAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        var totalDuration            = CGFloat(Double.pi) * CGFloat(self.items.count)
       
        if forwardDirection {
            
            totalDuration = totalDuration * -1
        }
        spinAnimation.toValue = NSNumber(value: Float(totalDuration) as Float)
        button.layer.add(spinAnimation, forKey: "spinAnimation")
    }
    
    @objc func willRecoilItem() {
       
        if self.itemIndex == 0 {
            self.animationTimer?.invalidate();
            self.animationTimer = nil;
            return;
        }
        self.itemIndex -= 1
        
        let button = self.items[self.itemIndex] as! ASRadialButton
        button.willDisappear()
        
    }
    @objc func willFlingItem() {
        
        if self.itemIndex == self.items.count {
            self.animationTimer?.invalidate();
            self.animationTimer = nil;
            return;
        }
        
        let button = self.items[self.itemIndex] as! ASRadialButton
        button.willAppear()
        self.itemIndex += 1
    }
    
    func buttonPressed(_ sender:AnyObject) {
       
        let button = sender as! ASRadialButton
        self.delegate?.radialMenudidSelectItemAtIndex(self, index: button.tag)
        
    }
    
    func buttonDidFinishAnimation(_ radialButton : ASRadialButton) {
        
        radialButton.removeFromSuperview()
        
        if radialButton.tag == 1 {
            
            self.items = nil
        }
    }
    
}
