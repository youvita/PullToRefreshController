//
//  ViewComponent.swift
//  BehaviorUIKit
//
//  Created by Chan Youvita on 7/14/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit

class ViewComponent: UIView {

    var button : UIButton?
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        button = UIButton(frame: CGRectMake(0, 0, 30, 25))
        button?.layer.cornerRadius = 2.0
        button?.backgroundColor = UIColor.brownColor()
        self.addSubview(button!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
