//
//  NotificationsCell.swift
//  SocraticaPlus
//
//  Created by inlusr1 on 12/02/19.
//  Copyright © 2019 Gaian. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {

    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var indicatorLbl: UILabel!
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var languageLbl: UILabel!
    
    @IBOutlet weak var discriptionLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.indicatorView.layer.cornerRadius = 5.0;
        self.indicatorView.layer.masksToBounds = true
        
        self.innerView.layer.cornerRadius = 15.0;
        self.innerView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
