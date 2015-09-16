//
//  MenuTranform.swift
//  BehaviorUIKit
//
//  Created by Chan Youvita on 7/14/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit

class MenuTranform: UIView {
    var mainView          : UIView?
    var spaceView         : UIView?
    var contentView       : UIView?
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
    var tapHandler        : ((String,Int)->Void)?
    var items             : [MenuItems]?
    var itemOffset               = -40
    var operatorSymbo     : String?
    var enableClick       : Bool = false
    var enableMoving      : Bool = false
    var setTrueFalse      : Bool = false
    var isModify          : Bool = false{
        didSet{
            if isModify {
                /* Show Menu */
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: nil, animations: {
                    if let optionalItems = self.items {
                            for (index, item) in enumerate(optionalItems) {
                                item.tag = index // set index to button
                                
                                let offset = "\(self.operatorSymbo!)\(index + 1)".toInt()
                                let translation = self.itemOffset * offset!
                                item.view.transform = CGAffineTransformMakeTranslation(0, CGFloat(translation))
                                item.view.alpha = 1
                            }
                        }
                }, completion: {completed in})
                self.enableMoving = true
                self.showBlur()
            }else{
                /* Close Menu */
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: nil, animations: {
                    if let optionalItems = self.items {
                        for item in optionalItems {
                            item.view.transform = CGAffineTransformMakeTranslation(0, 0)
                            item.view.alpha = 0
                        }
                    }
                }, completion: {completed in})
                self.enableMoving = false
                self.hideBlur()
                timer?.invalidate()
                timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("hided"), userInfo: nil, repeats:false)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(size:UIView,frame:CGRect) {
        self.init(frame: frame)
        self.sizeView = size
        self.frameView = frame
        self.setupView()
        
        // Instantiates the Pan Gesture Recognizers and adds it to the greenBox instance
        self.panGesture = UIPanGestureRecognizer(target: self, action: "panning:")
        self.mainView?.addGestureRecognizer(panGesture!)
        
        self.touchGesture = UITapGestureRecognizer(target: self, action: "touchable:")
        self.mainView?.addGestureRecognizer(touchGesture!)

        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        animator = UIDynamicAnimator(referenceView: self.sizeView!)
        mainView = UIView(frame: self.frameView!)
        mainView?.backgroundColor       = UIColor.grayColor()
        mainView?.layer.cornerRadius    = 20.0
        mainView?.layer.masksToBounds   = true
        mainView?.alpha                 = 0.4
        self.sizeView!.addSubview(mainView!)
        
        pushBehavior = UIPushBehavior(items: [self.mainView!], mode: UIPushBehaviorMode.Continuous)
        pushBehavior?.active = true
        
        itemBehavior = UIDynamicItemBehavior(items: [self.mainView!])
        itemBehavior?.allowsRotation = false
        itemBehavior?.elasticity = 0.0
        
        collisionBehavior = UICollisionBehavior(items: [self.mainView!])
        collisionBehavior?.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsMake(2, 2, 2, 2))// set inset distances for views
        
        self.contentView = UIView(frame: self.sizeView!.bounds)
        self.contentView?.alpha = 0.95
        var blurEffect = UIVisualEffectView(effect: UIBlurEffect(style:UIBlurEffectStyle.ExtraLight))
        blurEffect.frame = self.contentView!.frame
        contentView?.addSubview(blurEffect)
     
    }
    
    func hided(){
        if !enableMoving {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.mainView?.alpha = 0.4
                self.enableClick = false
            })
        }
    }
    
    func showBlur(){
        self.sizeView?.insertSubview(self.contentView!, belowSubview: self.mainView!)
    }
    
    func hideBlur(){
        self.contentView?.removeFromSuperview()
    }

    
    //MARK: - GestureRecognizer
    func touchable(touch:UITapGestureRecognizer){
        if enableClick {
            isModify = !isModify
            self.locationButtonItems() // init the location of button menu
            self.mainView?.layer.addAnimation(setScaleAnimation(0.1), forKey: "scale")
        }
    }
    
    func panning(pan:UIPanGestureRecognizer){
        var location = pan.locationInView(self.sizeView!)
        var touchLocation = pan.locationInView(self.mainView!)
    
        /* Control object don move outside view */
        let targetX = location.x - (self.mainView!.frame.width / 2)
        let targetY = location.y - (self.mainView!.frame.height / 2)
        
        if !(targetX <= 0 || targetX >= self.sizeView!.frame.width - (self.mainView!.frame.width) || targetY <= 0 || targetY >= self.sizeView!.frame.height - (self.mainView!.frame.height)){
            if !enableMoving {
                
                if pan.state == UIGestureRecognizerState.Began {
                    pan.view?.center = location
                    
                    self.animator?.removeAllBehaviors()
                    timer?.invalidate()
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.mainView?.alpha = 1.0
                        self.enableClick = true
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
        }else{
            /* over target view */
            if pan.state == UIGestureRecognizerState.Began {
//                pan.view?.center = location
                self.animator?.removeAllBehaviors()
                timer?.invalidate()
            }
            else if pan.state == UIGestureRecognizerState.Ended {
                self.setupLocation(location)
                timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("hided"), userInfo: nil, repeats:false)
            }
            
        }
    }
    
    func setupLocation(location:CGPoint){
        
        /* Check to set up label and button to show left or right */
        if location.x < self.sizeView!.frame.width / 2 {
            self.setTrueFalse = false // set left to right
        }else{
            self.setTrueFalse = true // set right to left
        }
        
        /* Check to set up label and button to show down or up */
        if location.y < self.sizeView!.frame.height / 2 {
            self.operatorSymbo = "-" // Down
        }else{
            self.operatorSymbo = "+" // Up
        }

        if location.y < 76 {
            // top
            pushBehavior?.setAngle(CGFloat(-M_PI_2), magnitude: 10.0)
            self.animator?.addBehavior(pushBehavior)
            self.animator?.addBehavior(collisionBehavior)
            self.animator?.addBehavior(itemBehavior)
            self.operatorSymbo = "-" // Down
            
            
        }else if location.y > self.sizeView!.frame.height - 76 {
            // bottom
            pushBehavior?.setAngle(CGFloat(M_PI_2), magnitude: 10.0)
            self.animator?.addBehavior(pushBehavior)
            self.animator?.addBehavior(collisionBehavior)
            self.animator?.addBehavior(itemBehavior)
            self.operatorSymbo = "+" // Up
        }
        else{
            if location.x < self.sizeView!.frame.width / 2 {
                // left
                pushBehavior?.setAngle(CGFloat(M_PI), magnitude: 10.0)
                self.animator?.addBehavior(pushBehavior)
                self.animator?.addBehavior(collisionBehavior)
                self.animator?.addBehavior(itemBehavior)
                self.setTrueFalse = false // set left to right
            }else{
                // right
                pushBehavior?.setAngle(CGFloat(0.0), magnitude: 10.0)
                self.animator?.addBehavior(pushBehavior)
                self.animator?.addBehavior(collisionBehavior)
                self.animator?.addBehavior(itemBehavior)
                self.setTrueFalse = true // set right to left
            }
        }

    }
    
    func addGestureHandle(usingBlock block:((String,Int) -> Void)!){
        self.tapHandler = block
    }

    
    //MARK: - MenuItem Method
    private func locationButtonItems() {
        if let optionalItems = self.items {
            for item in optionalItems {
                item.isRL = self.setTrueFalse
                item.view.center = CGPoint(x: self.mainView!.center.x - 83, y: self.mainView!.center.y)
                item.view.removeFromSuperview()
                self.sizeView?.insertSubview(item.view, belowSubview: self.mainView!)
            }
        }
    }
    
    func addMenuItems(titles:[String]?,images:[UIImage]?){
        var menuArr = [MenuItems]()
        var menuItem = MenuItems()
        for(var i = 0 ; i < images!.count ; i++) {
            if titles == nil {
                menuItem = MenuItems(title: nil, image: images![i]) // No title
            }else{
                menuItem = MenuItems(title: titles![i], image: images![i])
            }
            
            /* Add action to button */
            menuItem.action = {
                item in 
                self.isModify = false
                if titles == nil{
                    self.tapHandler!("No Title",item.tag)
                }else{
                    self.tapHandler!(item.text,item.tag)
                }
            }
            menuArr.append(menuItem)
        }
        items = menuArr
    }
    
    func setScaleAnimation(time:CFTimeInterval)->CABasicAnimation{
        var animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.10
        animation.duration = time
        animation.autoreverses = true
        return animation
    }


}
