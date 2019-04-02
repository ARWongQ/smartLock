//
//  TestingTableViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 1/21/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import UIKit
import Alamofire


class UserAccountTableViewController: UITableViewController, ChangeBasicInformationDelegate {
    
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - Delegate Functions
    // changes the name, email and password of the user
    func changeInfo(type: String, data: [String]) {
        
        // Update a temp user in case updating to the DB fails
        guard let tempUser = currentUser else { return }
        switch type{
        case settingsKeys.name:
            tempUser.updateName( _firstName: data[0], _lastName: data[1] )
            
        case settingsKeys.email:
            tempUser.updateEmail( _email: data[0] )
            
        case settingsKeys.changePassword:
            tempUser.updatePassword( _password: data[0])
            
        default:
            print( "Fatal Error")
        }
        
        // Update the user in the cloud DB
        updateUserDB( tempUser )
        
        tableView.reloadData()
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Structs
    // all setting information
    struct settingsKeys {
        static let name = "Update Name"
        static let email = "Update Email"
        static let changePassword = "Update Password"
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: UI/UX
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Useful Variables
    var currentUser: User?
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Button's Actions
    
    // signs the user out of the application
    @IBAction func signOutPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil )
    }
    

    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the title large and white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes =
            [ NSAttributedString.Key.foregroundColor: UIColor.white ]
    
        // prevent from having dividors after last cell
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Sets the title large and white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes =
            [ NSAttributedString.Key.foregroundColor: UIColor.white ]
        
        // update the table
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( true )
        
        // Get the current user and update the UI
        let tabbar = tabBarController as! UserTabBarController
        currentUser = tabbar.currentUser
        setupUI()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear( true )
        
        // save the user
        let tabbar = tabBarController as! UserTabBarController
        tabbar.currentUser = currentUser

    }

    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - UI Functions
    
    // sets the current user
    func setupUI(){
        if let currentUser = currentUser {
            userNameLabel.text = currentUser.fullName
            userEmailLabel.text = currentUser.email
            
            // Set profile picture
            profileButton.layer.cornerRadius = profileButton.frame.width / 2
            profileButton.clipsToBounds = true
            profileButton.layer.borderWidth = 0.5
            profileButton.layer.borderColor = UIColor.black.cgColor
            updateProfilePicture()
            
            
        }else{ return }
        
    }
    
    // updates the profile image
    func updateProfilePicture(){
        guard let currentUser = currentUser,
            let currentProfileImg = currentUser.profileImg
            else {
                // Failure to get an image
                profileButton.setBackgroundImage( UIImage(named: "img_placeholder"), for: .normal )
                return
        }
        
        profileButton.setBackgroundImage( currentProfileImg, for: .normal )
        
        // Sending the new picture to the cloud 
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - View Transitions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! UserAccountEditingViewController
        destinationVC.type = segue.identifier
        destinationVC.delegate = self
    }

    ////////////////////////////////////////////////////////////
    // MARK: CLOUD/DB
    
    // updates a the user's info in the cloud's DB
    // TODO Test
    func updateUserDB( _ user: User ) {
        print("Updating currentUser info")
        
        let azureClient = myAppDelegate.client
        let table = azureClient.table(withName: "App_User")
        
        let newUserItem : [ String: Any] = [
            "id" : user.id,
            "firstName" : user.firstName,
            "lastName" : user.lastName,
            "userImage" : user.imageName
        ]
        
        table.update(newUserItem) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let item = result {
                print("In UserAccountTableViewController: Successfully updated friend", item)
            }
        }
        
        
    }


}

// Deal with the images
extension UserAccountTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBAction func takePicture(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)

        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        currentUser?.updateProfileImg( _profileImg: selectedImage )
        updateProfilePicture()
        updateImageDB(selectedImage, (currentUser?.imageName)!)

    }
    
    func updateImageDB( _ image: UIImage, _ imageName: String ) {
        print("Updating USER Image in DB")
        let rightImage = image.fixImageOrientation()
        guard let data = rightImage!.jpegData(compressionQuality: 1) else { return }
        let url = "http://doorlockvm.eastus.cloudapp.azure.com:5000/postFriendImage"
        
        Alamofire.upload( multipartFormData: { (form) in
            form.append(data, withName: "file", fileName: imageName, mimeType:"image/jpeg")
        }, to: url, encodingCompletion: { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseString { response in
                    if( response.value == "No Face"){
                        print("NO FACE IN THE UPLOADED IMAGE")
                    }else if( response.value == "Success"){
                        print("Image Successfully Encoded and added to the DB")
                    }
                }
            case .failure( let encodingError):
                print(encodingError)
            }
        })
    }
}
