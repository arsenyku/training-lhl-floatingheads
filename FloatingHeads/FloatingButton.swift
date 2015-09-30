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

        setImage(image, forState: UIControlState.Normal)
        setBackgroundImage(backgroundColour.pixelImage(), forState: UIControlState.Normal)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        //Set the backgroundColor to flatBlueColor()
        backgroundColor = UIColor.flatBlueColor()
        setBackgroundImage(backgroundColor!.pixelImage(), forState: UIControlState.Normal)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup(){
    
    	//Set the tintColor to whiteColor()
        tintColor = UIColor.whiteColor()
        
        //Set the button’s layer cornerRadius and maskToBounds
    	layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
        
    }
}