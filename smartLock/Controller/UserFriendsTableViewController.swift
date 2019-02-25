//
//  UserFriendsTableViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 1/29/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import UIKit
import Alamofire

class UserFriendsTableViewController: UITableViewController, ChangeFriendInfoDelegate {
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Delegate Functions
    // Updates a friend from my list of friends
    func updateFriend( with friend: Friend ){

        if let index = getFriendIndex(id: friend.id ){
            currentUser?.friends.remove(at: index )
            currentUser?.friends.append( friend )
            tableView.reloadData()
        }

    }
    
    // adds a new friend to my list
    func addNewFriend( with friend: Friend ){
        currentUser?.friends.append( friend )
    }
    
    // deletes a friend and gives you the index where it was deleted
    func getFriendIndex( id: Int ) -> Int? {
        guard let friends = currentUser?.friends else { return nil }
        for (index, friend) in friends.enumerated()  {
            if( friend.id == id ){
                return index
            }
        }
        return nil
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Useful Variables
    var currentUser: User?
    

    ///////////////////////////////////////////////////////////////////////////////
    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prevent from having dividors after last cell
        tableView.tableFooterView = UIView(frame: .zero)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        
        // Sets the title large and white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes =
            [ NSAttributedString.Key.foregroundColor: UIColor.white ]
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( true )
        
        // Get the current user and update the UI
        let tabbar = tabBarController as! UserTabBarController
        
        // Get the admin and sort the friends
        if let myUser = tabbar.currentUser{
            myUser.friends = myUser.friends.sorted(by: < )
        }
        currentUser = tabbar.currentUser
        
        tableView.reloadData()
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Button's Actions
    
    // Edit button
//    @IBAction func editButtonPressed(_ sender: Any) {
//        let tableViewEditingMode = tableView.isEditing
//        tableView.setEditing( !tableViewEditingMode, animated: true)
//    }
    
 
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - Table view data source

    // sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // count per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return currentUser?.friends.count ?? 0
        }else{
            return 0
        }
    }
    
    // display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendTableViewCell
        
        
        // updating the cell
        if let friend = currentUser?.friends[ indexPath.row ] {
            cell.update(with: friend )
            cell.showsReorderControl = true
        }
        
        return cell
    }
    
    // editing ( re ordering )
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if let movedFriend = currentUser?.friends.remove( at: sourceIndexPath.row ) {
            currentUser?.friends.insert(movedFriend, at: destinationIndexPath.row )
            tableView.reloadData()
        }
        
    }
    
    // lets edit the cells
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Adds delete to the editing capabilities
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // deletes a friend when requested
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let currentUser = currentUser else { return }
            
            // delete the friend from the table view
            let deletedFriend = currentUser.friends.remove(at: indexPath.row )
            tableView.deleteRows(at: [indexPath], with: .automatic )
            
            // delete friend from the cloud
            deleteFriendFromDB( deletedFriend )
            
        }
    }
    
    // changes the height of the cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65 //or whatever you need
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - View Transitions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentUser = currentUser else {return}
        // Show a friend's detail
        if segue.identifier == "showDetails" {
            let destinationVC = segue.destination as! FriendInfoViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedFriend = currentUser.friends[ indexPath.row ]
            destinationVC.friend = selectedFriend
            destinationVC.currentUserID = currentUser.id
            destinationVC.delegate = self
        }
            
        // Add a new friend
        else if segue.identifier == "addFriend" {
            let destinationVC = segue.destination as! UINavigationController
            let nextViewController = destinationVC.viewControllers[0] as! FriendInfoViewController
            nextViewController.delegate = self
            nextViewController.currentUserID = currentUser.id
        }
    }
    
    ////////////////////////////////////////////////////////////
    // MARK: CLOUD/DB
    
    // delete a friend from the DB
    func deleteFriendFromDB( _ friend: Friend) {
        let parameters: Parameters = ["infoRequested": "postDeleteFriend",
                                      "id": friend.id,
                                      "friendImageName" : friend.imageName]
        let url = "http://doorlockvm.eastus.cloudapp.azure.com:5000/sqlQuery"
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { response in
            if response.result.isSuccess {
                
                
            }else{
                // SHOW ERROR MESSAGE
                
            }
        }
        
    }


}
