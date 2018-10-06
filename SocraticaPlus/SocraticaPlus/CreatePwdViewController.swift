//
//  CreatePwdViewController.swift
//  SocraticaPlus
//
//  Created by gaian  on 10/5/18.
//  Copyright © 2018 Gaian. All rights reserved.
//

import UIKit

class CreatePwdViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var confirmPwdTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        
        guard let text = pwdTxtField.text, !text.isEmpty else {
            
            return
        }
        guard let text1 = confirmPwdTxtField.text, !text1.isEmpty else {
            
            return
        }
        if pwdTxtField.text != confirmPwdTxtField.text
        {
            let alert = UIAlertController.init(title: "", message: "Password and confirm password are not matched", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default) { (alert) in
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
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
