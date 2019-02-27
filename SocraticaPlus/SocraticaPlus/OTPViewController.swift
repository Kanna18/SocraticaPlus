//
//  OTPViewController.swift
//  SocraticaPlus
//
//  Created by Gaian on 05/10/18.
//  Copyright © 2018 Gaian. All rights reserved.
//

import UIKit
import ZVProgressHUD

class OTPViewController: UIViewController {
   
    
    @IBOutlet weak var otpTextFied: UITextField!
    
    @IBOutlet weak var resendOTPBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var phoneNumberWhileForgot = String()
    var passwordWhileRegistration = String()
    var isRegistrationOTP = false
    var isForgotPasswordOTP = false
    
    @IBAction func goButtonClick(_ sender: Any) {
        
        guard let textOtp = otpTextFied.text, !textOtp.isEmpty else {
            
            let alert = UIAlertController.init(title: "", message: "Please enter verification code", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default) { (alert) in
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
//        let createPwdVC = self.storyboard?.instantiateViewController(withIdentifier: "createPwdViewController") as! CreatePwdViewController
//        self.navigationController?.pushViewController(createPwdVC, animated: true)
        ZVProgressHUD.show()
        if(isRegistrationOTP){
            self.verifyOTPforRegistrarion()
        }
        else if(isForgotPasswordOTP){
            self.verifyOTPforForgotPassword()
        }else{
            DispatchQueue.main.async {
            ZVProgressHUD.showText("error",in:self.view)
            }
        }
        
    }
    //MARK: Registration Flow
    func verifyOTPforRegistrarion() {
        let url = "\(ServiceDataConst.kRegistrationConfirmphone)"
        let requestURL = URL.init(string: url);
        var request = URLRequest.init(url: requestURL!)
        let refDict = SocraticaSharedClass.shared.registrationDict
        
        let json = "{\"phoneNumber\":\"\(refDict["phone"] as! String)\",\"email\":\"\(refDict["email"] as! String)\",\"token\":\"\(otpTextFied.text!)\"}"
        request.httpBody = json.data(using: .utf8)
        SocraticaWebserviceCalls().sendPOST(request, withSuccess: { (data) in
            ZVProgressHUD.dismiss()
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            do{
                let myDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
//                self.movetoTabbarAfterOTPisverifiedforRegistration(boolVal: (myDict!["status"] as! Bool))
                print("otp succes string \(myDict!["status"] as! Bool)")
                if((myDict!["status"] as! Bool) == true){
                self.perform(#selector(self.movetoTabbarAfterOTPisverifiedforRegistration(boolVal:)), on: .main, with: (myDict!["status"] as! Bool), waitUntilDone: true)
                }else{
                    DispatchQueue.main.async {
                        ZVProgressHUD.showText("Please enter valid OTP",in:self.view)
                    }
                }
                print(myDict!)                                                
            }catch{
                print("Error")
            }
        }) { (error) in
            print(error?.localizedDescription as Any)
            ZVProgressHUD.dismiss()
        }
    }
    //MARK: ForgotPasswprd Flow
    func verifyOTPforForgotPassword() {
        let url = "\(ServiceDataConst.kVerifyOTPForgotPassword)"
        let requestURL = URL.init(string: url);
        var request = URLRequest.init(url: requestURL!)
        
        let json = "{\"phoneNumber\":\"\(phoneNumberWhileForgot)\",\"token\":\"\(otpTextFied.text!)\"}"
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
                 DispatchQueue.main.async {
                ZVProgressHUD.showText(myDict!["message"] as! String,in:self.view)
                }
                if((myDict!["status"] as! Bool) == true){
                self.perform(#selector(self.moveToChangePasswordVC(jsonDict:)), on: .main, with: myDict, waitUntilDone: true)
                }
            }catch{
                print("Error")
            }
        }) { (error) in
            print(error?.localizedDescription as Any)
            ZVProgressHUD.dismiss()
        }
    }
    
    @objc func moveToChangePasswordVC(jsonDict : [String : AnyObject]) {
        
        let createPwdVC = self.storyboard?.instantiateViewController(withIdentifier: "createPwdViewController") as! CreatePwdViewController
        createPwdVC.phoneNumber = phoneNumberWhileForgot
        createPwdVC.email = jsonDict["email"] as! String
        self.navigationController?.pushViewController(createPwdVC, animated: true)
    }
    
    @IBAction func backClick(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendOTPBtnAction(_ sender: Any) {
        
        let alert = UIAlertController.init(title: "", message: "A verification code has been sent to your mobile number please enter the number to continue ", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (alert) in
            
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        if(isForgotPasswordOTP){
         self.resendOTPforForgotPassword()
        }
        if(isRegistrationOTP){
            self.resendOTPforRegistrarion()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ZVProgressHUD.displayStyle = .dark
        ZVProgressHUD.animationType = .native

        // Do any additional setup after loading the view.
        self.title = "OTP"
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
    
    func resendOTPforForgotPassword() {
        let url = "\(ServiceDataConst.kForgotPassword)"
        let requestURL = URL.init(string: url);
        var request = URLRequest.init(url: requestURL!)
        
        let json = "{\"phoneNumber\":\"\(phoneNumberWhileForgot)\",\"isParentLogin\":\"\(true)\"}"
        request.httpBody = json.data(using: .utf8)
        SocraticaWebserviceCalls().sendPOST(request, withSuccess: { (data) in
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            do{
                let myDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
                print(myDict!)
            }catch{
                print("Error")
            }
        }) { (error) in
            print(error?.localizedDescription as Any)
            
        }
    }
    
    func resendOTPforRegistrarion() {
        let url = "\(ServiceDataConst.kParentRegistration)"
        let requestURL = URL.init(string: url);
        var request = URLRequest.init(url: requestURL!)
        
//        let refDict = SocraticaSharedClass.shared.registrationDict
        
        let json = "{\"phoneNumber\":\"\(phoneNumberWhileForgot)\",\"password\":\"\(passwordWhileRegistration)\",\"isParentLogin\":\"\(true)\"}"
        request.httpBody = json.data(using: .utf8)
        SocraticaWebserviceCalls().sendPOST(request, withSuccess: { (data) in
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            do{
                let myDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
                print(myDict!)
                SocraticaSharedClass.shared.registrationDict = myDict!
            }catch{
                print("Error")
            }
        }) { (error) in
            print(error?.localizedDescription as Any)
        }
    }
    @objc func movetoTabbarAfterOTPisverifiedforRegistration(boolVal : Bool) {
        
       
            let refDict = SocraticaSharedClass.shared.registrationDict
            let tabB = self.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
            self.navigationController?.pushViewController(tabB, animated: true)
            let defa = UserDefaults.standard
            defa.set(phoneNumberWhileForgot , forKey: savedPhoneNumber)
            defa.set(passwordWhileRegistration , forKey: savedPassword)
      
        
    }

}
