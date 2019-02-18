//
//  UserMainViewController.swift
//  smartLock
//
//  Created by Augusto Wong  on 12/4/18.
//  Copyright © 2018 WPI. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class UserMainViewController: UIViewController {
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: UI/UX
//    @IBOutlet weak var screenImageView: UIImageView!
    @IBOutlet weak var liveStreamWebView: WKWebView!
    
    
    ///////////////////////////////////////////////////////////////////////////////
    // MARK: Useful Variables
    var userAugusto : User?

    ///////////////////////////////////////////////////////////////////////////////
    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //screenImageView.image = UIImage(named: "tempHomeImage")
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [ NSAttributedString.Key.foregroundColor: UIColor.white ]
        
     
        
       
    }
    
    @IBAction func liveButtonPressed(_ sender: Any) {
        let myURL = URL(string:"http://doorlockmqpboard.ddns.net:8000/index.html")
        let myRequest = URLRequest(url: myURL!)
        
        liveStreamWebView.load(myRequest)
        print("End of liveButtonPressed")
    }
    
    @IBAction func readFromCloud(_ sender: Any) {
        
        let parameters: Parameters = ["infoRequested": "allUsersInfo"]     //This will be your parameter, infoRequested is gonna be the keyword we can check and allUsersInfo will be a string about what iPhone needs from the Flask Server
        let ipAddress = "23.96.59.16"
        let url = "http://\(ipAddress):5000/sqlQuery"
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response)
        }
        
        // storing a user in the db, by sending request to Flask server
        let parameters2: Parameters = [
            "addUsers" : [
                "5" : [
                    "first" : "Aleksander",
                    "last" : "Ibro",
                    "email" : "aibro@wpi.edu"
                ],
                "4" : [
                    "first" : "Kristiano",
                    "last" : "Bejko",
                    "email" : "kbejko@wpi.edu"
                ]
            ]
        ]
//        let parameters2 : Parameters = [
//            "users" : "Aleksander should be here"
//        ]
//        let url2 = "http://52.168.123.64:5000/user"
        
        Alamofire.request(url, method: .post, parameters: parameters2, encoding: JSONEncoding.default)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
