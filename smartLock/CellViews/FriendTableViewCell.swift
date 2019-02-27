//
//  FriendTableViewCell.swift
//  smartLock
//
//  Created by Augusto Wong  on 1/29/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FriendTableViewCell: UITableViewCell {
    
    // MARK: UI/UX
    @IBOutlet weak var imageF: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // MARK: UI Functions
    // Updates the cell view
    func update( with friend: Friend ){
        print( friend )
        fullNameLabel.text = "\(friend.firstName) \(friend.lastName)"
        
        //imageF.image = friend.image
        imageF.layer.cornerRadius = 24.5
        imageF.clipsToBounds = true
        imageF.layer.borderWidth = 0.5
        imageF.layer.borderColor = UIColor.black.cgColor
        imageF.image = friend.image
        setWeekDaysLabels( with: friend )
    }
    
    // Sets the weekdays labels
    func setWeekDaysLabels( with friend: Friend ){
        let allWeekLabels = [ sundayLabel, mondayLabel, tuesdayLabel, wednesdayLabel, thursdayLabel, fridayLabel, saturdayLabel ]
        let weekDays = [ "S", "M", "T", "W", "T", "F", "S" ]
        for i in 0...6{
            guard let currLabel = allWeekLabels[ i ] else { return }
            currLabel.text = weekDays[ i ]
            if ( friend.comeInDays[ i ] ){
                currLabel.textColor = UIColor.black
            }else{
                currLabel.textColor = UIColor.lightGray
            }
        }
    }
    
}
