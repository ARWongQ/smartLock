//
//  TimelineTableViewController.swift
//  smartLock
//
//  Created by Mario Zyla on 3/26/19.
//  Copyright © 2019 WPI. All rights reserved.
//
import UIKit
import TimelineTableViewCell

class UserHistoryTableViewController: UITableViewController {
    
    
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate

    
    
    
    // TimelinePoint, Timeline back color, title, description, lineInfo, thumbnail, illustration
//    let data:[Int: [(TimelinePoint, UIColor, String, String, String?, String?, String?)]] = [0:[
//        (TimelinePoint(), UIColor.black, "12:30", "Mario unlocked the door.", nil, nil, "Sun"),
//        (TimelinePoint(), UIColor.black, "15:30", "You let a friend in.", nil, nil, "Sun"),
//        (TimelinePoint(color: UIColor.green, filled: true), UIColor.green, "16:30", "Augusto unlocked the door", "150 mins", "Apple", "Sun"),
//        (TimelinePoint(), UIColor.clear, "19:00", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", nil, nil, "Moon")
//        ], 1:[
//            (TimelinePoint(), UIColor.lightGray, "08:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "60 mins", nil, "Sun"),
//            (TimelinePoint(), UIColor.lightGray, "09:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", "30 mins", nil, "Sun"),
//            (TimelinePoint(), UIColor.lightGray, "10:00", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "90 mins", nil, "Sun"),
//            (TimelinePoint(), UIColor.lightGray, "11:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "60 mins", nil, "Sun"),
//            (TimelinePoint(), UIColor.lightGray, "12:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "30 mins", "Apple", "Sun"),
//            (TimelinePoint(), UIColor.lightGray, "13:00", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "120 mins", "Apple", "Sun"),
//            (TimelinePoint(), UIColor.lightGray, "15:00", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "150 mins", "Apple", "Sun"),
//            (TimelinePoint(), UIColor.lightGray, "17:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", "60 mins", nil, "Sun"),
//            (TimelinePoint(), UIColor.lightGray, "18:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", "60 mins", nil, "Moon"),
//            (TimelinePoint(), UIColor.lightGray, "19:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", "30 mins", nil, "Moon"),
//            (TimelinePoint(), backColor: UIColor.clear, "20:00", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", nil, nil, "Moon")
//        ]]
    
    var data: [Int: [(TimelinePoint, UIColor, String, String, String?, String?, String?)]] = [0: [(TimelinePoint(), UIColor.black, "10:54", "Mario opened the door", nil, nil, "Sun")]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Sets the title large and white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes =
            [ NSAttributedString.Key.foregroundColor: UIColor.white ]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle(for: TimelineTableViewCell.self))
        self.tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")

        
        /* Azure Client for SQL DB access */
        let azureClient = myAppDelegate.client
        
        
//        var activities:[Int: [(TimelinePoint, UIColor, String, String, String?, String?, String?)]] = [:]
//        [0:[
//            (TimelinePoint(), UIColor.black, "12:30", "Mario unlocked the door.", nil, nil, "Sun")
        let activityTable = azureClient.table(withName: "Activity")
        
        activityTable.read() { (result, error) in
            if let err = error {
                print("Error reading activityTable ", err)
            } else if let DBactivities = result?.items {
                print("Result", result!.items)
                print("DBactivities", DBactivities)
                var dayCount = 0
                
                for thisActivity in DBactivities {
                    print("thisActivity", thisActivity)
                    var activity_dttm = thisActivity["activity_dttm"] as! String
//                    let yearStartIndex = activity_dttm.startIndex
//                    let yearEndIndex = String.Index(encodedOffset: 4)
//                    var year = String(activity_dttm[yearStartIndex..<yearEndIndex])
//                    print("year", year)
//
//                    let monthStartIndex = activity_dttm.index(activity_dttm.startIndex, offsetBy: 5)
//                    let monthEndIndex = activity_dttm.index(activity_dttm.startIndex, offsetBy: 7)
//                    var month = String(activity_dttm[monthStartIndex..<monthEndIndex])
                    
//                    let dayStartIndex = activity_dttm.index(activity_dttm.startIndex, offsetBy: 6)
//                    let dayEndIndex = activity_dttm.index(activity_dttm.endIndex, offsetBy: 8)
//                    var day = Int(activity_dttm[dayStartIndex..<dayEndIndex])
                    
//                    let hourStartIndex = activity_dttm.index(activity_dttm.startIndex,offsetBy: 9)
//                    let hourEndIndex = activity_dttm.index(activity_dttm.startIndex, offsetBy: 11)
//                    var hour = String(activity_dttm[hourStartIndex..<hourEndIndex])
//                    print("hour", hour)
//
//                    let minutesStartIndex = activity_dttm.index(activity_dttm.startIndex, offsetBy: 12)
//                    let minutesEndIndex = activity_dttm.index(activity_dttm.startIndex, offsetBy: 14)
//                    var minutes = String(activity_dttm[minutesStartIndex..<minutesEndIndex])
//                    print("minutes", minutes)
                    
                    let hoursAndMinutesStartIndex = activity_dttm.index(activity_dttm.startIndex, offsetBy: 9)
                    let hoursAndMinuesEndIndex = activity_dttm.index(activity_dttm.startIndex, offsetBy: 14)
                    var hoursAndMinutes = String(activity_dttm[hoursAndMinutesStartIndex..<hoursAndMinuesEndIndex])
                    print("hoursAndminutes", hoursAndMinutes)
                    


                }
                
                
                print("Should have created the table")
            }
        }
        

        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sectionData = data[section] else {
            return 0
        }
        return sectionData.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Today"
        } else if (section == 1) {
            return "Yesterday"
        }
        return "Day " + String(describing: section + 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
        
        // Configure the cell...
        guard let sectionData = data[indexPath.section] else {
            return cell
        }
        
        print("sectionData", sectionData)
        
        let (timelinePoint, timelineBackColor, title, description, lineInfo, thumbnail, illustration) = sectionData[indexPath.row]
        var timelineFrontColor = UIColor.clear
        if (indexPath.row > 0) {
            timelineFrontColor = sectionData[indexPath.row - 1].1
        }
        cell.timelinePoint = timelinePoint
        cell.timeline.frontColor = timelineFrontColor
        cell.timeline.backColor = timelineBackColor
        cell.titleLabel.text = title
        cell.descriptionLabel.text = description
        cell.lineInfoLabel.text = lineInfo
        if let thumbnail = thumbnail {
            cell.thumbnailImageView.image = UIImage(named: thumbnail)
        }
        else {
            cell.thumbnailImageView.image = nil
        }
        if let illustration = illustration {
            cell.illustrationImageView.image = UIImage(named: illustration)
        }
        else {
            cell.illustrationImageView.image = nil
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionData = data[indexPath.section] else {
            return
        }
        
        print(sectionData[indexPath.row])
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

