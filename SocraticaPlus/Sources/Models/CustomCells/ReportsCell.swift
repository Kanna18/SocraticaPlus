//
//  ReportsCell.swift
//  SocraticaPlus
//
//  Created by inlusr1 on 12/02/19.
//  Copyright © 2019 Gaian. All rights reserved.
//

import UIKit

class ReportsCell: UITableViewCell {

    @IBOutlet weak var leftImgView: UIImageView!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var nextBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
       
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
