//
//  addAdminViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 3/18/19.
//  Copyright © 2019 WPI. All rights reserved.
//


import UIKit
// Protocol
// Triggered when the user adds a new admin
protocol ChangeAdminInfoDelegate{
    func addNewAdmin( with admin: AdminInfo )
}

class addAdminViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
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
        
        // TESTING PURPOSES
        let testAdmins = [
            AdminInfo( 5, "Kristiano", "dicka" ),
            AdminInfo( 8, "FirstName", "LastName" )
        ]
        admins = testAdmins
        
        // update the view
        tableView.reloadData()
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
                
            })

            alert.addAction( okayAction )
            alert.addAction( cancelAction )
            self.present(alert, animated: true, completion: nil)
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
