//
//  Device.swift
//  smartLock
//
//  Created by Augusto Wong  on 2/2/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import Foundation
import UIKit

class Device{
    let id: Int
    var deviceName: String
    var doorWasOpenedNotif: Bool
    var someoneIsOutsideNotif: Bool
    var leftOpenTime: Int

    init(_id: Int, _deviceName: String, _doorWasOpenedNotif: Bool, _someoneIsOutsideNotif: Bool, _leftOpenTime: Int ) {
        id = _id
        deviceName = _deviceName
        doorWasOpenedNotif = _doorWasOpenedNotif
        someoneIsOutsideNotif = _someoneIsOutsideNotif
        leftOpenTime = _leftOpenTime
    }
}

