//
//  File.swift
//  smartLock
//
//  Created by Augusto Wong  on 11/27/18.
//  Copyright © 2018 WPI. All rights reserved.
//

import Foundation
import UIKit

class User{
    let id: Int
    var profileImg: UIImage?
    var firstName: String
    var lastName: String
    var fullName: String
    var email: String
    var password: String
    var friends: [Friend]
    var devices: [Device]
    
    init( _id: Int, _firstName: String, _lastName: String, _email: String, _password: String,  _devices: [Device] ){
        // Set all properties
        id = _id
        firstName = _firstName
        lastName = _lastName
        fullName = "\(_firstName) \(_lastName)"
        email = _email
        password = _password
        
        // Temporary
        friends = [
            Friend(_id: 1, _fullName: "Augusto Wong", _image: UIImage(named: "RolandoProfile.jpg")!, _comeInDays: [ true, true, false, true, true, false, true ], _openDoorNotification: true ),
            Friend(_id: 2, _fullName: "Mario Zyla", _image: UIImage(named: "testImage.png")!, _comeInDays: [ true, true, true, true, true, true, true ], _openDoorNotification: true ),
            Friend(_id: 3, _fullName: "Aleksander Ibro", _image: UIImage(named: "tempHomeImage")!, _comeInDays: [ false, true, true, false, true, true, true ], _openDoorNotification: true )
        ]
        
        devices = _devices
        
    }
    
    // updates the name of the user
    func updateName( _firstName: String, _lastName: String ){
        firstName = _firstName
        lastName = _lastName
        fullName = "\(_firstName) \(_lastName)"
    }
    
    // updates the email of the user
    func updateEmail( _email: String ){
        email = _email
    }
    
    // updates the password of the user
    func updatePassword( _password: String ){
        password = _password
    }
    
    func updateProfileImg(_profileImg: UIImage ){
        profileImg = _profileImg
    }
    
}
