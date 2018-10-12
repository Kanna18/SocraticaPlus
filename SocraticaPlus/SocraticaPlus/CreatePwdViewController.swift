//
//  CreatePwdViewController.swift
//  SocraticaPlus
//
//  Created by gaian  on 10/5/18.
//  Copyright © 2018 Gaian. All rights reserved.
//

import UIKit
import ZVProgressHUD

class CreatePwdViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var confirmPwdTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ZVProgressHUD.displayStyle = .dark
        confirmPwdTxtField.delegate = self
        pwdTxtField.delegate = self
        self.title = "Create password"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backClick(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtnAction(_ sender: Any) {
        
        guard let text = pwdTxtField.text, !text.isEmpty else {
            ZVProgressHUD.showWarning(with: "password field shoud not be empty")
            return
        }
        guard let text1 = confirmPwdTxtField.text, !text1.isEmpty else {
            ZVProgressHUD.showWarning(with: "confirm password filed  shoud not be empty")
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
            let tabB = self.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
            
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            self.navigationController?.pushViewController(tabB, animated: true)
        }
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate
        let count  = 6
        
        if textField == pwdTxtField{
        guard (textField.text?.count)! < count else {
            return true
        }
         ZVProgressHUD.showWarning(with: "Password should contain 6 charaters", in: self.view, delay: 0.0)
        return false
        }else{
            return true
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
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
//        NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "{6,}")
        return passwordTest.evaluate(with: testStr)
    }

}
