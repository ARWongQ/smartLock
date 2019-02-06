//
//  secondViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 11/27/18.
//  Copyright © 2018 WPI. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects

class SignUpViewController: UIViewController {
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: UI/UX
    
    //Text Fields
    @IBOutlet weak var firstNameTextField: HoshiTextField!
    @IBOutlet weak var lastNameTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    
    
    // Mark: App Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButton()
        
        // Setting Title Font
//        self.navigationController?.navigationBar.titleTextAttributes =
//            [NSAttributedString.Key.foregroundColor: UIColor.black,
//             NSAttributedString.Key.font: UIFont(name: "Arial Rounded MT Bold", size: 24.0)!]
        self.navigationController?.navigationBar.titleTextAttributes =
            [ NSAttributedString.Key.foregroundColor: UIColor.white ]
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - BUTTONS ACTION
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil )
    }
    
    // Submit new user information and go to user main screen
    @IBAction func submitButtonPressed(_ sender: Any) {
        let valid = checkAllFilledData()
        if( valid == true ){
            // Moving to next screen
            performSegue(withIdentifier: "signUpToCheckEmail", sender: self )
        }else{
            // Present a pop up 
            let alert = UIAlertController(title: "Error", message: "Please fill all required information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil ))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // shows save button when the user has entered all valid information
    func updateSaveButton(){
        let allTextField = [ firstNameTextField, lastNameTextField, emailTextField, passwordTextField ]
        submitButton.isEnabled = true
        for textF in allTextField{
            let text = textF!.text ?? ""
            if( text.isEmpty ){
                submitButton.isEnabled = false
                break
            }
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: TextField
    
    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButton()
    }
    
    
    // Makes sure the user has entered all avlid information
    func checkAllFilledData() -> Bool {
        var isValid : [Bool] = []
        let allTextField = [ firstNameTextField, lastNameTextField, emailTextField, passwordTextField ]
        
        // this way it wont optimize whenever we get one false
        for textF in allTextField{
            isValid.append( checkValidTextField( textF! ) )
        }

        return !isValid.contains(false)
    }
    
    // checks if a text field has valid data
    func checkValidTextField( _ textField: HoshiTextField ) -> Bool{
        // check invalid data
        let whitespace = NSCharacterSet.whitespaces
        if (textField.text?.trimmingCharacters(in: whitespace) == "") {
            setErroneousTextField( textField )
            return false
            
        // valid information
        } else{
            setGoodTextField( textField )
            return true
        }
    }
    
    // set the text field as invalid
    func setErroneousTextField( _ textField: HoshiTextField){
        textField.borderActiveColor = UIColor.red
        textField.animateViewsForTextEntry()
    }
    
    // Set the text field as valid
    func setGoodTextField( _ textField: HoshiTextField ){
        let myBlue: UIColor = UIColor( red: CGFloat(38/255.0), green: CGFloat(169/255.0), blue: CGFloat(234/255.0), alpha: CGFloat(1.0) )
        textField.borderActiveColor = myBlue
        textField.animateViewsForTextEntry()
        
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - View Transitions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        switch identifier {
        case "signUpToCheckEmail":
            print( "Checking email" )
        default:
            print("NO VIEW identifier found")
        }
    }
    
}
