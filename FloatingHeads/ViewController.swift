//
//  ViewController.swift
//  FloatingHeads
//
//  Created by asu on 2015-09-30.
//  Copyright © 2015 asu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func handleMenuButton(sender: AnyObject) {
        
        let floatingMenu = FloatingMenuController(fromView: sender as! UIButton)

        floatingMenu.buttonPadding = 5
        
        for i in 4...8 {
            let floater = FloatingButton(frame: CGRectMake(0,0,60,60),
                image: UIImage(named: "model-00\(i)")!, backgroundColour: UIColor.purpleColor())
			floatingMenu.floatingButtons .append(floater)
        }
        
        presentViewController(floatingMenu, animated: true, completion: nil)
    }
    
}

