//
//  UserMainViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 12/4/18.
//  Copyright © 2018 WPI. All rights reserved.
//

import UIKit

class UserMainViewController: UIViewController {
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: UI/UX
    @IBOutlet weak var screenImageView: UIImageView!
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Useful Variables
    var userAugusto : User?

    ///////////////////////////////////////////////////////////////////////////////
    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        screenImageView.image = UIImage(named: "tempHomeImage")
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [ NSAttributedString.Key.foregroundColor: UIColor.white ]
       
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
