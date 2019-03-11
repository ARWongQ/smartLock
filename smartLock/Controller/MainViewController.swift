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
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    

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
        
        /********* USER DOES NOT SIGN IN FOR THE MOMENT ********/
        let myEmail = "aibro@wpi.edu"
        let myPassword = "123456"
        /*******************************************************/
        let azureClient = myAppDelegate.client
        let appUserTable = azureClient.table(withName: "App_User")
        // Create a predicate that finds users with the given user name and password
        var predicate =  NSPredicate(format: "email = %@ AND userPassword = %@", myEmail, myPassword)
        appUserTable.read(with : predicate) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let users = result?.items {
                // users contains all users with matching predicate (only 1)
                let userId = (users[0]["id"] as! NSString).intValue
                // Getting user's friends
                let friendTable = azureClient.table(withName: "Friend")
                predicate = NSPredicate(format: "userId = %d", userId)

                friendTable.read(with : predicate) { (result, error) in
                    if let err = error {
                        print("Error reading friends ", err)
                    } else if let friends = result?.items {
                        // create the user with friends
                        self.user = self.createUser(user: users[0], friends: friends)

                        // move to the next screen
                        self.performSegue(withIdentifier: "mainToUserMain", sender: self)
                    }
                }
            }
        }
    }
    
    
    
    //Creates a user
    func createUser( user: [AnyHashable : Any], friends: [[AnyHashable : Any]] ) -> User {
        // Create the user
        let id = (user["id"] as! NSString).intValue
        let firstN = user["firstName"] as! String
        let lastN = user["lastName"] as! String
        let email = user["email"] as! String
        let password = user["userPassword"] as! String
        var myUser = User( Int(id), firstN, lastN, email,  password )

        for friend in friends{
            print(friend)
            let id = friend["id"] as! String
            print("Id of friend I am trying to add", id)

            let firstN =  friend["friendFirstName"] as! String
            let lastN =  friend["friendLastName"] as! String
            let countInDays =  friend["friendCountInDays"] as! String
            let doorNotification = ( friend["friendDoorNotification"] as! NSString ).intValue == 1
            
            // get the proper format for comeInDays and openDoorNotif
            var comeInDays : [Bool] = []
            for char in countInDays{
                if( char == "T" ){
                    comeInDays.append( true )
                }else if ( char == "F" ){
                    comeInDays.append( false )
                }
            }
            let curFriend = Friend( id, firstN, lastN, comeInDays, doorNotification )
            setImageFromDB( curFriend )
            myUser.addFriend( curFriend )
        }
        return myUser
    }
    
    // get the image from the Db for a requested friend
    func setImageFromDB( _ friend: Friend){
        print("Getting picture ", friend.imageName)
        let parameters: Parameters = ["friendImageName": friend.imageName ]
        let url = "http://doorlockvm.eastus.cloudapp.azure.com:5000/getFriendImage"
        Alamofire.request(url, method: .get, parameters: parameters).responseImage { response in
            if response.result.isSuccess {
                // show the image from the DB
                print("SETTING IMAGE OF FRIEND")
                friend.image = response.result.value!
            }else{
                // set temp image
                print("No image received for this friend")
                friend.image = UIImage(named: "img_placeholder")!
                
            }
        }
    }
}

