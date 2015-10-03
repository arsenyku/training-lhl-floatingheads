//
//  FloatingMenuController.swift
//  FloatingHeads
//
//  Created by asu on 2015-09-30.
//  Copyright © 2015 asu. All rights reserved.
//

import UIKit


enum Direction {
    case Up
    case Down
    case Left
    case Right
    
    
    func offsetPoint(point: CGPoint, offset: CGFloat) -> CGPoint {
        switch self {
        case .Up:
            return CGPoint(x: point.x, y: point.y - offset)
        case .Down:
            return CGPoint(x: point.x, y: point.y + offset)
        case .Left:
            return CGPoint(x: point.x - offset, y: point.y)
        case .Right:
            return CGPoint(x: point.x + offset, y: point.y)
        }
    }
}

protocol FloatingMenuDelegate {
    func floatingCancelButtonPressed(sender: FloatingButton?)
    func floatingMenuButtonPressed(sender: FloatingButton?, index:Int)
}

class FloatingMenuController: UIViewController {
    
    // In FloatingMenuController, add a UIView property called fromView, this 
    // will store the view (button) that triggered the menu and be used for 
    // animations later on.
    var fromView:UIView!
    
    //Add a UIVisualEffectView, called blurredView, that sets a UIBlurEffect
    var blurredView: UIVisualEffectView?
    
    //Add a FloatingButton, called closeButton, and pass in the image “icon-close” 
    //and flatRedColor for the background colour.
    var closeButton:FloatingButton

    //a button direction, with a default value of Direction.Up
    var menuDirection: Direction = Direction.Up
    
    //a CGFloat for buttonPadding
    var buttonPadding:CGFloat = 10
    
    //an array, buttonItems, to store all your UIButtons
    var floatingButtons = [FloatingButton]()
    
    var delegate: FloatingMenuDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        self.fromView = nil
        self.blurredView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light));
        self.closeButton = FloatingButton(frame: CGRectMake(0,0,100,100),
            image: UIImage(named: "icon-close")!,
            backgroundColour: UIColor.flatRedColor());
        
        super.init(coder: aDecoder)
    }
    
	//Custom initializer
    //Takes in a UIView element, this is our fromView
    //Calls its superclass' initWithNibName:bundle and sets both to nil (our view controller doesn't have a xib or a storyboard).
    //Sets the View Controller’s modalPresentationStyle and modalTransitionStyle
    init(fromView:UIView){
        self.fromView = fromView
        blurredView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light));
        closeButton = FloatingButton(frame: fromView.frame,
            image: UIImage(named: "icon-close")!,
            backgroundColour: UIColor.flatRedColor());
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = UIModalPresentationStyle.Custom
        modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
    }
    
    
    override func viewDidLoad() {

        if (blurredView != nil){
	        view.addSubview(blurredView!)
        }
        
        for (_, floater) in floatingButtons.reverse().enumerate() {
            view.addSubview(floater)
            floater.addTarget(self, action: "menuButtonPressed:", forControlEvents: .TouchUpInside)
        }
        
        //set the blurredView’s frame to the view’s frame
        blurredView?.frame = view.frame
        
        closeButton.addTarget(self, action: "closeButtonPressed:", forControlEvents: .TouchUpInside)
        closeButton.center = fromView.center

        view.addSubview(closeButton)

    }

    override func viewWillAppear(animated: Bool) {
        if (animated){
            configureButtons(initial: true)
            UIView.animateWithDuration(1.0) { () -> Void in
                self.configureButtons(initial:false)
                
            }
        }else{
        	self.configureButtons(initial:false)
        }
    }


    
    //position the closeButton.center to be equal to the center of the fromView
    func configureButtons(initial initial:Bool){
        if initial {
            closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
            
            for (_, floater) in floatingButtons.enumerate() {
                floater.center = fromView.center
            }
        }
        else {
            closeButton.transform = CGAffineTransformIdentity
        
            var previousButton = fromView
            for (index, floater) in floatingButtons.enumerate() {
                
                var offset:CGFloat = 0
                switch(menuDirection){
                case Direction.Up, Direction.Down:
                    offset = previousButton.frame.size.height
                case Direction.Left, Direction.Right:
                    offset = previousButton.frame.size.width
                }
                
                floater.center = menuDirection.offsetPoint(previousButton.center, offset: offset+buttonPadding * CGFloat(index+1))
                previousButton = floater
            }

        }
    }
    
    func closeButtonPressed(sender:FloatingButton!){
        delegate?.floatingCancelButtonPressed(sender)
        
     	dismiss()
        
        
    }
    
    func menuButtonPressed(sender:FloatingButton!){
        if let index = floatingButtons.indexOf(sender) {
            delegate?.floatingMenuButtonPressed(sender, index: index)
        }
    }
    
    func dismiss(){
        configureButtons(initial: false)
        
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            self.configureButtons(initial:true)
            
            }) { (Bool) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}













