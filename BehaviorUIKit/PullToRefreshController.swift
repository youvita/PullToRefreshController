//
//  PullToRefreshController.swift
//  BehaviorUIKit
//
//  Created by Chan Youvita on 7/17/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//
/* Pull to refresh of UITableViewController */

import UIKit

private let REFRESH_HEADER_HEIGHT : CGFloat = 52.0

public enum ImageType {
    case SingleImage // Single Image
    case MultiImages // Multi Images
}

public class PullToRefreshController: UIView {
    var scrollView          : UIScrollView?
    var headerView          : UIView?
    var iconImage           : UIImageView?
    var imageNames          : NSArray?
    var imagePostion        : CGRect?
    var refresh             : (()->Void)?
    var isLoading           : Bool      = false
    var isDefault           : Bool      = false
    var valueImg            : CGFloat   = 20
    var indexImg            : Int       = 0
    var typeImage           : ImageType?
    var rotateControl       : RotationController?
    var gravityBehavior     : UIGravityBehavior?
    var collisionBehavior   : UICollisionBehavior?
    var itemBehavior        : UIDynamicItemBehavior?
    var animator            : UIDynamicAnimator?
    
    init(frame: CGRect,scrollView:UIScrollView,imageArray:NSArray,imageType:ImageType) {
        super.init(frame: frame)
        self.scrollView = scrollView
        self.imageNames = imageArray
        self.addPllToRefreshHeader(imageType)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func attactToTableView(tableView:UITableView,imagesArray:NSArray,imageType:ImageType)->PullToRefreshController {
        return self.attactToScrollView(tableView,imageArray: imagesArray,imageType: imageType)
    }
    
    class func attactToScrollView(scrollView:UIScrollView,imageArray:NSArray,imageType:ImageType)->PullToRefreshController{
        var existingRefresh = self.findRefreshControlInScrollView(scrollView)
        if (existingRefresh != nil) {
            return existingRefresh!
        }
        
        /* Initialized height to 0 to hide it */
        var refreshControl = PullToRefreshController(frame: CGRectMake(0.0, 0.0, scrollView.frame.size.width, 0.0)
            , scrollView: scrollView,imageArray: imageArray,imageType:imageType)
        
        scrollView.addSubview(refreshControl)
        return refreshControl
    }
    
    class func findRefreshControlInScrollView(scrollView:UIScrollView)->PullToRefreshController?{
        for subview in scrollView.subviews {
            if subview.isKindOfClass(PullToRefreshController){
                return subview as? PullToRefreshController
            }
        }
        return nil
    }
    
    // MARK: - PullToRefreshHeader
    func addPllToRefreshHeader(typeImage:ImageType){
        headerView = UIView(frame: CGRectMake(0, 0 - 45.0, UIScreen.mainScreen().bounds.width, 45.0))
        headerView?.backgroundColor = UIColor.clearColor()
        imagePostion = CGRectMake(headerView!.frame.width * 0.5 - 10.0, 15.0, 20.0, 20.0)
        iconImage = UIImageView(image: UIImage(named: imageNames!.objectAtIndex(0) as! String))
        
        self.addSubview(headerView!)
        switch typeImage {
           
            case .MultiImages :
                /* Loading multi images with animation */
                var images = NSMutableArray()
                for var i = 0 ; i<self.imageNames?.count ; i++ {
                    images.addObject(UIImage(named: self.imageNames!.objectAtIndex(i) as! String)!)
                }
                
                self.iconImage?.frame = imagePostion!
                self.iconImage?.animationImages = images as [AnyObject]
                self.iconImage?.animationDuration = 1.0
                self.headerView?.addSubview(iconImage!)
                isDefault = false
            
            default :
                /* Loading single image animation */
                /* kind of image icon refresh */
            
                rotateControl = RotationController(view: headerView!,
                    image: iconImage!,
                    frame: imagePostion!,
                    speed: 0.7)
                rotateControl?.setup()
                
                /* set animate to view */
                self.animator = UIDynamicAnimator(referenceView:headerView!)
                self.gravityBehavior = UIGravityBehavior(items: [iconImage!])
                
                /* set collision for icon image */
                self.collisionBehavior = UICollisionBehavior(items: [iconImage!])
                self.collisionBehavior?.translatesReferenceBoundsIntoBoundary = true
                
                /* set icon image boune */
                self.itemBehavior = UIDynamicItemBehavior(items: [iconImage!])
                self.itemBehavior?.elasticity = 1.0
                self.itemBehavior?.allowsRotation = false
                isDefault = true
            }
    }
    
    
    // MARK: - ScrollViewDelegate
    public func pullScrollViewDidScroll() {
        /* Using for multi images animation */
            if !isDefault {
                if self.scrollView!.contentOffset.y < -valueImg {
                    indexImg++
                    valueImg += 5
                    self.iconImage?.image = UIImage(named: "load_0" + "\(indexImg)" + ".png")
                    
                    /* reset loading when last image */
                    if indexImg == imageNames?.count {
                        indexImg = 0
                        valueImg -= 5
                    }
                }else{
                    if indexImg > 0 {
                        /* make back loading */
                        indexImg--
                        valueImg -= 5
                    }else{
                        /* back loading when first image */
                        indexImg = imageNames!.count
                        valueImg += 5
                    }
                }
            }
        
    }
   
    public func pullScrollViewWillBeginDragging() {
        if isLoading { return }
        
        if isDefault {
            /* set behavior to icon image */
            self.animator?.addBehavior(self.gravityBehavior)
            self.animator?.addBehavior(self.collisionBehavior)
            self.animator?.addBehavior(self.itemBehavior)
        }else{
            self.resetScrollViewValue()
        }
        
    }
    
    public func pullScrollViewDidEndDragging() {
        if isLoading { return }
        
        if self.scrollView!.contentOffset.y <= -REFRESH_HEADER_HEIGHT {
            self.startLoading()
            if isDefault {
                self.rotateControl?.start() // start rotation icon image
                self.rotateControl?.rotationImage?.frame = imagePostion!
                self.animator?.removeAllBehaviors()
            }else{
                self.iconImage?.startAnimating()
            }
        }
    
    }
    
    func startLoading(){
        isLoading = true
        UIView.animateWithDuration(0.3, animations: {
            self.scrollView!.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0)
        })
        self.refresh!()
    }
    
    func stopLoading(){
        isLoading = false
        self.scrollView!.contentInset = UIEdgeInsetsZero
        if isDefault {
            self.rotateControl?.stop()
        }else{
            self.iconImage?.stopAnimating()
        }
    }
    
    /* Method block */
    func refreshHandle(usingBlock block:(()->Void)!){
        self.refresh = block
    }
    
    /* Clear value of multi images animation */
    func resetScrollViewValue(){
        self.indexImg = 0
        self.valueImg = 20
    }
    
    
}
