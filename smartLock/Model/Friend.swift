//
//  Friend.swift
//  smartLock
//
//  Created by Augusto Wong  on 1/29/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import Foundation
import UIKit

class Friend{
    let id: Int
    var fullName: String
    var image: UIImage
    var comeInDays: [Bool]
    var openDoorNotification: Bool
    
    
    init( _id: Int, _fullName: String, _image: UIImage, _comeInDays: [Bool], _openDoorNotification: Bool ){
        // Set all properties
        id = _id
        fullName = _fullName
        image = _image
        comeInDays = _comeInDays
        openDoorNotification = _openDoorNotification

    }
    

}
