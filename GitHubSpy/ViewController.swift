/**
 * @name            ViewController.swift
 * @partof          GitHubSpy
 * @description
 * @author	 		Vasco Mouta
 * @created			17/12/15
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

class ViewController: UIViewController {
    
    static let BaseUrl = "https://api.github.com/"
    static let OrgsUrlPath = "orgs/"
    static let UserUrlPath = "users/"
    
    static let DefaultUser: String = "vmouta"
    static let DefaultOrganization: String = "zucred"
    
    @IBOutlet weak var type: UISegmentedControl!
    @IBAction func typeChange(sender: AnyObject) {
        if isUserType {
            user.placeholder = ViewController.DefaultUser 
        } else {
            user.placeholder = ViewController.DefaultOrganization
        }
    }
    
    @IBOutlet weak var user: UITextField!
    @IBAction func doneUserName(sender: AnyObject) {
        guard self.url != nil else {
            // TODO: Show something to the user
            print("Invalide Name")
            return
        }
        self.user?.endEditing(true)
    }
    
    var url: NSURL? {
        var url = ViewController.BaseUrl
        if(self.isUserType) {
            url += ViewController.UserUrlPath + (user.text?.isEmpty==false ? user.text! : ViewController.DefaultUser)
        } else {
            url += ViewController.OrgsUrlPath + (user.text?.isEmpty==false ? user.text! : ViewController.DefaultOrganization)
        }
        url += "/repos"
        return NSURL ( string :  url )
    }

    var isUserType: Bool {
        return (type.selectedSegmentIndex == 0)
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
