//
//  LoadingController.swift
//  BehaviorUIKit
//
//  Created by Chan Youvita on 7/20/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit

enum LoadingType {
    case Rotation
    case Animation
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
            case LoadingType.Rotation :
                /* Using single image to roate */
                var loadingImg = UIImageView(image: UIImage(named: "loading.png"))
                var rotation = RotationController(view: loadView, image: loadingImg, frame: CGRectMake(loadView.bounds.width * 0.5 - 10.0, loadView.bounds.height * 0.5 - 10.0 - 44, 20.0, 20.0))
                rotation.setup()
                rotation.start()
               
            case LoadingType.Animation :
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
