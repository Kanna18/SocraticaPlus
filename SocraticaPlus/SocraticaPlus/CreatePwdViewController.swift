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

    var phoneNumber = String()
    var email = String()

    @IBOutlet weak var confirmPwdTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ZVProgressHUD.displayStyle = .dark
        confirmPwdTxtField.delegate = self
        pwdTxtField.delegate = self
        self.title = "Create password"
        
        if #available(iOS 12, *) {
            // iOS 12: Not the best solution, but it works.
            pwdTxtField.textContentType = .oneTimeCode
            confirmPwdTxtField.textContentType = .oneTimeCode
        } else {
            // iOS 11: Disables the autofill accessory view.
            // For more information see the explanation below.
            pwdTxtField.textContentType = .init(rawValue: "")
            confirmPwdTxtField.textContentType = .init(rawValue: "")
        }
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
            self.createaNewPassword()
            ZVProgressHUD.show()
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

    func createaNewPassword() {
        let url = "\(ServiceDataConst.kChangePasswordPassword)"
        let requestURL = URL.init(string: url);
        var request = URLRequest.init(url: requestURL!)
        
        let json = "{\"phoneNumber\":\"\(phoneNumber)\",\"password\":\"\(confirmPwdTxtField.text!)\",\"VerifyPassword\":\"\(confirmPwdTxtField.text!)\",\"email\":\"\(email)\"}"
        request.httpBody = json.data(using: .utf8)
        SocraticaWebserviceCalls().sendPOST(request, withSuccess: { (data) in
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            do{
                let myDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
                print(myDict!)
                
                ZVProgressHUD.showText(myDict?["message"] as! String)
                self.perform(#selector(self.movetologinVC), on: .main, with: nil, waitUntilDone: true)
            }catch{
                print("Error")
            }
        }) { (error) in
            print(error?.localizedDescription as Any)
        }
    }
    @objc func movetologinVC() {
        ZVProgressHUD.dismiss()
        let tabB = self.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
        self.navigationController?.pushViewController(tabB, animated: true)
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
