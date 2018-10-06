//
//  CustomLabel.swift
//  SocraticaPlus
//
//  Created by gaian  on 10/5/18.
//  Copyright © 2018 Gaian. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: "Poppins-Regular", size: 12.0)        
    }
}
