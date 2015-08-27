//
//  SlideImage.swift
//  BehaviorUIKit
//
//  Created by Chan Youvita on 8/4/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit

class SlideImage: UIView,UIScrollViewDelegate{
    var scrollView          : UIScrollView?
    var tagetView           : UIView?
    var images              : NSArray?
    var imageView           : UIImageView?
    var page                : UILabel?
    var background          : UIColor?
    var contentSizePage     : NSMutableArray?
    var mergingX            : CGFloat?
    var mergingW            : CGFloat?
    var currentPage         : CGFloat = 0.0
    var numberPage          : Int = 1
    var pageFooter          : Bool = false
    var imageMerging        : Bool = false {
        didSet{
            if imageMerging {
                mergingX = 2.0
                mergingW = 4.0
            }else{
                mergingX = 0.0
                mergingW = 0.0
            }
        }
    }
    
    init(frame: CGRect,scrollView:UIScrollView,images:NSArray,tagetView:UIView,backgroudScrollView:UIColor,merging:Bool,hidePageFooter:Bool) {
        super.init(frame: frame)
        self.scrollView     = scrollView
        self.tagetView      = tagetView
        self.images         = images
        self.pageFooter     = hidePageFooter
        self.background     = backgroudScrollView
        self.scrollView?.delegate = self
        self.setUpScrollView(merging)
       
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func attactToScrollView(scrollView:UIScrollView,images:NSArray,tagetView:UIView,backgroudScrollView:UIColor,merging:Bool,hidePageFooter:Bool)->SlideImage{
        var scrollControl = SlideImage(frame: CGRectMake(0.0, 0.0, scrollView.frame.size.width, 0.0)
            , scrollView: scrollView,images: images,tagetView: tagetView,backgroudScrollView: backgroudScrollView,merging: merging,hidePageFooter: hidePageFooter)
        
        scrollView.addSubview(scrollControl)
        return scrollControl
    }
    
    func setUpScrollView(merging:Bool){
        self.tagetView!.addSubview(self.scrollView!)
        self.imageMerging                   = merging
        self.scrollView!.backgroundColor    = self.background
        self.contentSizePage                = NSMutableArray()
        var urlImages = NSMutableArray()
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.value), 0)){
            /* do background */
            
            var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            indicator.center = self.scrollView!.center
            indicator.startAnimating()
            self.tagetView?.addSubview(indicator)
            
            for var i = 0;i < self.images?.count; i++ {
                var urlImage = NSURL(string: self.images?.objectAtIndex(i) as! String)
                var data = NSData(contentsOfURL: urlImage!)
                var image = UIImage(data: data!)
                urlImages.addObject(image!)
            }
            
            dispatch_async(dispatch_get_main_queue()){
                /* completed background */
                for var i = 0;i < self.images?.count; i++ {
                    self.imageView = UIImageView(image: urlImages[i] as! UIImage)
                    self.imageView?.frame = CGRectMake(self.scrollView!.frame.size.width * CGFloat(i) + self.mergingX!, 0, self.scrollView!.frame.width - self.mergingW!, self.scrollView!.frame.height)
                    self.scrollView?.addSubview(self.imageView!)
                    self.contentSizePage?.addObject(self.scrollView!.frame.size.width * CGFloat(i)) // add all page size
                }
                
                self.scrollView?.pagingEnabled = true
                self.scrollView?.showsHorizontalScrollIndicator = false
                self.scrollView?.showsVerticalScrollIndicator = false
                self.scrollView?.contentSize = CGSizeMake(self.scrollView!.frame.size.width * CGFloat(self.images!.count), self.scrollView!.frame.size.height)
                self.addFooterPageNumber()
                indicator.stopAnimating()
            }

        }
        
    }
    
    func addFooterPageNumber(){
        page = UILabel(frame: CGRectMake(self.scrollView!.frame.origin.x + self.scrollView!.frame.width - 65, self.scrollView!.frame.origin.y + self.scrollView!.frame.height - 25, 100.0, 20.0))
        page?.hidden = self.pageFooter
        page?.text = "Page:\(numberPage)/\(images!.count)"
        page?.font = UIFont.boldSystemFontOfSize(12.0)
        page?.textColor = UIColor.whiteColor()
        self.tagetView!.addSubview(page!)
    }
    
    func updatePageNumber(){
        page?.text = "Page:\(numberPage)/\(images!.count)"
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("\(scrollView.contentOffset.x)")
        for var i = 0;i < self.contentSizePage?.count; i++ {
            if self.scrollView?.contentOffset.x > currentPage {
                /* Right */
                if self.scrollView?.contentOffset.x == self.contentSizePage?.objectAtIndex(i) as? CGFloat {
                    if self.scrollView?.contentOffset.x != currentPage{
                        numberPage++
                        currentPage = self.contentSizePage?.objectAtIndex(i) as! CGFloat
                        self.updatePageNumber()
                        println("page number:\(numberPage)")
                        println("right")
                    }
                }
            }else{
                /* Left */
                if self.scrollView?.contentOffset.x == self.contentSizePage?.objectAtIndex(i) as? CGFloat {
                    if self.scrollView?.contentOffset.x != currentPage {
                        numberPage--
                        currentPage = self.contentSizePage?.objectAtIndex(i) as! CGFloat
                        self.updatePageNumber()
                        println("page number:\(numberPage)")
                        println("left")
                    }
                    
                }
            }
        }// end for loop
    }
    
}
