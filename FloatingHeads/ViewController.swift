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
        let controller = FloatingMenuController(fromView: sender as! UIButton)
        presentViewController(controller, animated: true, completion: nil)
    }
    
}

