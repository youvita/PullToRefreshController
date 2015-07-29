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
            /* set animate to view */
            self.animator = UIDynamicAnimator(referenceView:self.tagetView!)
            pushBehavior = UIPushBehavior(items: [self.buttonView!], mode: UIPushBehaviorMode.Continuous)
            println("\(heightConstrain())")
            /* set collision for icon image */
            self.collisionBehavior = UICollisionBehavior(items: [self.buttonView!])
            self.collisionBehavior?.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsMake(self.buttonView!.frame.origin.y, 0,-heightConstrain(), 0))
            
            /* set icon image boune */
            self.itemBehavior = UIDynamicItemBehavior(items: [self.buttonView!])
            self.itemBehavior?.elasticity = 0.0
            self.itemBehavior?.allowsRotation = false
        }
    }
    
    func heightConstrain()->CGFloat{
        var height : CGFloat = self.buttonView!.frame.height + self.buttonView!.frame.origin.y
        return self.tagetView!.frame.height - height
    }
    
    // MARK: -Closesure Method
    func onClickHandle(UsingBlock block:(()->Void)!){
        self.onClicking = block
    }
    
    // MARK: -Target Button
    func onClicked(){
        if onClicking != nil {
           self.onClicking!()
        }
    }
    
    // MARK: - ScrollViewDelegate
    func ScrollViewDidScroll() {
        if isFinish {return}
        
        if self.scrollView?.contentOffset.y > self.currentPoint {
            // Down
            if self.styleView == Styles.Push {
                self.pushBehavior?.setAngle(CGFloat(M_PI_2), magnitude: 1.0)
                self.animator?.addBehavior(self.pushBehavior)
                self.animator?.addBehavior(self.collisionBehavior)
                self.animator?.addBehavior(self.itemBehavior)
//                UIView.animateWithDuration(1.0, animations: { () -> Void in
//                    self.buttonView!.alpha = 0.0
//                })
            }else{
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.buttonView!.alpha = 0.0
                })
            }
            self.currentPoint = self.scrollView?.contentOffset.y
        }else{
            // Up
            if self.styleView == Styles.Push  {
                self.pushBehavior?.setAngle(CGFloat(-M_PI_2), magnitude: 2.0)
//                UIView.animateWithDuration(1.5, animations: { () -> Void in
//                    self.buttonView!.alpha = 1.0
//                })
            }else{
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.buttonView!.alpha = 1.0
                })
            }
            self.currentPoint = self.scrollView?.contentOffset.y
        }
        
    }
    
    func ScrollViewWillBeginDragging() {
        isFinish = false
    }
    
    func ScrollViewDidEndDragging() {
        isFinish = true
    }



}
