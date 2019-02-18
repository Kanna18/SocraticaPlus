//
//  ChatViewController.swift
//  SocraticaPlus
//
//  Created by inlusr1 on 18/02/19.
//  Copyright © 2019 Gaian. All rights reserved.
//

import UIKit
import ZVProgressHUD
class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func removeParentTapped(_ sender: UIButton) {
        let url = "\(ServiceDataConst.kParentLogin)"
        let requestURL = URL.init(string: url);
        var request = URLRequest.init(url: requestURL!)
        
        
        let json = "{\"email\":\"admin12@gmail.com\",\"password\":\"Welcome1!\"}"
//        let parentToken = defa.value(forKey: "parentToken") as! String
//
//        request.setValue("Bearer \(parentToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = json.data(using: .utf8)
        SocraticaWebserviceCalls().sendPOST(request, withSuccess: { (data) in
           // ZVProgressHUD.dismiss()
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            do{
                let myDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
                print(myDict!)
                self.perform(#selector(self.removeParentProfile(dict: )), on: .main, with: myDict, waitUntilDone: true)
            }catch{
                print("Error")
            }
        }) { (error) in
            print(error?.localizedDescription as Any)
            ZVProgressHUD.dismiss()
            
        }
        
    }
    
    @objc func removeParentProfile(dict : Dictionary<String, AnyObject>){
        
        let url = "\(ServiceDataConst.kRemoveParentProfile)"
        let requestURL = URL.init(string: url);
        var request = URLRequest.init(url: requestURL!)
        let defa = UserDefaults.standard
        let phoneNumber = defa.value(forKey: savedPhoneNumber) as! String
         let json = "{\"phoneNumber\":\"\(phoneNumber)\"}"
        let parentToken = dict["token"] as! String
        print("parent tokent \(parentToken)")
         request.setValue("Bearer \(parentToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = json.data(using: .utf8)
        SocraticaWebserviceCalls().sendPOST(request, withSuccess: { (data) in
             ZVProgressHUD.dismiss()
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            do{
                let myDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
                print(myDict!)
                if (myDict!["status"] as! Bool == false){
                 
                      self.perform(#selector(self.presentAlertonMainThread(dic:)), on: .main, with: myDict, waitUntilDone: true)
                    
                }else{
                    self.perform(#selector(self.presentLoginViewController), on: .main, with: nil, waitUntilDone: true)
                }
                
               
               
            }catch{
                print("Error")
            }
        }) { (error) in
            print(error?.localizedDescription as Any)
            ZVProgressHUD.dismiss()
            
        }
        
    
    }
    
    @objc func presentLoginViewController(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "navLoginController") as! UINavigationController
        
        self.present(vc, animated: true, completion: nil)
    }
    @objc func presentAlertonMainThread(dic:Dictionary<String,AnyObject>){
        let alert = UIAlertController(title: "Socratica", message: (dic["message"] as! String), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        })
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}


