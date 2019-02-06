//
//  TestingTableViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 1/21/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import UIKit

class UserAccountTableViewController: UITableViewController, ChangeBasicInformationDelegate {
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - Delegate Functions
    // changes the name, email and password of the user
    func changeInfo(type: String, data: [String]) {
        switch type{
        case settingsKeys.name:
            currentUser?.updateName( _firstName: data[0], _lastName: data[1] )
            
        case settingsKeys.email:
            currentUser?.updateEmail( _email: data[0] )
            
        case settingsKeys.changePassword:
            currentUser?.updatePassword( _password: data[0])
            
        default:
            print( "Fatal Error")
        }
        
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
                profileButton.setBackgroundImage( UIImage(named: "img_placeholder"), for: .normal )
                return
        }
        
        profileButton.setBackgroundImage( currentProfileImg, for: .normal )
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - View Transitions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! UserAccountEditingViewController
        destinationVC.type = segue.identifier
        destinationVC.delegate = self
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

    }
    

}
