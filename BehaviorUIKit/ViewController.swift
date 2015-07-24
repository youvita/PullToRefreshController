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
    
    @IBOutlet var tableView: UITableView!
    
    
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
        
//        /* Calling Loading */
//        LoadingController.loadingView(self.view,loadType: LoadingType.Rotation)
//        let delay = 3.0 * Double(NSEC_PER_SEC)
//        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//        dispatch_after(time, dispatch_get_main_queue()){
//            LoadingController.removeLoadingView(self.view)
//        }
        
        pullToRefresh = PullToRefreshController.attactToTableView(self.tableView,
            imagesArray: ["load_01.png","load_02.png","load_03.png","load_04.png","load_05.png","load_06.png"],
            imageType: ImageType.MultiImages)
        
        /* Calling push to refresh handle event */
        pullToRefresh!.refreshHandle(usingBlock: { () -> Void in
            // reques here
            let delay = 5.0 * Double(NSEC_PER_SEC)
            let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()){
                self.addItems()
            }
        })
    
    }
    
    //MARK: - ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        pullToRefresh?.pullScrollViewDidScroll()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pullToRefresh?.pullScrollViewDidEndDragging()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pullToRefresh?.pullScrollViewWillBeginDragging()
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

