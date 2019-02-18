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
    
    
    init( _ _id: Int, _ _fullName: String, _ _image: UIImage, _ _comeInDays: [Bool], _ _openDoorNotification: Bool ){
        // Set all properties
        id = _id
        fullName = _fullName
        image = _image
        comeInDays = _comeInDays
        openDoorNotification = _openDoorNotification

    }
    

}
