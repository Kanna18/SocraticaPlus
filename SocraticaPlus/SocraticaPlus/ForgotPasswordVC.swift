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
        let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "oTPViewController") as! OTPViewController
        self.navigationController?.pushViewController(otpVC, animated: true)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
