//
//  EffectButton.swift
//  BehaviorUIKit
//
//  Created by Chan Youvita on 7/29/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit

public enum Styles {
    case Fade
    case Push
    case Zoom
    case Rotae
}

class EffectButton: UIView {
    var scrollView          : UIScrollView?
    var buttonView          : UIButton?
    var tagetView           : UIView?
    var pushBehavior        : UIPushBehavior?
    var collisionBehavior   : UICollisionBehavior?
    var itemBehavior        : UIDynamicItemBehavior?
    var animator            : UIDynamicAnimator?
    var isFinish            : Bool = false
    var isHited             : Bool = false
    var currentPoint        : CGFloat?
    var styleView           : Styles?
    var onClicking          : (()->Void)?
  
    
    init(frame: CGRect,scrollView:UIScrollView,buttonView:UIButton,tagetView:UIView,styleView:Styles) {
    super.init(frame: frame)
        self.scrollView = scrollView
        self.buttonView = buttonView
        self.tagetView  = tagetView
        self.styleView  = styleView
        self.setUpFrame()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func attactToTableView(tableView:UITableView,buttonView:UIButton,tagetView:UIView,styleView:Styles)->EffectButton{
        return self.attactToScrollView(tableView,buttonView: buttonView,tagetView: tagetView,styleView: styleView)
    }
    
    class func attactToScrollView(scrollView:UIScrollView,buttonView:UIButton,tagetView:UIView,styleView:Styles)->EffectButton{
        var existingRefresh = self.findRefreshControlInScrollView(scrollView)
        if (existingRefresh != nil) {
            return existingRefresh!
        }
        
        var refreshControl = EffectButton(frame: CGRectMake(0.0, 0.0, scrollView.frame.size.width, 0.0)
            , scrollView: scrollView,buttonView: buttonView,tagetView: tagetView,styleView: styleView)
        
        scrollView.addSubview(refreshControl)
        return refreshControl
    }

    class func findRefreshControlInScrollView(scrollView:UIScrollView)->EffectButton?{
        for subview in scrollView.subviews {
            if subview.isKindOfClass(EffectButton){
                return subview as? EffectButton
            }
        }
        return nil
    }
    
    func setUpFrame(){
        self.tagetView!.addSubview(self.buttonView!)
        self.buttonView?.addTarget(self, action: "onClicked", forControlEvents: UIControlEvents.TouchUpInside)
        
        if self.styleView == Styles.Push {
            self.addBehaviorAnimator()
        }
    }
    
    func addBehaviorAnimator(){
        /* set animate to view */
        self.animator = UIDynamicAnimator(referenceView:self.tagetView!)
        pushBehavior = UIPushBehavior(items: [self.buttonView!], mode: UIPushBehaviorMode.Continuous)
        
        /* set collision for icon image */
        self.collisionBehavior = UICollisionBehavior(items: [self.buttonView!])
        self.collisionBehavior?.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsMake(self.buttonView!.frame.origin.y, 0,-heightConstrain(), 0))
        
        /* set icon image boune */
        self.itemBehavior = UIDynamicItemBehavior(items: [self.buttonView!])
        self.itemBehavior?.elasticity = 0.0
        self.itemBehavior?.allowsRotation = false
    }
    
    func heightConstrain()->CGFloat{
        var height : CGFloat = self.buttonView!.frame.height + self.buttonView!.frame.origin.y
        return self.tagetView!.frame.height - height
    }
    
    // MARK: - Closesure Method
    func onClickHandle(UsingBlock block:(()->Void)!){
        self.onClicking = block
    }
    
    // MARK: - Target Button
    func onClicked(){
        if onClicking != nil {
           self.onClicking!()
        }
    }
    
     // MARK: - ScrollViewDelegate
    func scrollViewDidScroll() {
        if isFinish {return}
        
        /* Checking when scroll hited bottom */
        if self.scrollView!.contentOffset.y + self.scrollView!.frame.size.height > self.scrollView!.contentSize.height {
            isHited = true // hited
        }else{
            isHited = false // not hited
        }
        
        if self.scrollView?.contentOffset.y > self.currentPoint && self.scrollView?.contentOffset.y > 0.0 {
            // Up for hide
            if !isHited {
                if self.styleView == Styles.Push {
                    /* Push Event */
                    self.pushBehavior?.setAngle(CGFloat(M_PI_2), magnitude: 2.0)
                    self.animator?.addBehavior(self.pushBehavior)
                    self.animator?.addBehavior(self.collisionBehavior)
                    self.animator?.addBehavior(self.itemBehavior)
                }else if self.styleView == Styles.Rotae {
                    UIView.animateWithDuration(1 , animations: { () -> Void in
                        self.buttonView?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                        self.buttonView?.alpha = 0.0
                    })
                }
                else if self.styleView == Styles.Zoom {
                    /* Zoom Event */
                        UIView.animateWithDuration(1 , animations: { () -> Void in
                            self.buttonView?.transform = CGAffineTransformMakeScale(0.5,0.5)
                            self.buttonView?.alpha = 0.0
                        })
                }else{
                    /* Fade Event */
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.buttonView!.alpha = 0.0
                    })
                }
                
                self.currentPoint = self.scrollView?.contentOffset.y
            }
        }else{
            // Down for showing
            if self.styleView == Styles.Push  {
                /* Push Event */
                self.pushBehavior?.setAngle(CGFloat(-M_PI_2), magnitude: 2.0)
            }else if self.styleView == Styles.Rotae {
                UIView.animateWithDuration(1, animations: { () -> Void in
                    self.buttonView?.alpha = 1.0
                    self.buttonView?.transform = CGAffineTransformIdentity
                })
            }
            else if self.styleView == Styles.Zoom {
                /* Zoom Event */
                    UIView.animateWithDuration(1 , animations: { () -> Void in
                        self.buttonView?.alpha = 1.0
                        self.buttonView?.transform = CGAffineTransformIdentity
                    })
            }else{
                /* Fade Event */
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.buttonView!.alpha = 1.0
                })
            }
            
            self.currentPoint = self.scrollView?.contentOffset.y
        }
    }
    
    func scrollViewDidEndDragging() {
        isFinish = true
    }
    
    func scrollViewWillBeginDragging() {
        isFinish = false
    }

}
