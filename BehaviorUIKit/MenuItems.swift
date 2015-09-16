//
//  MenuItems.swift
//  BehaviorUIKit
//
//  Created by Chan Youvita on 8/31/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit

typealias MenuItemAction = (MenuItems) -> Void

class MenuItems: UIView {
    /// View that will hold the item's button and label
    internal var view: UIView!
    
    /// Label that contain the item's *text*
    private var label: UILabel!
    
    /// Main button that will perform the defined action
    private var button: UIButton!
    
    /// Image used by the button
    private var image: UIImage!
    
    /// Size needed for the *view* property presente the item's content
    private let viewSize = CGSize(width: 200, height: 35)
    
    /// Button's size by default the button is 35x35
    private let buttonSize = CGSize(width: 35, height: 35)

    var labelBackground: UIView!
    let backgroundInset = CGSize(width: 10, height: 10)
    internal var isRL : Bool = false {
        didSet{
            if !isNoneTitle {
                if isRL {
                    self.labelBackground.frame.origin.x = CGFloat(150 - self.label.frame.size.width)
                }else{
                    self.labelBackground.frame.origin.x = CGFloat(self.button.frame.origin.x + 40)
                }
            }
        }
    }
    
    var text: String {
        get {
            return self.label.text!
        }
        
        set {
            self.label.text = newValue
        }
    }
    
    var isNoneTitle : Bool = false

    var action: MenuItemAction?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(title optionalTitle: String?, image: UIImage?){
        self.init()
        self.view = UIView(frame: CGRect(origin: CGPointZero, size: self.viewSize))
        self.view.alpha = 0
        self.view.userInteractionEnabled = true
        self.view.backgroundColor = UIColor.clearColor()
        
        self.button = UIButton.buttonWithType(.Custom) as! UIButton
        self.button.frame = CGRect(origin: CGPoint(x: self.viewSize.width - self.buttonSize.width, y: 0), size: buttonSize)
        self.button.layer.shadowOpacity = 1
        self.button.layer.shadowRadius = 2
        self.button.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.button.layer.shadowColor = UIColor.grayColor().CGColor
        self.button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        
        if let unwrappedImage = image {
            self.button.setImage(unwrappedImage, forState: .Normal)
        }
        
        if let text = optionalTitle where text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty == false {
            self.label = UILabel()
            self.label.font = UIFont(name: "HelveticaNeue-Medium", size: 13)
            self.label.textColor = UIColor.darkGrayColor()
            self.label.textAlignment = .Right
            self.label.text = text
            self.label.sizeToFit()
            
            self.labelBackground = UIView()
            self.labelBackground.frame = self.label.frame
            self.labelBackground.backgroundColor = UIColor.whiteColor()
            self.labelBackground.layer.cornerRadius = 3
            self.labelBackground.layer.shadowOpacity = 0.8
            self.labelBackground.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.labelBackground.layer.shadowRadius = 0.2
            self.labelBackground.layer.shadowColor = UIColor.lightGrayColor().CGColor
            
            // Adjust the label's background inset
            self.labelBackground.frame.size.width = self.label.frame.size.width + backgroundInset.width
            self.labelBackground.frame.size.height = self.label.frame.size.height + backgroundInset.height
            self.label.frame.origin.x = self.label.frame.origin.x + backgroundInset.width / 2
            self.label.frame.origin.y = self.label.frame.origin.y + backgroundInset.height / 2
            
            self.labelBackground.center.y = self.view.center.y
            self.labelBackground.addSubview(self.label)
            
            self.view.addSubview(self.labelBackground)
            
        }else{
            self.isNoneTitle = true
        }
        self.view.addSubview(self.button)
    }
    
    //MARK: - Button Action Methods
    func buttonPressed(sender: UIButton) {
        if let unwrappedAction = self.action {
            unwrappedAction(self)
        }
    }
    
}
