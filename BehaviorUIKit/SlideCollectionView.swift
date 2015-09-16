//
//  SlideCollectionView.swift
//  BehaviorUIKit
//
//  Created by Chan Youvita on 8/25/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit

class SlideCollectionView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource{
    var mainView    : UIView?
    var urlImages   : NSMutableArray = NSMutableArray()
    var collectionView : UICollectionView?
    var handler : (()->Void)?
    
    init(tagetView: UIView) {
        super.init(frame: tagetView.frame)
        self.mainView   = tagetView
        self.setUpFrame()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpFrame(){
        var layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5.0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView = UICollectionView(frame: CGRectMake(10, 0, self.mainView!.bounds.width - 20, self.mainView!.bounds.height), collectionViewLayout: layout)
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        self.mainView?.addSubview(collectionView!)
    }
    
    func addItemSelected(items:NSString){
        urlImages.addObject(items)
        self.collectionView?.reloadData()
        self.autoScrollToLastItemIndex()
    }
    
    func getAllItemsSelected()-> NSArray {
        return urlImages
    }
    
    func removeItemSelected(sender:UIButton){
        urlImages.removeObjectAtIndex(sender.tag)
        self.collectionView?.reloadData()
        
        /* call closure method to hide collection view */
        if urlImages.count == 0{
            self.handler!()
        }
    }
    
    func autoScrollToLastItemIndex(){
        var item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
        var lastItemIndex = NSIndexPath(forItem: item, inSection: 0)
        self.collectionView?.scrollToItemAtIndexPath(lastItemIndex, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
    }
    
    func onHideCollectionView(usingBlock block:(()->Void)!){
        self.handler = block
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        /* remove collection view */
        for v in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        
        var objView = UIView(frame: cell.bounds)
        cell.contentView.addSubview(objView)
        
        /* Set Button Remove */
        var buttonRemove = UIButton(frame: CGRectMake(cell.frame.width - 20, 0, 20, 20))
        buttonRemove.tag = indexPath.item
        buttonRemove.setBackgroundImage(UIImage(named: "img_del_btn.png"), forState: UIControlState.Normal)
        buttonRemove.addTarget(self, action: "removeItemSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        
        /* Set ImageView */
        var url = NSURL(string: self.urlImages.objectAtIndex(indexPath.item) as! String)
        var objImage = UIImageView()
        objImage.frame = CGRectMake(cell.frame.width / 2 - 23, cell.frame.height / 2 - 23, 46, 46)
        objImage.layer.masksToBounds = true
        objImage.layer.cornerRadius = objImage.frame.size.width / 2
        objView.addSubview(objImage)

        if urlImages.objectAtIndex(indexPath.item) as! String == ""{
            objImage.image = UIImage(named: "person_icon.png")
            objView.addSubview(buttonRemove)
        }else{
            objImage.sd_setImageWithURL(url, completed: { (img :UIImage!, err :NSError!, cache :SDImageCacheType, url:NSURL!) -> Void in
                objView.addSubview(buttonRemove)
            })
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlImages.count
    }
}
