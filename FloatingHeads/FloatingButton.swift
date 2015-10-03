//
//  FloatingButton.swift
//  FloatingHeads
//
//  Created by asu on 2015-09-30.
//  Copyright © 2015 asu. All rights reserved.
//

import UIKit

class FloatingButton: UIButton {
    
    var backgroundColourView = UIImageView()
    var imageViewForZoom = UIImageView()
    
	// Initializer that takes in a frame, UIImage, and backgroundColor.
   	init(frame:CGRect, image:UIImage, backgroundColour:UIColor) {
        backgroundColourView.userInteractionEnabled = false
        backgroundColourView.image = backgroundColour.pixelImage()
        backgroundColourView.backgroundColor = backgroundColour

        
        imageViewForZoom = UIImageView(image: image)
        imageViewForZoom.userInteractionEnabled = false

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
    
        tintColor = UIColor.whiteColor()
        
        backgroundColourView.frame = self.frame
        backgroundColourView.layer.cornerRadius = backgroundColourView.frame.size.width / 2
        backgroundColourView.layer.masksToBounds = true
        
        imageViewForZoom.frame = imageView!.frame
        imageViewForZoom.layer.cornerRadius = imageViewForZoom.frame.size.width / 2
        imageViewForZoom.layer.masksToBounds = true

        insertSubview(backgroundColourView, belowSubview:imageView!)
        insertSubview(imageViewForZoom, belowSubview:imageView!)
        
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true

    }
    
    func zoomProperties() -> (imageView:UIImageView, backgroundColourView:UIView){
    	return (imageViewForZoom, self.backgroundColourView)
    }
}