//
//  addAdminViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 3/18/19.
//  Copyright © 2019 WPI. All rights reserved.
//


import UIKit
import FirebaseAuth
import Alamofire

// Protocol
// Triggered when the user adds a new admin
protocol ChangeAdminInfoDelegate{
    func addNewAdmin( with admin: AdminInfo )
}

class addAdminViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else { return }
        
        // Filter the data array and get only those countries that match the search text.
        // Instead of filtering admins we should pull from the database and populate filteredAdmins with the proper "admins"
        // based on searchString
        filteredAdmins = admins.filter({ (admin) -> Bool in
            let adminFullName = "\(admin.firstName) \(admin.lastName)"

            return adminFullName.lowercased().contains( searchString.lowercased() )
        })
        
        
        // Reload the tableview.
        tableView.reloadData()
    }
    
    
    // makes the filteredArray the data source of the tableView
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        print("YOU PIECE OF SHIT")
        tableView.reloadData()
    }
    
    // makes the dataArray as the datasource
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            print("should be the same as HOE 2")
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Useful Variables
    var delegate : ChangeAdminInfoDelegate?
    var currentUserID: Int?
    
    var admins = [AdminInfo]()
    var filteredAdmins = [AdminInfo]()
    var shouldShowSearchResults = false
    let searchController = UISearchController(searchResultsController: nil)

    ///////////////////////////////////////////////////////////////////////////////
    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set main UI
        tableView.tableFooterView = UIView( frame: .zero )
        
//        // TESTING PURPOSES
//        let testAdmins = [
//            AdminInfo( 5, "Kristiano", "dicka" ),
//            AdminInfo( 8, "FirstName", "LastName" )
//        ]
        
        // Get all admins from the Azure SQL DB. Admins are just users from App_User table
        var AzureAdmins : [[AnyHashable : Any]] = []
        let azureClient = myAppDelegate.client
        let appUserTable = azureClient.table(withName: "App_User")
        appUserTable.read() { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let users = result?.items {
                print("Populating Admins")
                for user in users {
                    self.admins.append(self.createAdminInfo(user: user))
                }
                // update the view
                self.tableView.reloadData()
                
            }
        }
        //admins = testAdmins
        

        // set the search bar
        configureSearchController()
        
        // add searchbar programatically
//        let searchBar = UISearchBar()
//        searchBar.sizeToFit()
//        searchBar.barTintColor = UIColor.black
//        navigationItem.titleView = searchBar
        
        
    
        
    }
    func configureSearchController(){
        // set the search controller properties
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false      // might not need this
        searchController.searchBar.sizeToFit()
        
        //searchController.searchBar.barTintColor = UIColor.red
        searchController.searchBar.barStyle = UIBarStyle.black
        searchController.searchBar.isTranslucent = false
    


        
        
        // sets the cancel button to be white
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.white
        
        
        
        navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        
        // Sets the title large and white
        navigationController?.navigationBar.topItem?.title = "Add Admins"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes =
            [ NSAttributedString.Key.foregroundColor: UIColor.white ]
        
        
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Button's Actions
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        // go back
        self.dismiss( animated: true, completion: nil )
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: - Table view data source
    
    // sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // count per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows: Int
        if shouldShowSearchResults {
            numRows = filteredAdmins.count
        }else{
            numRows = admins.count
        }
        
        return numRows
    }
    
    // changes the height of the cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65 //or whatever you need
    }
    
    // display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // TODO: NEED TO USE THE PROPER SHIT
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminCell", for: indexPath) as! AdminTableViewCell
        
        // updating the cell
        if shouldShowSearchResults{
            let admin = filteredAdmins[ indexPath.row ]
            cell.update(with: admin )
            cell.showsReorderControl = true
            
        }else{
            let admin = admins[ indexPath.row ]
            cell.update(with: admin )
            cell.showsReorderControl = true
        }

        return cell
        
    }
    
    // logic when an item is pressed
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("HOE")
        // Do here
        if shouldShowSearchResults{
            // show alert to make sure they want to add this admin
            print("HOE2")
            let currAdmin = filteredAdmins[ indexPath.row ]
            let fullName = "\(currAdmin.firstName) \(currAdmin.lastName)"
            let alert = UIAlertController(title: "Adding Admin", message: "Do you want to add \(fullName) ?", preferredStyle: .alert)
            let cancelAction = UIAlertAction( title: "Cancel", style: .cancel, handler: nil )
            let okayAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                //add the admin!
                self.delegate?.addNewAdmin(with: currAdmin )
                self.searchController.isActive = false
                self.dismiss( animated: true, completion: nil )
                
                // add new Admin to App_User_Added
                self.addAdminToDB(admin: currAdmin)
                
            })

            alert.addAction( okayAction )
            alert.addAction( cancelAction )
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    //Creates a user
    func createAdminInfo( user: [AnyHashable : Any]) -> AdminInfo {
        print("CREATING Admin Info")
        // Create the user
        let id = user["id"] as! Int
        let firstN = user["firstName"] as! String
        let lastN = user["lastName"] as! String
        let email = user["email"] as! String
        let password = user["userPassword"] as! String
        var myAdminInfo = AdminInfo( Int(id), firstN, lastN)
        setImageFromDB(myAdminInfo)
        
        
        return myAdminInfo
    }
    
    // creates a relation between signed in user and the admin/user he is adding
    func addAdminToDB(admin: AdminInfo) {
        print("Adding an admin to DB")
        // get id of current user
        // NOTE: this should probably just be currentUserId, but that is null for some reason
        
        // get email from Firebase
        let user = Auth.auth().currentUser
        let loggedInEmail = user!.email
        print("addAdminToDb: loggedInEmail ", loggedInEmail)
        // pulling id of logged in user from the DB
            // Create a predicate that finds users with the given email
        var predicate =  NSPredicate(format: "email = %@", loggedInEmail!)
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let client = delegate.client
            let appUserTable = client.table(withName: "App_User")
            appUserTable.read(with : predicate) { (result, error) in
                if let err = error {
                    print("ERROR ", err)
                } else if let users = result?.items {
                    // users contains all users with matching predicate (only 1)
                    let userId = users[0]["id"]
                    let admin = ["addedUserId" : String(admin.id), "addingUserId" : userId]
                    let itemTable = client.table(withName: "App_User_Added")
                    //client.getTable("App_User").insert(item)
                    itemTable.insert(admin) {
                        (insertedItem, error) in
                        if (error != nil) {
                            print("Error" + error.debugDescription);
                        } else {
                            print("Admin inserted")
                        }
                    }
                }
        }
    }
    
    // get the image from the Db for a requested admin
    func setImageFromDB( _ admin: AdminInfo){
        print("Getting picture ", admin.imageName)
        let parameters: Parameters = ["friendImageName": admin.imageName ]
        let url = "http://doorlockvm.eastus.cloudapp.azure.com:5000/getFriendImage"
        Alamofire.request(url, method: .get, parameters: parameters).responseImage { response in
            if response.result.isSuccess {
                // show the image from the DB
                print("SETTING IMAGE OF ADMIN")
                admin.image = response.result.value!
            }else{
                // set temp image
                print("No image received for this admin")
                admin.image = UIImage(named: "img_placeholder")!
                
            }
        }
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("You selected cell #\(indexPath.row)!")
//    }
//
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("FCGVHBJNKNVBC NM")
//        if shouldShowSearchResults{
//            print( filteredAdmins[indexPath.row] )
//        }else{
//            print( admins[indexPath.row] )
//        }
//
//    }
            
    

}
