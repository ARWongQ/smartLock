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
    // MARK: Structs
    // all setting information
    struct segmentValues {
        static let friends = 0
        static let admins = 1
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Useful Variables
    var currentUser: User?
    var segmentValue: Int!
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: UI/UX

    
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set proper view
        segmentValue = segmentValues.friends
        tableView.tableFooterView = UIView( frame: .zero )
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        
        // Sets the title large and white
        navigationController?.navigationBar.topItem?.title = "Guests"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes =
            [ NSAttributedString.Key.foregroundColor: UIColor.white ]
        
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( true )
        
        // Get the current user and update the UI
        let tabbar = tabBarController as! UserTabBarController
        
        // Get the user and sort the friends and admins
        if let myUser = tabbar.currentUser{
            myUser.friends = myUser.friends.sorted(by: < )
            myUser.admins = myUser.admins.sorted( by: < )
        }
        currentUser = tabbar.currentUser
        
        // update the view
        tableView.reloadData()

        
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Button's Actions
    
    // Edit button
//    @IBAction func editButtonPressed(_ sender: Any) {
//        let tableViewEditingMode = tableView.isEditing
//        tableView.setEditing( !tableViewEditingMode, animated: true)
//    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        // alerts
        let alertController = UIAlertController( title: "Choose to add ", message: nil, preferredStyle: .actionSheet )
        
        // create actions
        let cancelAction = UIAlertAction( title: "Cancel", style: .cancel, handler: nil )
        let adminAction = UIAlertAction( title: "Admin", style: .default, handler: nil )
        let friendAction = UIAlertAction( title: "Friend", style: .default, handler: { action in
            // proper view
            self.performSegue(withIdentifier: "addFriend", sender: self )
            
        })
        
        // add actions
        alertController.addAction( adminAction )
        alertController.addAction( friendAction )
        alertController.addAction( cancelAction )
        
        alertController.popoverPresentationController?.sourceView = sender as! UIButton
        
        present( alertController, animated: true, completion: nil )
    }
    
    
    // changes views between Friends and Admins
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        if segmentValue == segmentValues.friends{
            segmentValue = segmentValues.admins
        }else{
            segmentValue = segmentValues.friends
        }
        
        // reload useful info
        tableView.reloadData()
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - Table view data source

    // sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // count per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows: Int
        if segmentValue == segmentValues.friends{
            numRows = currentUser?.friends.count ?? 0
        }else{
            numRows = currentUser?.admins.count ?? 0
        }
        return numRows

    }
    
    // display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        // display friends
        if segmentValue == segmentValues.friends {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendTableViewCell

            // updating the cell
            if let friend = currentUser?.friends[ indexPath.row ] {
                cell.update(with: friend )
                cell.showsReorderControl = true
            }
            return cell
            
        // display admins
        }else{
            // TODO: NEED TO USE THE PROPER SHIT
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminCell", for: indexPath) as! AdminTableViewCell

            // updating the cell
            if let admin = currentUser?.admins[ indexPath.row ] {
                cell.update(with: admin )
                cell.showsReorderControl = true
            }
            return cell
            
        }

    }
    
    // editing ( re ordering )
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//        if let movedFriend = currentUser?.friends.remove( at: sourceIndexPath.row ) {
//            currentUser?.friends.insert(movedFriend, at: destinationIndexPath.row )
//            tableView.reloadData()
//        }
//
//    }
    
    // lets edit the cells
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Adds delete to the editing capabilities
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // deletes a friend when requested
    override func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let currentUser = currentUser else { return }
            
            // delete a friend
            // TODO: Need to send push notification when deleting invalid friend
            if segmentValue == segmentValues.friends{
                // delete the friend from the table view
                let deletedFriend = currentUser.friends.remove(at: indexPath.row )
                tableView.deleteRows(at: [indexPath], with: .automatic )

                // delete friend from the cloud
                deleteFriendFromDB( deletedFriend )
            }else{
                // TODO: Delete an Admin
            }
            
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
