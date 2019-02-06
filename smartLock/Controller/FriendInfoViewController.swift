//
//  FriendInfoViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 1/29/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import UIKit
import TextFieldEffects

// Protocol
// Triggered when the user changes the info of a friend or adds a new friend
protocol ChangeFriendInfoDelegate{
    func updateFriend( with friend: Friend )
    func addNewFriend( with friend: Friend )
}

class FriendInfoViewController: UIViewController {
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: UI/UX
    // test 
    @IBOutlet weak var fullNameTextField: HoshiTextField!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var opensDoorSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!

    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Useful Variables
    var delegate : ChangeFriendInfoDelegate?
    var friend: Friend?
    var tempImage: UIImage =  UIImage(named: "img_placeholder")!
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // set main UI
        setMainUI()
        
        if let friend = friend {
            navigationItem.title = "Friend"
            fullNameTextField.text = friend.fullName
            profileImageButton.setBackgroundImage( friend.image, for: .normal )
            opensDoorSwitch.isOn = friend.openDoorNotification

            
        }else {
            navigationItem.title = "New Friend"
            profileImageButton.setBackgroundImage( tempImage, for: .normal )
        }
        
        updateSaveButtonState()

    }

    ///////////////////////////////////////////////////////////////////////////////
    // MARK: UI Functions
    func setMainUI(){
        // Set the title
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Set profile picture
        profileImageButton.layer.cornerRadius = 24.5
        profileImageButton.clipsToBounds = true
        profileImageButton.layer.borderWidth = 0.5
        profileImageButton.layer.borderColor = UIColor.black.cgColor
        
        // sets the buttons
        setButtonsUI()
    }
    
    // set the buttons as needed
    func setButtonsUI(){
        // set the buttons
        let allButtons = [ sundayButton, mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton ]
        
        for i in 0...6 {
            guard let currButton =  allButtons[ i ] else { return }
            currButton.layer.cornerRadius = currButton.frame.width / 4
            currButton.clipsToBounds = true
            currButton.layer.borderWidth = 1
            currButton.layer.borderColor = UIColor.black.cgColor
            currButton.backgroundColor = UIColor.lightGray
            // update this if we have a freind info
            if let friend = friend {
                if( friend.comeInDays[ i ] ){
                   // currButton.backgroundColor = UIColor(red: 37/255, green: 168/255, blue: 235/255, alpha: 1)
                    currButton.backgroundColor = UIColor(red: 22/255, green: 116/255, blue: 177/255, alpha: 1)
                }
            }
        }
    }
    
    // updates the profile pic as needed
    func updateProfilePicture( withImage image: UIImage){
        profileImageButton.setBackgroundImage( image, for: .normal )
        updateSaveButtonState()
    }
    
    // need to also make sure an image has been added!
    func updateSaveButtonState() {
        let text = fullNameTextField.text ?? ""
        let currImage: UIImage = profileImageButton.currentBackgroundImage!
        let sameImages = compareImages(image1: currImage, isEqualTo: tempImage )
        saveButton.isEnabled = !text.isEmpty && !sameImages
    }
    
    // compares two images
    func compareImages(image1: UIImage, isEqualTo image2: UIImage) -> Bool {
        print("HELLO")
        let data1: NSData = image1.pngData()! as NSData
        let data2: NSData = image2.pngData()! as NSData
        return data1.isEqual(data2)
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Button's Actions
    @IBAction func weekdayButtonPressed(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        
        // change background as needed
        if( button.backgroundColor == UIColor.lightGray ){
            //button.backgroundColor = UIColor(red: 37/255, green: 168/255, blue: 235/255, alpha: 1)
            button.backgroundColor = UIColor(red: 22/255, green: 116/255, blue: 177/255, alpha: 1)
        }else{
            button.backgroundColor = UIColor.lightGray
        }
    }
    

    // enable the button if it has a name
    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    // save button
    @IBAction func saveButtonTapped(_ sender: Any) {
        // info from view
        guard let fullName = fullNameTextField.text else { return }
        let openDoorNotification = opensDoorSwitch.isOn
        let comeInDays = getComeInDays()
        
        // updating edited friend
        if navigationItem.title == "Friend"{
            // NEED TO USE THE UI information
            guard
                let id = friend?.id,
                let myImage = profileImageButton.currentBackgroundImage
                else { return }
            let editedFriend = Friend(_id: id, _fullName: fullName, _image: myImage, _comeInDays: comeInDays, _openDoorNotification: openDoorNotification )
            delegate?.updateFriend(with: editedFriend )
            
            self.navigationController?.popToRootViewController( animated: true )
        
        // Adding new friend
        }else{
            // testing purposes
            let id = 4
            let myImage = profileImageButton.currentBackgroundImage!
            let newFriend = Friend(_id: id, _fullName: fullName, _image: myImage, _comeInDays: comeInDays, _openDoorNotification: openDoorNotification )
            delegate?.addNewFriend(with: newFriend )
            self.dismiss( animated: true, completion: nil )
        }
        
    }
    func getComeInDays() -> [Bool] {
        // set the buttons
        let allButtons = [ sundayButton, mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton ]
        var comeInDays : [Bool] = [ true, true, true, true, true, true, true ]
        
        for i in 0...6 {
            guard let currButton =  allButtons[ i ] else { return comeInDays }
            if( currButton.backgroundColor == UIColor.lightGray ){
                comeInDays[ i ] = false
            }
        }
            
        return comeInDays
    }
    
    // Returns back to the previous view
    @IBAction func cancelButtonPressed(_ sender: Any) {
        // editing friend
        if navigationItem.title == "Friend"{
            self.navigationController?.popToRootViewController( animated: true )
        
        // adding friend
        }else{
            self.dismiss( animated: true, completion: nil )
        }
    }
    
}

extension FriendInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBAction func takePicture(_ sender: UIButton ){
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
        
        updateProfilePicture( withImage: selectedImage)
        
    }
}
