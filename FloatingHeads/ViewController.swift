//
//  ViewController.swift
//  FloatingHeads
//
//  Created by asu on 2015-09-30.
//  Copyright © 2015 asu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FloatingMenuDelegate, ZoomingIconViewController {

    var buttonForTransition:FloatingButton?
    var floatingMenu:FloatingMenuController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func handleMenuButton(sender: AnyObject) {
        
        floatingMenu = FloatingMenuController(fromView: sender as! UIButton)
  
        floatingMenu!.menuDirection = Direction.Up
        floatingMenu!.buttonPadding = 5
        floatingMenu!.blurredView = nil
        
        for i in 4...8 {
            let image = UIImage(named: "model-00\(i)")!

            let floater = FloatingButton(frame: CGRectMake(0,0,60,60),
                image: image, backgroundColour: UIColor(red: 164.0/255.0, green: 205.0/255.0, blue: 255/255.0, alpha: 1.0))
			floatingMenu!.floatingButtons .append(floater)
        }
        
        floatingMenu!.delegate = self
        
        presentViewController(floatingMenu!, animated: true, completion: nil)
    }
    
    func floatingCancelButtonPressed(sender: FloatingButton?) {
        print("CANCEL!")
    }
    
    func floatingMenuButtonPressed(sender: FloatingButton?, index:Int) {
        print("MENU! Index=\(index)")

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            floatingMenu?.dismiss()
        }

        self.performTransition(sender!)
    }
    
	    
    func performTransition(button:FloatingButton) {
        let controller = UIStoryboard(name: "DetailView", bundle: nil)
            .instantiateViewControllerWithIdentifier("detailViewController")
            as! DetailViewController
        
        buttonForTransition = button
      	controller.centreImage = button.imageView?.image
        

        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func zoomingIconBackgroundColourViewForTransition(transition: ZoomingIconTransition) -> UIView? {
        let result = buttonForTransition?.zoomProperties().backgroundColourView
        return result
    }
    func zoomingIconImageViewForTransition(transition: ZoomingIconTransition) -> UIImageView? {
        return buttonForTransition?.zoomProperties().imageView
    }

}

