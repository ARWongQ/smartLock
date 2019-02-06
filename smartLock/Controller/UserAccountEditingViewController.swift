//
//  UserAccountEditingViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 1/21/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import UIKit
import TextFieldEffects

// Protocol
// triggered when the user has actually changed something
protocol ChangeBasicInformationDelegate{
    func changeInfo( type: String, data: [String] )
}

class UserAccountEditingViewController: UIViewController {
    
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Structs
    struct settingsKeys {
        static let name = "Update Name"
        static let email = "Update Email"
        static let changePassword = "Update Password"
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: UI/UX
    @IBOutlet weak var topTextField: HoshiTextField!
    @IBOutlet weak var bottomTextField: HoshiTextField!
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Useful Variables
    // To know what information is to be edited
    var type : String?
    var delegate : ChangeBasicInformationDelegate?
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        setUI()
        
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: UI Functions
    func setUI(){
        topTextField.text = ""
        bottomTextField.text = ""
        
        if let type = type {
            
            // get proper screen
            switch type{
            case settingsKeys.name:
                topTextField.placeholder = "New First Name"
                bottomTextField.placeholder = "New Last Name"
                self.title = type
                
            case settingsKeys.email:
                topTextField.placeholder = "New Email"
                bottomTextField.isHidden = true
                
                self.title = type
                
                
            case settingsKeys.changePassword:
                topTextField.placeholder = "Old Password"
                bottomTextField.placeholder = "New Password"
                
                self.title = type
                
            default:
                print( "Fatal Error, settings screen with unknow segue")
            }
            
        }
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Button's Actions
    @IBAction func saveButtonPressed(_ sender: Any) {
 
        // Update proper information
        if let type = type {
            var newData : [ String ] = []
            newData.append( topTextField.text! )
            newData.append( bottomTextField.text! )
            delegate?.changeInfo( type: type, data: newData )
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    

}
