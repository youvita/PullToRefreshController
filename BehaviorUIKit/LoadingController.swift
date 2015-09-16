//
//  LoadingController.swift
//  BehaviorUIKit
//
//  Created by Chan Youvita on 7/20/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit

enum LoadingType {
    case Style1
    case Style2
    case Style3
}

class LoadingController: UIView {
    
    class func loadingView(superView:UIView,loadType:LoadingType){
        var loadView = LoadingController(frame: UIScreen.mainScreen().bounds)
        loadView.tag = 1000
        var background = UIImageView(frame: loadView.bounds)
        background.backgroundColor = UIColor.blackColor()
        background.alpha = 0.1
        loadView.addSubview(background)

        switch(loadType){
            case LoadingType.Style1 :
                /* Using single image to roate */
                var loadingImg = UIImageView(image: UIImage(named: "loading.png"))
                loadingImg.frame = CGRectMake(loadView.bounds.width * 0.5 - 12.0, loadView.bounds.height * 0.5 - 12.0 - 44, 25.0, 25.0)
                loadView.addSubview(loadingImg)
                
                let radians = atan2(loadingImg.transform.b, loadingImg.transform.a)
                let degrees = radians * (180 / CGFloat(M_PI) )
                
                var animation = CABasicAnimation(keyPath: "transform.rotation")
                animation.fromValue = degrees
                animation.toValue = M_PI * 2.0
                animation.duration = 1.0
                animation.repeatCount = HUGE
                loadingImg.layer.addAnimation(animation, forKey: "rotation")
            
            case LoadingType.Style2 :
                /* Using images load with animation array */
                var lodingImageView = UIImageView(frame: CGRectMake((loadView.bounds.width/2) - 10,(loadView.bounds.height/2)-10 - 44, 20.0, 20.0))
                lodingImageView.image        = UIImage(named: "")
                var animatedImageView = UIImageView(frame: CGRectMake(0, 0, 24, 27))
                var imageNames = ["load_01.png","load_02.png","load_03.png","load_04.png","load_05.png","load_06.png"]
                var images = NSMutableArray()
                for var i = 0 ; i<imageNames.count ; i++ {
                    images.addObject(UIImage(named: imageNames[i] as String)!)
                }
                
                animatedImageView.animationImages = images as [AnyObject]
                animatedImageView.animationDuration = 1.0
                animatedImageView.animationRepeatCount = 0
                lodingImageView.addSubview(animatedImageView)
                loadView.addSubview(lodingImageView)
                animatedImageView.startAnimating()
            
            case LoadingType.Style3 :
                var mainview = UIView(frame: CGRectMake(loadView.bounds.width * 0.5 - 20.0, loadView.bounds.height * 0.5 - 20.0 - 44, 40, 40))
                var container = UIView(frame: CGRectMake(0,0, 40, 40))
                
                mainview.addSubview(container)
                mainview.layer.cornerRadius = 20.0
                mainview.backgroundColor = UIColor.whiteColor()
                mainview.layer.shadowOffset = CGSizeMake(0,0)
                mainview.layer.shadowColor = UIColor.blackColor().CGColor
                mainview.layer.shadowRadius = 1.0
                mainview.layer.shadowOpacity = 0.5
                
                var animationScale = CABasicAnimation(keyPath: "transform.scale")
                animationScale.toValue = 1.20
                animationScale.duration = 1.0
                animationScale.autoreverses = true
                animationScale.repeatCount = HUGE
                mainview.layer.addAnimation(animationScale, forKey: "scale")
                
                /* Circle */
                var pathLayer = CAShapeLayer()
                pathLayer.fillColor = nil
                pathLayer.lineWidth = 3
                pathLayer.path = UIBezierPath(arcCenter: CGPointMake(20, 20), radius: 10, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true).CGPath
                pathLayer.lineCap = kCALineCapRound
                container.layer.addSublayer(pathLayer)
                
                loadView.addSubview(mainview)
                
                let radians = atan2( container.transform.b, container.transform.a)
                let degrees = radians * (180 / CGFloat(M_PI))
                println("\(degrees)")
                
                var animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.fromValue = degrees
                animation.toValue = CGFloat(M_PI * 2.0) + degrees
                animation.duration = 4
                animation.repeatCount = HUGE
                container.layer.addAnimation(animation, forKey: "rotation_animation")
                
                var beginHeadAnimate = CABasicAnimation(keyPath: "strokeStart")
                beginHeadAnimate.duration = 0.5
                beginHeadAnimate.fromValue = 0.25
                beginHeadAnimate.toValue = 1.0
                beginHeadAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                
                var beginTailAnimate = CABasicAnimation(keyPath: "strokeEnd")
                beginTailAnimate.duration = 0.5
                beginTailAnimate.fromValue = 1.0
                beginTailAnimate.toValue = 1.0
                beginTailAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                
                var endHeadAnimate = CABasicAnimation(keyPath: "strokeStart")
                endHeadAnimate.beginTime = 0.5
                endHeadAnimate.duration = 1.0
                endHeadAnimate.fromValue = 0.0
                endHeadAnimate.toValue = 0.25
                endHeadAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                
                var endTailAnimate = CABasicAnimation(keyPath: "strokeEnd")
                endTailAnimate.beginTime = 0.5
                endTailAnimate.duration = 1.0
                endTailAnimate.fromValue = 0.0
                endTailAnimate.toValue = 1.0
                endTailAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                
                var groupAnimate = CAAnimationGroup()
                groupAnimate.duration = 1.5
                groupAnimate.removedOnCompletion = false
                groupAnimate.repeatCount = HUGE
                groupAnimate.animations = [beginHeadAnimate,beginTailAnimate,endHeadAnimate,endTailAnimate]
                pathLayer.addAnimation(groupAnimate, forKey: "stroke")
                
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                pathLayer.strokeColor = UIColor.purpleColor().CGColor
                CATransaction.commit()

        }
       
        superView.addSubview(loadView)
        superView.userInteractionEnabled = false
    }
    
    class func removeLoadingView(superView:UIView){
        var subView = superView.viewWithTag(1000)
        subView!.removeFromSuperview()
        superView.userInteractionEnabled = true
    }
    
}
