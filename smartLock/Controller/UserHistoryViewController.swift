//
//  UserHistoryViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 1/15/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import UIKit

class UserHistoryViewController: UIViewController {

    // MARK: UI/UX
    
    // MARK: Useful Variables

    
    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Sets the title large and white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes =
            [ NSAttributedString.Key.foregroundColor: UIColor.white ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( true )
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear( true )

        
    }
    
    // MARK: Button's Actions

}
