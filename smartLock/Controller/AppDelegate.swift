//
//  AppDelegate.swift
//  smartLock
//
//  Created by Augusto Wong  on 11/27/18.
//  Copyright © 2018 WPI. All rights reserved.
//

import UIKit
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // To store the information of the user in the tab bar controller
    var myTabBarVC: UITabBarController?
    
    // For Azure App Services (backend)
    let client = ClientManager.sharedClient // from ClientManager.swift


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        
/**************************************** DO NOT REMOVE, we need it for testing *************************************************/
        /* Look this for adding an item to Azure SQL database */
        /* TODO: find out if I need easy Tables at all */
//        // Testing adding a user
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        let client = delegate.client
//        // id needs to be lowercase and a String
//        let user = ["id": "1", "firstName":"Aleksander", "lastName":"Ibro", "email":"aibro@wpi.edu",
//                    "userPassword":"123456", "userImage":"1_Aleksander_Ibro.jpeg"]
//        let itemTable = client.table(withName: "App_User")
//        //client.getTable("App_User").insert(item)
//        itemTable.insert(user) {
//            (insertedItem, error) in
//            if (error != nil) {
//                print("Error" + error.debugDescription);
//            } else {
//                print("Item inserted, id: ", insertedItem!["id"]!)
//            }
//        }
//        // Testing adding a friend
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        let client = delegate.client
//        // id needs to be lowercase and a String
//        let friend = ["id": "2", "friendFirstName":"Mario", "friendLastName":"Zyla", "friendCountInDays":"TTTFFTT",
//                      "friendDoorNotification":"1", "friendImage":"2_Mario_Zyla.jpeg", "userId": "1"]
//        let itemTable = client.table(withName: "Friend")
//        itemTable.insert(friend) {
//            (insertedItem, error) in
//            if (error != nil) {
//                print("Error" + error.debugDescription);
//            } else {
//                print("Item inserted, id: ", insertedItem!["id"]!)
//            }
//        }
/**************************************** DO NOT REMOVE, we need it for testing *************************************************/


        
        // PUSH NOTIFICATIONS
        let center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .badge, .sound])
        { (granted, error) in
            // Enable or disable features based on authorization.
            if (granted){
                print("Successfully received authorization from User")
            }
        }
        
        /* Azure Notification Hub */
        application.registerForRemoteNotifications()

        return true
    }

    
    /* For Push Notifications Handling */
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        ClientManager.sharedClient.push.registerDeviceToken(deviceToken as Data) { error in
            // it's fine if this is nil
            print("Error registering for notifications: ", error?.localizedDescription)
        }
        
        print("Registration end")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: ", error.localizedDescription)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [String: AnyObject]) {
        
        print(userInfo)
        
        let apsNotification = userInfo["aps"] as! NSDictionary
        let apsString       = apsNotification["alert"] as! String
        
        let alert = UIAlertController(title: "Alert", message: apsString, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("OK")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            print("Cancel")
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        var currentViewController = self.window?.rootViewController
        while currentViewController?.presentedViewController != nil {
            currentViewController = currentViewController?.presentedViewController
        }
        
        currentViewController?.present(alert, animated: true) {}
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("APPLICATION ENTERED BACKGROUND")

        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        print("APPLICATION IS BEING TERMINATED")
    }


}

