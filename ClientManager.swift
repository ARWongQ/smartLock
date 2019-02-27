//
//  ClientManager.swift
//  smartLock
//
//  Created by Mario Zyla on 2/26/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import Foundation

class ClientManager {
    static let sharedClient = MSClient(applicationURLString: "https://smartdoorlock.azurewebsites.net")
}
