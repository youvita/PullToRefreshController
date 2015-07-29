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
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrItems = NSMutableArray()
        
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
        
        for i in 1...20 {
            arrItems?.addObject("Item\(i)")
        }
        #if _DEBUG_
            println("debug")
        #endif
        
//        var button = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 40.0 - 20.0, UIScreen.mainScreen().bounds.height - 40.0 - 100, 40.0, 45.0))
//        button.setTitle("TOP", forState: UIControlState.Normal)
//        button.backgroundColor = UIColor.brownColor()

       
        effectButton = EffectButton.attactToTableView(self.tableView, buttonView: self.button,tagetView: self.view,styleView: Styles.Push)
        self.view.addSubview(effectButton!)
//        effectButton?.onClickHandle(UsingBlock: {() -> Void in
//            println("Yes")
//        })

        self.button.addTarget(self, action: "Clicked", forControlEvents: UIControlEvents.TouchUpInside)
        
        /* Calling Loading */
//        LoadingController.loadingView(self.view,loadType: LoadingType.Animation)
//        let delay = 3.0 * Double(NSEC_PER_SEC)
//        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//        dispatch_after(time, dispatch_get_main_queue()){
//            LoadingController.removeLoadingView(self.view)
//        }
        
//        pullToRefresh = PullToRefreshController.attactToTableView(self.tableView,
//            imagesArray: ["loading.png"],
//            imageType: ImageType.SingleImage)

        pullToRefresh = PullToRefreshController.attactToTableView(self.tableView,
            imagesArray: ["load_01.png","load_02.png","load_03.png","load_04.png","load_05.png","load_06.png"],
            imageType: ImageType.MultiImages)
        
//        /* Calling push to refresh handle event */
//        pullToRefresh!.refreshHandle(usingBlock: { () -> Void in
//            // reques here
//            let delay = 3.0 * Double(NSEC_PER_SEC)
//            let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//            dispatch_after(time, dispatch_get_main_queue()){
//                self.addItems()
//            }
//        })
    
    }
    
    func Clicked(){
        println("Yes")
    }
    
    //MARK: - ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        pullToRefresh?.pullScrollViewDidScroll()
        effectButton?.ScrollViewDidScroll()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pullToRefresh?.pullScrollViewDidEndDragging()
        effectButton?.ScrollViewDidEndDragging()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pullToRefresh?.pullScrollViewWillBeginDragging()
        effectButton?.ScrollViewWillBeginDragging()
    }
    
    //MARK: - TableViewDelegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = arrItems!.objectAtIndex(indexPath.row) as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems!.count
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

