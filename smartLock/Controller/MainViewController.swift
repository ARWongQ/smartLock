//
//  ViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 11/27/18.
//  Copyright © 2018 WPI. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON

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
    //var userDevice = Device(_id: 1, _deviceName: "My First Device", _doorWasOpenedNotif: true, _someoneIsOutsideNotif: true, _leftOpenTime: 5 )
    var user : User?
    

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
        //userAugusto = User( _id: 1, _firstName: "Augusto", _lastName: "Wong", _email: "arwong@wpi.edu", _password: "123456" )
        
        // Setting Title Font
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - Button's Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        self.getUserAuthenticationFromDB( email, password )
        
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////
        // Only for testing
        // for now we are just creating our own user
//        let tempUser = User(1, "Augusto", "Wong", "arwong@wpi.edu", "123456")
//        let friends = [
//            Friend( 1, "Mario", "Zyla", UIImage(named: "testImage.png")!, [ true, true, false, true, true, false, true ], true ),
//            Friend( 2, "Aleksander",  "Ibro", UIImage(named: "testImage.png")!, [ true, true, false, true, true, false, true ], true ),
//            Friend( 3, "Carlos",  "Galo" , UIImage(named: "testImage.png")!, [ true, true, true, true, true, true, true ], true )]
//
//        for friend in friends{
//            tempUser.addFriend(friend)
//        }
//
//        self.user = tempUser
//
//        // Go the next screen
//        self.performSegue(withIdentifier: "mainToUserMain", sender: self )

        
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
            //destinationVC.userAugusto = userAugusto
            destinationVC.currentUser = user
            
        default:
            print("NO VIEW identifier found")
        }
    }
    
    
    //unwind a view back to main screen
    @IBAction func unwindToMainVC( unwindSegue: UIStoryboardSegue ) {
        
    }
    
    ////////////////////////////////////////////////////////////
    // MARK: CLOUD/DB
    // Gets the user from the database
    func getUserAuthenticationFromDB( _ email: String, _ password: String ){
        let myEmail = "aibro@wpi.edu"
        let myPassword = "123456"
        //This will be your parameter, infoRequested is gonna be the keyword we can check and allUsersInfo will be a string about what iPhone needs from the Flask Server
        let parameters: Parameters = ["infoRequested": "getUserAuthentication", "email": myEmail, "password": myPassword ]
        let url = "http://doorlockvm.eastus.cloudapp.azure.com:5000/sqlQuery"
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            print("MY RESPONSE")
            //print( response )
            if response.result.isSuccess {
                
                // create the user with the DB info
                let answerJSON : JSON = JSON( response.result.value! )
                self.user = self.createUser(user: answerJSON)
                
                // Go the next screen
                self.performSegue(withIdentifier: "mainToUserMain", sender: self )
                
                
            }else{
                // SHOW ERROR MESSAGE
                
                
                
                
                
            }
        }
        
    }
    
    
    
    //Creates a user from a json
    func createUser( user: JSON  ) -> User {
        // Create the user
        let id = user["id"].intValue
        let firstN = user["firstName"].stringValue
        let lastN = user["lastName"].stringValue
        let email = user["email"].stringValue
        let password = user["password"].stringValue
        var myUser = User( id, firstN, lastN, email,  password )
        
        // add friends if any
        let friendsDic = user["friends"]
        for (key,value) in friendsDic {
            // create a user
            let id = value["id"].intValue
            let firstN = value["firstName"].stringValue
            let lastN = value["lastName"].stringValue
            let image = UIImage(named: "img_placeholder")!
            let comeInDaysStr = value["comeInDays"].stringValue
            let openDoorNotif = value["doorNotification"].intValue == 1
            
            // get the proper format for comeInDays and openDoorNotif
            var comeInDays : [Bool] = []
            for char in comeInDaysStr{
                if( char == "T" ){
                    comeInDays.append( true )
                }else if ( char == "F" ){
                    comeInDays.append( false )
                }
            }
            
        
            let curFriend = Friend( id, firstN, lastN, comeInDays, openDoorNotif )
            setImageFromDB( curFriend )
            myUser.addFriend( curFriend )
        }
        
        // add devices if any 
        
        return myUser

    }
    
    // get the image from the Db for a requested friend
    func setImageFromDB( _ friend: Friend){
        
        let parameters: Parameters = ["friendImageName": friend.imageName ]
        let url = "http://doorlockvm.eastus.cloudapp.azure.com:5000/getFriendImage"
        Alamofire.request(url, method: .get, parameters: parameters).responseImage { response in
            
            if response.result.isSuccess {
                // show the image from the DB
                print("SETTING IMAGE OF FRIEND")
                friend.image = response.result.value!
                
            }else{
                // set temp image
                friend.image = UIImage(named: "img_placeholder")!
                
            }
        }
    }


}

