//
//  RotationController.swift
//  BehaviorUIKit
//
//  Created by Chan Youvita on 7/16/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
}

class RotationController: NSObject {
    var rotationImage   : UIImageView?
    var rotationView    : UIView?
    var rotationframe   : CGRect?
    var timer           : NSTimer?
    var speed           : CFTimeInterval = 1.0
    
    init(view:UIView,image:UIImageView,frame:CGRect){
        super.init()
        self.rotationImage   = image
        self.rotationView    = view
        self.rotationframe   = frame
    }
    
    convenience init(view:UIView,image:UIImageView,frame:CGRect,speed:CFTimeInterval){
        self.init(view:view,image:image,frame:frame)
        self.speed = speed
    }
    
    func setup(){
        self.rotationImage?.frame = self.rotationframe!
        self.rotationView?.addSubview(self.rotationImage!)
    }
    
    func start(){
        self.rotationImage?.rotate360Degrees(duration: speed,completionDelegate: self)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: "rotation", userInfo: nil, repeats: true)
        UIView.animateWithDuration(0.2, animations: {
            self.rotationImage?.alpha = 1.0
        })
    }
    
    func stop(){
        self.timer?.invalidate()
    }
    
    func hide(){
        UIView.animateWithDuration(0.2, animations: {
            self.rotationImage?.alpha = 0.0
        })
    }
    
    func rotation(){
        self.rotationImage?.rotate360Degrees(duration: speed,completionDelegate: self)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
