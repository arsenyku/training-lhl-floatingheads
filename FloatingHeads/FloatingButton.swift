//
//  FloatingButton.swift
//  FloatingHeads
//
//  Created by asu on 2015-09-30.
//  Copyright © 2015 asu. All rights reserved.
//

import UIKit

class FloatingButton: UIButton {
    
	// Initializer that takes in a frame, UIImage, and backgroundColor.
   	init(frame:CGRect, image:UIImage, backgroundColour:UIColor) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup(){
    
    	//Set the tintColor to whiteColor()
        tintColor = UIColor.whiteColor()
        
	    //Set the backgroundColor to flatBlueColor()
    	backgroundColor = UIColor.flatBlueColor()

        //Set the button’s layer cornerRadius and maskToBounds
    	layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
        
		setBackgroundImage(backgroundColor!.pixelImage(), forState: UIControlState.Normal)
    }
}