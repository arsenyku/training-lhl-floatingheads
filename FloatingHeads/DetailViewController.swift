//
//  DetailViewController.swift
//  ZoomingIconsMenu
//
//  Created by asu on 2015-10-01.
//  Copyright © 2015 asu. All rights reserved.
//

import UIKit

class DetailViewController:UIViewController, ZoomingIconViewController{
    
    @IBOutlet weak var backgroundColourView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var centreImage:UIImage?
    
    @IBAction func backButton(sender: UIButton) {
		navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        iconImageView.layer.cornerRadius = iconImageView.frame.size.width / 2
        iconImageView.layer.masksToBounds = true
        iconImageView.image = centreImage

    }
    
    // MARK: ZoomingIconViewController
    
    func zoomingIconBackgroundColourViewForTransition(transition: ZoomingIconTransition) -> UIView? {
        return backgroundColourView
    }
    func zoomingIconImageViewForTransition(transition: ZoomingIconTransition) -> UIImageView? {
        return iconImageView
    }

}
