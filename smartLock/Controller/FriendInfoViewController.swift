//
//  FriendInfoViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 1/29/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire


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
    var currentUserID: Int?
    var tempImage: UIImage =  UIImage(named: "img_placeholder")!
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // set main UI
        setMainUI()
        
        if let friend = friend {
            navigationItem.title = "Friend"
            fullNameTextField.text = "\(friend.firstName) \(friend.lastName)"
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

        // setting the image
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
        let fullNameSplit = fullName.components(separatedBy: " ")
        let firstN = fullNameSplit[0]
        let lastN = fullNameSplit.count > 1 ? fullNameSplit[1] : ""
        
        // updating edited friend
        if navigationItem.title == "Friend"{
            guard
                let id = friend?.id,
                let myImage = profileImageButton.currentBackgroundImage
                else { return }
            
            let editedFriend = Friend( id, firstN, lastN, comeInDays, openDoorNotification )
            editedFriend.image = myImage
            delegate?.updateFriend(with: editedFriend )
            updateImageDB( myImage, editedFriend.imageName )
            //deleteFriendFromDB( editedFriend )
            //storeFriendInDB( editedFriend )
            updateEditedFriendInDB(editedFriend)

            self.navigationController?.popToRootViewController( animated: true )
        
        // Adding new friend
        }else{
            // testing purposes
          //  let id = 4
            // Get an unassigned, random friend ID from the database
            let parameters: Parameters = ["infoRequested": "getFriendId", "userId" : currentUserID]
            let url = "http://doorlockvm.eastus.cloudapp.azure.com:5000/sqlQuery"

            Alamofire.request(url, method: .get, parameters: parameters).responseString { response in
                print("MY RESPONSE")
                print( response.result.value )
                if response.result.isSuccess {
                    // create the user with the DB info
                    let id = Int(response.result.value!)
                    let myImage = self.profileImageButton.currentBackgroundImage!

                    let newFriend = Friend( "", firstN, lastN, comeInDays, openDoorNotification )
                    newFriend.image = myImage
                    self.delegate?.addNewFriend(with: newFriend )
                    self.storeFriendInDB( newFriend )
                    self.updateImageDB( myImage, newFriend.imageName )
                    

                }else{
                    // SHOW ERROR MESSAGE
                    print("couldn't get id")
                }
            }

            self.dismiss( animated: true, completion: nil )
        }
        
    }
    
    // delete a friend from the DB
    func updateEditedFriendInDB( _ friend: Friend) {
        let azureClient = myAppDelegate.client
        let table = azureClient.table(withName: "Friend")
        
        let newFriendItem : [ String: Any] = [
            "id" : friend.id,
            "friendFirstName" : friend.firstName,
            "friendLastName" : friend.lastName,
            "friendCountInDays" : friend.getComeInDaysStr(),
            "friendDoorNotification" : friend.openDoorNotification,
            "friendImage" : friend.imageName,
            "userId" : currentUserID! ]
        
        table.update(newFriendItem) { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let item = result {
                print("Successfully updated friend")
            }
        }
        
//        table.delete(withId: "\(friend.id)") { (itemId, error) in
//            if let err = error {
//                print("ERROR ", err)
//            } else {
//                self.storeFriendInDB( friend )
//            }
//        }
    }
    
    func getComeInDays() -> [Bool] {
        // set the buttons
        let allButtons = [ sundayButton, mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton ]
        var comeInDays : [Bool] = [ true, true, true, true, true, true, true ]
        
        // set the color of the buttons
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
    
    ////////////////////////////////////////////////////////////
    // MARK: CLOUD/DB
    // updates the image in the DB
    
    
    // delete a friend from the DB
    func deleteFriendFromDB( _ friend: Friend) {

        let azureClient = myAppDelegate.client
        let table = azureClient.table(withName: "Friend")
        
        table.delete(withId: "\(friend.id)") { (friendId, error) in
            if let err = error {
                print("ERROR ", err)
            } else {
                print("Deleted Friend ID: ", friendId)
            }
        }
    }

    // adds the friend into the Friend database
    func storeFriendInDB(_ friend: Friend ){
        let friendItem : [ String: Any] = ["friendFirstName" : friend.firstName,
                                      "friendLastName" : friend.lastName,
                                      "friendCountInDays" : friend.getComeInDaysStr(),
                                      "friendDoorNotification" : friend.openDoorNotification,
                                      "friendImage" : friend.imageName,
                                      "userId" : currentUserID! ]
        
        let azureClient = myAppDelegate.client
        let itemTable = azureClient.table(withName: "Friend")
        itemTable.insert(friendItem) {
            (insertedItem, error) in
            if (error != nil) {
                print("Error" + error.debugDescription);
            } else {
                print("Friend inserted")
            }
        }
    }
    
    // Upload a friend image to the VM/Flask server
    func updateImageDB( _ image: UIImage, _ imageName: String ){
        print("Updating image in the DB")
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

extension UIImage {
    
    func fixImageOrientation() -> UIImage? {
        
        
        if (self.imageOrientation == .up) {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        
        if ( self.imageOrientation == .left || self.imageOrientation == .leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
        } else if ( self.imageOrientation == .right || self.imageOrientation == .rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2.0));
        } else if ( self.imageOrientation == .down || self.imageOrientation == .downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        } else if ( self.imageOrientation == .upMirrored || self.imageOrientation == .downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        } else if ( self.imageOrientation == .leftMirrored || self.imageOrientation == .rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        
        if let context: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                              bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                              space: self.cgImage!.colorSpace!,
                                              bitmapInfo: self.cgImage!.bitmapInfo.rawValue) {
            
            context.concatenate(transform)
            
            if ( self.imageOrientation == UIImage.Orientation.left ||
                self.imageOrientation == UIImage.Orientation.leftMirrored ||
                self.imageOrientation == UIImage.Orientation.right ||
                self.imageOrientation == UIImage.Orientation.rightMirrored ) {
                context.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
            } else {
                context.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
            }
            
            if let contextImage = context.makeImage() {
                return UIImage(cgImage: contextImage)
            }
            
        }
        
        return nil
    }
    
    func correctlyOrientedImage() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage ?? self
    }
}
