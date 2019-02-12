//
//  NotificationsViewController.swift
//  SocraticaPlus
//
//  Created by inlusr1 on 12/02/19.
//  Copyright © 2019 Gaian. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var notificationsTblView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "NotificationsCell", bundle: nil)
        self.notificationsTblView.register(nib, forCellReuseIdentifier: "NotificationCell")
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        return customCell
    }
}
