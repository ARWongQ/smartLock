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
import Alamofire
import Firebase

class SignUpViewController: UIViewController {
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: UI/UX
    
    //Text Fields
    @IBOutlet weak var firstNameTextField: HoshiTextField!
    @IBOutlet weak var lastNameTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var confirmPasswordTextField: HoshiTextField!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        let valid = checkAllFilledData() //also checks if password = confirm Password fields
        if( valid == true ){
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
                if let err = error {
                    print("cannot create user ", err)
                } else {
                    print("user PROBABLY created")
                    /* Since we created the user in Firebase, we need to add the user's info in the
                       actual Azure DB. Note that we do this even though the user hasn't verified
                       the email they provided yet. That is fine, since the app won't let the user
                       log in if email is unverified */
                    self.storeUserInAzureDB(self.firstNameTextField.text!, self.lastNameTextField.text!, self.emailTextField.text!, "123456")
                    // Moving to next screen
                    self.performSegue(withIdentifier: "signUpToCheckEmail", sender: self )
                }
            }
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
        
        if (passwordTextField.text != confirmPasswordTextField.text) {
            //TODO: Add a label that tells the user fields are not the same
            print("SIGN UP: Password not the same as confirm password")
            return false;
        }
        // this way it wont optimize whenever we get one false ?? - are these comments just for you bud
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
    
    // Stores the user in Azure SQL DB (with no picture)
    func storeUserInAzureDB(_ firstName: String, _ lastName: String, _ email: String, _ password: String) {
        
        let client = myAppDelegate.client
        // get a random available id from Flask Server
        let parameters: Parameters = ["infoRequested": "getFriendId", "userId" : "1"]
        let url = "http://doorlockvm.eastus.cloudapp.azure.com:5000/sqlQuery"
        
        Alamofire.request(url, method: .get, parameters: parameters).responseString { response in
            print("SIGN UP: response value", response.result.value)
            if response.result.isSuccess {
                // create the user with the DB info
                let id = response.result.value!
                // id needs to be lowercase and a String
                let user = ["id": id, "firstName": firstName, "lastName": lastName, "email": email,
                            "userPassword": password, "userImage":"\(firstName)_\(lastName)"]
                let itemTable = client.table(withName: "App_User")
                //client.getTable("App_User").insert(item)
                itemTable.insert(user) {
                    (insertedItem, error) in
                    if (error != nil) {
                        print("Error" + error.debugDescription);
                    } else {
                        print("Item inserted, id: ", insertedItem!["id"]!)
                    }
                }
            } else {
                // SHOW ERROR MESSAGE
                print("couldn't get id")
            }
        }
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
