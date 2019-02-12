//
//  ReportsViewController.swift
//  SocraticaPlus
//
//  Created by inlusr1 on 12/02/19.
//  Copyright © 2019 Gaian. All rights reserved.
//

import UIKit

class ReportsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
    

    @IBOutlet weak var reportsTableView: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ReportsCell", bundle: nil)
        self.reportsTableView.register(nib, forCellReuseIdentifier: "ReportsCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportsCell", for: indexPath)
        
        return cell
    }

}
