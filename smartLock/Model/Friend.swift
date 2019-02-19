//
//  Friend.swift
//  smartLock
//
//  Created by Augusto Wong  on 1/29/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import Foundation
import UIKit

class Friend: CustomStringConvertible, Comparable {
    
    
    let id: Int
    var firstName: String
    var lastName: String
    var image: UIImage
    var comeInDays: [Bool]
    var openDoorNotification: Bool
    
    
    init( _ _id: Int, _ _firstName: String, _ _lastName: String, _ _image: UIImage, _ _comeInDays: [Bool], _ _openDoorNotification: Bool ){
        // Set all properties
        id = _id
        firstName = _firstName
        lastName = _lastName
        image = _image
        comeInDays = _comeInDays
        openDoorNotification = _openDoorNotification

    }
    
    // displays Friend's information
    var description: String{
        return "Friend( _id: \(id), _firstName: \(firstName), _lastName: \(lastName), _image:UNKNOWN, comeInDays: \(comeInDays) , openDoorNotification: \(openDoorNotification) ) "
    }
    
    //allows sorting based on first name
    static func < (lhs: Friend, rhs: Friend ) -> Bool {
        return lhs.firstName.lowercased() < rhs.firstName.lowercased()
    }
    
    // allows comparing between friends
    static func == (lhs: Friend, rhs: Friend) -> Bool {
        return lhs.id == rhs.id
    }
    

}
