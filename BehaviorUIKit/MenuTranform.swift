//
//  MenuTranform.swift
//  BehaviorUIKit
//
//  Created by Chan Youvita on 7/14/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit

class MenuTranform: NSObject {
    var mainView          : UIView?
    var spaceView         : UIView?
    var animator          : UIDynamicAnimator?
    var collisionBehavior : UICollisionBehavior?
    var pushBehavior      : UIPushBehavior?
    var panGesture        : UIPanGestureRecognizer?
    var touchGesture      : UITapGestureRecognizer?
    var tapViewGesture    : UITapGestureRecognizer?
    var itemBehavior      : UIDynamicItemBehavior?
    var shapBehavior      : UISnapBehavior?
    var timer             : NSTimer?
    var oldPoint          : CGPoint?
    var sizeView          : UIView?
    var frameView         : CGRect?
    var tapHandler        : ((Bool)->Void)?
    var isModify          : Bool = false{
        didSet{
            if isModify {
                /* resize */
                self.timer?.invalidate()
                oldPoint = self.mainView?.frame.origin
                UIView.animateWithDuration(0.2 , animations: { () -> Void in
                    let scaleTransform = CGAffineTransformMakeScale(4.9, 4.9)
                    self.mainView!.transform = scaleTransform
                    self.mainView?.frame.origin = CGPointMake(UIScreen.mainScreen().bounds.width / 2 - self.mainView!.bounds.width, UIScreen.mainScreen().bounds.height / 2 - self.mainView!.bounds.height)
                    self.mainView?.layer.cornerRadius = 2.0
                    self.mainView?.alpha = 0.8
                    
                })
                
                self.panGesture?.enabled = false
                
            }else{
                /* normal size */
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    let scaleTransform = CGAffineTransformIdentity
                    self.mainView!.transform = scaleTransform
                    self.mainView?.frame.origin = self.oldPoint!
                    self.mainView?.layer.cornerRadius = 10.0
                    self.mainView?.alpha = 1.0
                })
            
                self.panGesture?.enabled = true
                timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("hided"), userInfo: nil, repeats:false)
            }
        }
    }
    
    init(size:UIView,frame:CGRect) {
        super.init()
        self.sizeView = size
        self.frameView = frame
        println("load init")
        setupView()
        
        // Instantiates the Pan Gesture Recognizers and adds it to the greenBox instance
        self.panGesture = UIPanGestureRecognizer(target: self, action: "panning:")
        self.mainView?.addGestureRecognizer(panGesture!)
        
        self.touchGesture = UITapGestureRecognizer(target: self, action: "touchable:")
        self.mainView?.addGestureRecognizer(touchGesture!)

//        self.tapViewGesture = UITapGestureRecognizer(target: self, action: "closeMenu:")
//        self.sizeView?.addGestureRecognizer(tapViewGesture!)
    }
    
    func enable(){
        touchGesture?.enabled = true
        panGesture?.enabled = true
    }
    
    func disable(){
        touchGesture?.enabled = false
        panGesture?.enabled = false
    }
    
    func tapGestureHandle(usingBlock block:((Bool) -> Void)!){
        self.tapHandler = block
    }
    
    func setupView(){
        animator = UIDynamicAnimator(referenceView: self.sizeView!)
        mainView = UIView(frame: self.frameView!)
        mainView?.backgroundColor = UIColor.grayColor()
        mainView?.layer.cornerRadius = 10.0
        mainView?.layer.masksToBounds = true
        self.sizeView!.addSubview(mainView!)
        
        pushBehavior = UIPushBehavior(items: [self.mainView!], mode: UIPushBehaviorMode.Continuous)
        pushBehavior?.active = true
        
        itemBehavior = UIDynamicItemBehavior(items: [self.mainView!])
        itemBehavior?.allowsRotation = false
        itemBehavior?.elasticity = 0.0
        
        collisionBehavior = UICollisionBehavior(items: [self.mainView!])
        collisionBehavior?.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsMake(2, 2, 2, 2))// set inset distances for views
        
    }
    
    func touchable(touch:UITapGestureRecognizer){
        isModify = !isModify
        self.tapHandler!(isModify)
    }
    
//    func closeMenu(tap:UITapGestureRecognizer){
//        var location = tap.locationInView(self.sizeView!)
//        
//        if isModify {
//            isModify = false
//        }
//        
//        if shapBehavior != nil{
//            self.animator?.removeBehavior(shapBehavior)
//        }
//        
//        shapBehavior = UISnapBehavior(item: self.mainView!, snapToPoint: location)
//        shapBehavior?.damping = 1.0
//        self.animator?.addBehavior(shapBehavior)
//    }
    
    func panning(pan:UIPanGestureRecognizer){
        var location = pan.locationInView(self.sizeView!)
        var touchLocation = pan.locationInView(self.mainView!)
        
        if pan.state == UIGestureRecognizerState.Began {
            pan.view?.center = location
            self.animator?.removeAllBehaviors()
            timer?.invalidate()
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.mainView?.alpha = 1.0
            })
        }
        else if pan.state == UIGestureRecognizerState.Changed {
            pan.view?.center = location
        }
        else if pan.state == UIGestureRecognizerState.Ended {
            self.setupLocation(location)
            timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("hided"), userInfo: nil, repeats:false)
            
        }
    }
    
    func setupLocation(location:CGPoint){
        if location.y < 76 {
            // top
            pushBehavior?.setAngle(CGFloat(-M_PI_2), magnitude: 10.0)
            self.animator?.addBehavior(pushBehavior)
            self.animator?.addBehavior(collisionBehavior)
            self.animator?.addBehavior(itemBehavior)
        }else if location.y > self.sizeView!.frame.height - 76 {
            // bottom
            pushBehavior?.setAngle(CGFloat(M_PI_2), magnitude: 10.0)
            self.animator?.addBehavior(pushBehavior)
            self.animator?.addBehavior(collisionBehavior)
            self.animator?.addBehavior(itemBehavior)
        }
        else{
            if location.x < self.sizeView!.frame.width / 2 {
                // left
                pushBehavior?.setAngle(CGFloat(M_PI), magnitude: 30.0)
                self.animator?.addBehavior(pushBehavior)
                self.animator?.addBehavior(collisionBehavior)
                self.animator?.addBehavior(itemBehavior)
            }else{
                // right
                pushBehavior?.setAngle(CGFloat(0.0), magnitude: 30.0)
                self.animator?.addBehavior(pushBehavior)
                self.animator?.addBehavior(collisionBehavior)
                self.animator?.addBehavior(itemBehavior)
            }
        }

    }
    
    func hided(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.mainView?.alpha = 0.4
        })
        
    }


}
