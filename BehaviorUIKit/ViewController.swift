//
//  ViewController.swift
//  BehaviorUIKit
//
//  Created by Chan Youvita on 7/10/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var arrItems        : NSMutableArray?
    var menuTranform    : MenuTranform?
    var pullToRefresh   : PullToRefreshController?
    var effectButton    : EffectButton?
    var slideImage      : SlideImage?
    var slideCollection : SlideCollectionView?
    var codeButton      : UIButton?
    var cellArray       : NSMutableArray?
    var arrImages       : NSArray?
    var arrImagesUrl    : NSArray?
    
    
    @IBOutlet weak var onTopTableView: NSLayoutConstraint!
    @IBOutlet weak var viewCollection: UIView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrImages = [
            "http://www.planwallpaper.com/static/images/background-wallpapers-32.jpg",
            "http://www.planwallpaper.com/static/images/824183-green-wallpaper.jpg"]
        
        arrItems = NSMutableArray()
        for i in 1...3 {
            arrItems?.addObject("Item\(i)")
        }
        #if _DEBUG_
            println("debug")
        #endif
        
        ////////////////////////////////////////////////////////////////////////////////////////
        /* Using Slide Image Collection View */
        onTopTableView.constant = 0 // to hide collection view
        arrImagesUrl = ["http://www.planwallpaper.com/static/images/fresh-green-background.jpg",
            "http://www.planwallpaper.com/static/images/background-wallpapers-32.jpg",
            ""]

        slideCollection = SlideCollectionView(tagetView: self.viewCollection)
        slideCollection?.onHideCollectionView(usingBlock: { () -> Void in
            self.onTopTableView.constant = 0
        })
        ////////////////////////////////////////////////////////////////////////////////////////
        
//        menuTranform = MenuTranform(size: self.view, frame: CGRectMake(2, self.view.frame.height / 2, 60, 60))
//        menuTranform?.enable()
//        menuTranform?.tapGestureHandle(usingBlock: {(isTap) -> Void in
//            if isTap {
////                self.rotateControl?.stop()
//            }else{
////                self.rotateControl?.start()
//            }
//        })
//        var object = PullToRefreshController()
//        object.delegate = self
        
        var heardView = UIView(frame:CGRectMake(0, 0, self.view.frame.size.width, 161))
        self.tableView.tableHeaderView = heardView
        
        var lindeView = UIView(frame: CGRectMake(0, heardView.frame.height, self.view.frame.size.width, 1))
        lindeView.backgroundColor = UIColor.grayColor()
        heardView.addSubview(lindeView)
        
        var scrollView = UIScrollView(frame: CGRectMake(self.view.frame.origin.x + 10, 10, self.view.frame.size.width - 20, 150))
        slideImage = SlideImage.attactToScrollView(scrollView,images: arrImages!,
            tagetView: heardView,
            backgroudScrollView: UIColor.grayColor(),
            merging: true,
            hidePageFooter: false)

       
        
        // Using button code builder
        codeButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 40.0 - 20.0, UIScreen.mainScreen().bounds.height - 40.0 - 100, 40.0, 45.0))
        codeButton?.setTitle("TOP", forState: UIControlState.Normal)
        codeButton?.layer.cornerRadius = 10.0
        codeButton?.backgroundColor = UIColor.brownColor()

        // Using button design builder
        self.button.layer.cornerRadius = 10.0
//        self.button.hidden = true
//        self.button.addTarget(self, action: "Clicked", forControlEvents: UIControlEvents.TouchUpInside)
        effectButton = EffectButton.attactToTableView(self.tableView, buttonView: self.button,tagetView: self.view,styleView: Styles.Zoom)
        self.view.addSubview(effectButton!)
        effectButton?.onClickHandle(UsingBlock: {() -> Void in
            println("Yes")
            self.tableView.contentOffset = CGPointZero
//            self.codeButton!.hidden = true
        })
        
        /* Calling Loading */
//        LoadingController.loadingView(self.view,loadType: LoadingType.Animation)
//        let delay = 3.0 * Double(NSEC_PER_SEC)
//        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//        dispatch_after(time, dispatch_get_main_queue()){
//            LoadingController.removeLoadingView(self.view)
//        }
        
//        pullToRefresh = PullToRefreshController.attactToTableView(self.tableView,
//            imagesArray: ["icon_refresh.png"],
//            imageType: ImageType.SingleImage)

        pullToRefresh = PullToRefreshController.attactToTableView(self.tableView,
            imagesArray: ["load_01.png","load_02.png","load_03.png","load_04.png","load_05.png","load_06.png"],
            imageType: ImageType.MultiImages)
        
        /* Calling push to refresh handle event */
        pullToRefresh!.refreshHandle(usingBlock: { () -> Void in
            // reques here
            let delay = 3.0 * Double(NSEC_PER_SEC)
            let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()){
                self.addItems()
            }
        })
    
    }
    
//    func Clicked(){
//        println("Yes")
//    }
    
    //MARK: - ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        pullToRefresh?.pullScrollViewDidScroll()
        effectButton?.scrollViewDidScroll()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pullToRefresh?.pullScrollViewDidEndDragging()
        effectButton?.scrollViewDidEndDragging()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pullToRefresh?.pullScrollViewWillBeginDragging()
        effectButton?.scrollViewWillBeginDragging()
        codeButton?.hidden = false
    }
    
    
    //MARK: - TableViewDelegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = arrItems!.objectAtIndex(indexPath.row) as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems!.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        slideCollection!.addItemSelected(arrImagesUrl!.objectAtIndex(indexPath.row) as! NSString)
        onTopTableView.constant = 59
    }
    
    func addItems(){
        arrItems?.addObject("Pull To Refresh")
        self.tableView.reloadData()
        self.pullToRefresh!.stopLoading()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

