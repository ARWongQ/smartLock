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
    
    
    let id: String
    var firstName: String
    var lastName: String
    var imageName: String
    var image: UIImage
    var comeInDays: [Bool]
    var openDoorNotification: Bool
    
    
    init( _ _id: String, _ _firstName: String, _ _lastName: String, _ _comeInDays: [Bool], _ _openDoorNotification: Bool ){
        // Set all properties
        id = _id
        firstName = _firstName
        lastName = _lastName
        image = UIImage(named: "img_placeholder")!
        imageName = "\(firstName)_\(lastName).jpeg"
        comeInDays = _comeInDays
        openDoorNotification = _openDoorNotification

    }
    
    // displays Friend's information
    var description: String{
        return "Friend( _id: \(id), _firstName: \(firstName), _lastName: \(lastName), _image:UNKNOWN, comeInDays: \(comeInDays) , openDoorNotification: \(openDoorNotification) ) "
    }
    
    func getComeInDaysStr() -> String {
        var answer = ""
        for i in comeInDays {
            if i {
                answer += "T"
            }else{
                answer += "F"
            }
        }
        
        return answer
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

