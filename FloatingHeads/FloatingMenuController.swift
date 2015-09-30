//
//  FloatingMenuController.swift
//  FloatingHeads
//
//  Created by asu on 2015-09-30.
//  Copyright © 2015 asu. All rights reserved.
//

import UIKit

class FloatingMenuController: UIViewController {
    
    // In FloatingMenuController, add a UIView property called fromView, this 
    // will store the view (button) that triggered the menu and be used for 
    // animations later on.
    var fromView:UIView!
    
    //Add a UIVisualEffectView, called blurredView, that sets a UIBlurEffect
    var blurredView: UIVisualEffectView!
    
    //Add a FloatingButton, called closeButton, and pass in the image “icon-close” 
    //and flatRedColor for the background colour.
    var closeButton:FloatingButton
    
    required init?(coder aDecoder: NSCoder) {
        self.fromView = nil
        self.blurredView = nil;
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
        
        modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
    }
    
    
    override func viewDidLoad() {
        //set the blurredView’s frame to the view’s frame
        blurredView.frame = view.frame
        
        closeButton.addTarget(self, action: "closeButtonPressed:", forControlEvents: .TouchUpInside)

        //add the blurredView and closeButton as subviews of the root view
        view.addSubview(blurredView)
        view.addSubview(closeButton)
        


    }

    override func viewWillAppear(animated: Bool) {
        configureButtons()
    }
    
    //position the closeButton.center to be equal to the center of the fromView
    func configureButtons(){
        closeButton.center = fromView.center
    }
    
    func closeButtonPressed(sender:FloatingButton!){
        dismissViewControllerAnimated(true) { () -> Void in
            	
        }
    }

}













