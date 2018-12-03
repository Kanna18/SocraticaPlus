//
//  ForgotPasswordVC.swift
//  SocraticaPlus
//
//  Created by Gaian on 09/10/18.
//  Copyright © 2018 Gaian. All rights reserved.
//

import UIKit
import ZVProgressHUD

class ForgotPasswordVC: UIViewController {
        
    @IBOutlet weak var phoneTextField: NKVPhonePickerTextField!    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden  = true
        ZVProgressHUD.displayStyle = .dark
        self.pickerTextfield()
        self.title = "Forgot password"
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendtoOTPScreen(_ sender: Any) {
        guard let phoneNum =  phoneTextField.phoneNumber, phoneNum.isPhoneNumber else {
            ZVProgressHUD.showWarning(with: "please enter a valid phone number", in: self.view, delay: 0.0)
            return
        }
        self.forgotPasswordFunction()
        
        
    }
    func pickerTextfield() {
        
        phoneTextField.phonePickerDelegate = self
        //        phoneTxtField.favoriteCountriesLocaleIdentifiers = ["RU", "ER", "JM"]
        phoneTextField.enablePlusPrefix = true
        // Setting initial custom country
        let country = Country.country(for: NKVSource.init(countryCode: Locale.isoCurrencyCodes[0]))
        phoneTextField?.country = country
        phoneTextField.shouldScrollToSelectedCountry = true
        
    }
    
    func forgotPasswordFunction() {
        let url = "\(ServiceDataConst.kForgotPassword)"
        let requestURL = URL.init(string: url);
        var request = URLRequest.init(url: requestURL!)
        let phoneNume = "+" + phoneTextField.text!
        
        let json = "{\"phoneNumber\":\"\(phoneNume)\",\"isParentLogin\":\"\(true)\"}"
        request.httpBody = json.data(using: .utf8)
        SocraticaWebserviceCalls().sendPOST(request, withSuccess: { (data) in
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            do{
                let myDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
                print(myDict!)
                let bo = (myDict!["status"] as! Bool)
                if(bo){
                    self.perform(#selector(self.movetootpVc), on: .main, with: nil, waitUntilDone: true)
                }else{
                    ZVProgressHUD.showText(myDict!["message"] as! String)
                }
            }catch{
                print("Error")
            }
        }) { (error) in
            print(error?.localizedDescription as Any)
            
        }
    }
    @objc func movetootpVc() {
        let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "oTPViewController") as! OTPViewController
        let phoneNume = "+" + phoneTextField.text!
        otpVC.phoneNumberWhileForgot = phoneNume
        otpVC.isForgotPasswordOTP = true
        self.navigationController?.pushViewController(otpVC, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
