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
import Firebase

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
//        // Only for testing
//        // for now we are just creating our own user
//        let tempUser = User(1, "Augusto", "Wong", "arwong@wpi.edu", "123456")
//        // add friends
//        let friends = [
//            Friend( 1, "Mario", "Zyla", [ true, true, false, true, true, false, true ], true ),
//            Friend( 2, "Aleksander",  "Ibro", [ true, true, false, true, true, false, true ], true ),
//            Friend( 3, "Carlos",  "Galo" , [ true, true, true, true, true, true, true ], true )]
//
//        for friend in friends{
//            tempUser.addFriend(friend)
//        }
//        
//        // add admins
//        let admins = [
//            AdminInfo( 5, "Kristiano", "dicka" ),
//            AdminInfo( 8, "FirstName", "LastName" )
//        ]
//        
//        for admin in admins{
//            tempUser.addAdmin( admin )
//        }
//
//        // ste the user 
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
//        let myEmail = "aibro@wpi.edu"
//        let myPassword = "123456"
        /*******************************************************/
        
        /* Azure Client for SQL DB access */
        let azureClient = myAppDelegate.client
        /* Azure Firebase authentication for filled in email and password */
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] user, error in
            guard let strongSelf = self else {
                print("SIGN IN: Could not sign user ", error)
                return
            }
        }
        
        /*************** Gets the user from Azure SQL DB and creates a local User object **********************************/
        /*************** We fill in the user object with its picture from Cloud VM local storage **************************/
        /*************** And list of normal friends and a list of admins **************************************************/
        
        let appUserTable = azureClient.table(withName: "App_User")
        // Create a predicate that finds users with the given user name and password
        var predicate =  NSPredicate(format: "email = %@ AND userPassword = %@", emailTextField.text!, passwordTextField.text!)
        appUserTable.read(with : predicate) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let users = result?.items {
                // users contains all users with matching predicate (only 1)
                let userId = users[0]["id"] as! Int
                // Getting user's friends
                let friendTable = azureClient.table(withName: "Friend")
                predicate = NSPredicate(format: "userId = %d", userId)

                friendTable.read(with : predicate) { (result, error) in
                    if let err = error {
                        print("Error reading friends ", err)
                    } else if let friends = result?.items {
                        print("friends", friends)
                        // Getting user's admin friends (i.e. real users in the db)
                        let addedUserTable = azureClient.table(withName: "App_User_Added")
                        predicate = NSPredicate(format: "addingUserId = %d", userId)
                        
                        addedUserTable.read(with: predicate) { (result, error) in
                            if let err = error {
                                print("Error reading addedUserTable ", err)
                            } else if let adminIds = result?.items {
                                // need to get info for all these adminIds
                                print("admin ids", adminIds)
                                var admins : [[AnyHashable : Any]] = []
                                for adminId in adminIds {
                                    print("adminid", adminId)
                                    predicate = NSPredicate(format: "id = %d", (adminId["addedUserId"] as! NSString).intValue)
                                    appUserTable.read(with : predicate) { (result, error) in
                                        if let err = error {
                                            print("Error getting admins ", err)
                                        } else if var theseAdmins = result?.items {
                                            let thisAdmin = theseAdmins[0]
                                            print("thisAdmin", thisAdmin)
                                            admins.append(thisAdmin)
                                        }
                                        print("RIGHT BEFORE CREATING USER")
                                        print("friends", friends)
                                        print("admins", admins)
                                        // create the user with friends and admins
                                        self.user = self.createUser(user: users[0], friends: friends, admins: admins)
                                        // move to the next screen
                                        self.performSegue(withIdentifier: "mainToUserMain", sender: self)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        /******************************************************************************************************************/
    }
    
    
    
    //Creates a user
    func createUser( user: [AnyHashable : Any], friends: [[AnyHashable : Any]], admins: [[AnyHashable : Any]]) -> User {
        print("CREATING USER")
        // Create the user
        let id = user["id"] as! Int
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
        
        for admin in admins {
            print("Admin", admin)
            let id = admin["id"] as! Int
            print("Id of admin I am trying to add", id)
            
            let firstN = admin["firstName"] as! String
            let lastN = admin["lastName"] as! String
            let thisAdmin = AdminInfo(id, firstN, lastN)
            setImageFromDB(thisAdmin)
            myUser.addAdmin(thisAdmin)
            
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
    
    // get the image from the Db for a requested admin
    func setImageFromDB( _ admin: AdminInfo){
        print("Getting picture ", admin.imageName)
        let parameters: Parameters = ["friendImageName": admin.imageName ]
        let url = "http://doorlockvm.eastus.cloudapp.azure.com:5000/getFriendImage"
        Alamofire.request(url, method: .get, parameters: parameters).responseImage { response in
            if response.result.isSuccess {
                // show the image from the DB
                print("SETTING IMAGE OF ADMIN")
                admin.image = response.result.value!
            }else{
                // set temp image
                print("No image received for this admin")
                admin.image = UIImage(named: "img_placeholder")!
                
            }
        }
    }
}

