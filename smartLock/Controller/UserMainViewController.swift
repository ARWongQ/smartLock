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
        
//        guard let data = "SELECT * from App_User;"
        let parameters: Parameters = ["query": "SELECT * from App_User"]     //This will be your parameter
        let url = "http://40.114.87.162:5000/sqlQuery"
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response)
        }
        
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
