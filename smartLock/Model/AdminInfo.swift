//
//  AdminInfo.swift
//  smartLock
//
//  Created by Augusto Wong  on 3/10/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import Foundation
import UIKit

class AdminInfo: CustomStringConvertible, Comparable {

    

    let id: Int
    var firstName: String
    var lastName: String
    var imageName: String
    var image: UIImage
    
    init( _ _id: Int, _ _firstName: String, _ _lastName: String ){
    
    // Set all properties
    id = _id
    firstName = _firstName
    lastName = _lastName
    image = UIImage(named: "img_placeholder")!
    imageName = "\(firstName)_\(lastName).jpeg"

    
    }
    
    // displays AdminInfo's information
    var description: String{
        return "AdminInfo( _id: \(id), _firstName: \(firstName), _lastName: \(lastName), _image:UNKNOWN )"
    }
    
    //allows sorting based on first name
    static func < (lhs: AdminInfo, rhs: AdminInfo ) -> Bool {
        return lhs.firstName.lowercased() < rhs.firstName.lowercased()
    }
    
    // allows comparing between admins
    static func == (lhs: AdminInfo, rhs: AdminInfo) -> Bool {
        return lhs.id == rhs.id
    }
}
