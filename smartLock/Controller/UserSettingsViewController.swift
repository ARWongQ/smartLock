//
//  UserSettingsViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 1/15/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController, UITableViewDelegate {
    

    
    // MARK: Useful Variables
    var userAugusto : User?

    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: "Arial Rounded MT Bold", size: 24.0)!]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( true )
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear( true )
        
    }
    
    
    
    

}
