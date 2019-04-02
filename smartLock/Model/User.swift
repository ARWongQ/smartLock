//
//  File.swift
//  smartLock
//
//  Created by Augusto Wong  on 11/27/18.
//  Copyright © 2018 WPI. All rights reserved.
//

import Foundation
import UIKit

class User {
    let id: Int
    var profileImg: UIImage?
    var firstName: String
    var lastName: String
    var fullName: String
    var email: String
    var password: String
    var imageName: String
    var admins: [AdminInfo]
    var friends: [Friend]
    var devices: [Device]
    
    init( _ _id: Int, _ _firstName: String, _ _lastName: String, _ _email: String, _ _password: String ){
        // Set all properties
        id = _id
        firstName = _firstName
        lastName = _lastName
        fullName = "\(_firstName) \(_lastName)"
        email = _email
        password = _password
        imageName = "\(_firstName)_\(_lastName).jpeg"
        admins = []
        friends = []
        devices = []
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
    
    func addFriend( _ friend: Friend ){
        friends.append( friend )
    }
    
    func addAdmin( _ admin: AdminInfo ){
        admins.append( admin )
    }
    
}
