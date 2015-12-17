/**
* @name             DetailsViewController.swift
* @partof           zucred AG
* @description
* @author	 		Vasco Mouta
* @created			15/12/15
*
* Copyright (c) 2015 zucred AG All rights reserved.
* This material, including documentation and any related
* computer programs, is protected by copyright controlled by
* zucred AG. All rights are reserved. Copying,
* including reproducing, storing, adapting or translating, any
* or all of this material requires the prior written consent of
* zucred AG. This material also contains confidential
* information which may not be disclosed to others without the
* prior written consent of zucred AG.
*/

import UIKit

class DetailsViewController: UIViewController {
    
    @IBAction func doneButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
