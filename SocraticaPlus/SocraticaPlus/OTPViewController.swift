//
//  OTPViewController.swift
//  SocraticaPlus
//
//  Created by Gaian on 05/10/18.
//  Copyright © 2018 Gaian. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet weak var otpTextFied: UITextField!
    
    
    @IBOutlet weak var resendOTPBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBAction func goButtonClick(_ sender: Any) {
        
        guard let text = otpTextFied.text, !text.isEmpty else {
            
            let alert = UIAlertController.init(title: "", message: "Please enter verification code", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default) { (alert) in
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let createPwdVC = self.storyboard?.instantiateViewController(withIdentifier: "createPwdViewController") as! CreatePwdViewController
        self.navigationController?.pushViewController(createPwdVC, animated: true)
        
    }
    
    @IBAction func resendOTPBtnAction(_ sender: Any) {
        
        let alert = UIAlertController.init(title: "", message: "A verification code has been sent to your mobile number please enter the number to continue ", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (alert) in
            
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
