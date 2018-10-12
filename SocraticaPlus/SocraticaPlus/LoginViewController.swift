//
//  LoginViewController.swift
//  SocraticaPlus
//
//  Created by Gaian on 09/10/18.
//  Copyright © 2018 Gaian. All rights reserved.
//

import UIKit
import ZVProgressHUD
class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneTextField: NKVPhonePickerTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.pickerTextfield()
        self.navigationController?.isNavigationBarHidden = true
        ZVProgressHUD.displayStyle = .dark
        self.title = "Login"
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
    @IBAction func forgotPasswordClick(_ sender: Any) {
    }
    @IBAction func loginClick(_ sender: Any) {
        
        guard let phoneNum = phoneTextField.phoneNumber, phoneNum.isPhoneNumber else {
            ZVProgressHUD.showError(with: "Please enter a valid phone number", in: self.view, delay: 0.0)
            return
        }
        guard let password = passwordTF.text, password == "123456" else {
            ZVProgressHUD.showError(with: "Please enter a valid password", in: self.view, delay: 0.0)
            return
        }
        
        
        let tabB = self.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
        self.navigationController?.pushViewController(tabB, animated: true)
        
        
        
    }
    @IBAction func forgotpasswordClick(_ sender: Any) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}
