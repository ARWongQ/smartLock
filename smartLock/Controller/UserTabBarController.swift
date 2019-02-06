//
//  UserTabBarController.swift
//  smartLock
//
//  Created by Augusto Wong  on 1/15/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import UIKit

class UserTabBarController: UITabBarController {
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: UI/UX
    @IBInspectable var defaultTab: Int = 1
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Useful Variables
    var userAugusto : User?
    var testingVariable = 0
    var currentUser : User? 
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set default tab as the second one
        selectedIndex = defaultTab
        
        // Allows me to know when the app has entered background or is terminated
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appTerminated), name: UIApplication.willTerminateNotification, object: nil)

        
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // Mark: - Objective C
    // Runs when the app has entered the background
    @objc func appMovedToBackground(_ notification: Notification) {
        print("APP IS IN BACKGROUND")
        print("Store the data of the tabbar now that it has moved to the background")
        print("My testing VAR is: \(testingVariable)")
    }
    
    // Runs when the app has been terminated
    @objc func appTerminated(_ notification: Notification) {
        print("USER HAS LEFT THE APP")
        print("Store the data when user has left the app")
    }
    

}
