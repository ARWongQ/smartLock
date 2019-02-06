//
//  ViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 11/27/18.
//  Copyright © 2018 WPI. All rights reserved.
//

import UIKit
import TextFieldEffects

class MainViewController: UIViewController {

    ///////////////////////////////////////////////////////////////////////////////
    //MARK: UI/UX
    // Buttons
    @IBOutlet weak var SignUpButton: UIButton!
    
    // TextFields
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - Useful Variables
    var userDevice = Device(_id: 1, _deviceName: "My First Device", _doorWasOpenedNotif: true, _someoneIsOutsideNotif: true, _leftOpenTime: 5 )
    var userAugusto : User?
    

    ///////////////////////////////////////////////////////////////////////////////
    // Mark: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view as needed
        setUI()
    
       
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - UI Functions
    func setUI(){
        SignUpButton.layer.borderWidth = 0.8
        SignUpButton.layer.borderColor = UIColor.lightGray.cgColor
        
        // creating my user
        userAugusto = User( _id: 1, _firstName: "Augusto", _lastName: "Wong", _email: "arwong@wpi.edu", _password: "123456", _devices: [ userDevice ] )
        
        // Setting Title Font
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - Button's Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        let valid = validateUser(email: email, password: password )
        if( valid ){
            performSegue(withIdentifier: "mainToUserMain", sender: self )
        }
    }
    
    // go to Sign Up view
    @IBAction func signUpButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "mainToSignUp", sender: self )
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - View Transitions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        switch identifier {
        case "mainToSignUp":
            print( "Moving to Sign In Controller" )
        case "mainToUserMain":
            print( "Moving to User Main Controller" )
            let destinationVC = segue.destination as! UserTabBarController
            destinationVC.userAugusto = userAugusto
            destinationVC.currentUser = userAugusto
            
        default:
            print("NO VIEW identifier found")
        }
    }
    
    // function to validate the user
    func validateUser( email: String, password: String ) -> Bool {
        //return (email == UserAugusto.email && password == UserAugusto.password)
        return true 
    }
    
    //unwind a view back to main screen
    @IBAction func unwindToMainVC( unwindSegue: UIStoryboardSegue ) {
        
    }
    


}

