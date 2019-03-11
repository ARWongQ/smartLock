//
//  AdminTableViewCell.swift
//  smartLock
//
//  Created by Augusto Wong  on 2/26/19.
//  Copyright © 2019 WPI. All rights reserved.
//

import UIKit

class AdminTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageF: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // MARK: UI Functions
    // Updates the cell view
    func update( with friend: AdminInfo ){
        print("Inside admin")
        fullNameLabel.text = "\(friend.firstName) \(friend.lastName)"
        
        imageF.layer.cornerRadius = 24.5
        imageF.clipsToBounds = true
        imageF.layer.borderWidth = 0.5
        imageF.layer.borderColor = UIColor.black.cgColor
        imageF.image = friend.image

    }
    
}
