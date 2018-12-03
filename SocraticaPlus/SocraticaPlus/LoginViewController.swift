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
        guard let password = passwordTF.text, !password.isEmpty else {
            ZVProgressHUD.showError(with: "Please enter a valid password", in: self.view, delay: 0.0)
            return
        }
        
        self.loginParentFunction(a: "+\(phoneNum)", b: password)

    }
    @IBAction func forgotpasswordClick(_ sender: Any) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func loginParentFunction(a: String, b: String) {
        let url = "\(ServiceDataConst.kParentLogin)"
        let requestURL = URL.init(string: url);
        var request = URLRequest.init(url: requestURL!)
        
         let json = "{\"phoneNumber\":\"\(a)\",\"password\":\"\(b)\",\"isParentLogin\":\"\(true)\"}"        
        request.httpBody = json.data(using: .utf8)
        SocraticaWebserviceCalls().sendPOST(request, withSuccess: { (data) in
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            do{
                let myDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
                print(myDict!)
                self.perform(#selector(self.movetoTabbarAfterSuccessfulllogin(dict:)), on: .main, with: myDict, waitUntilDone: true)
            }catch{
                print("Error")
            }
        }) { (error) in
            print(error?.localizedDescription as Any)
            
        }
    }
    
    @objc func movetoTabbarAfterSuccessfulllogin(dict : Dictionary<String, AnyObject>) {
        
        let boolVal = dict["token"]
        if(boolVal != nil){
            let tabB = self.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
            self.navigationController?.pushViewController(tabB, animated: true)
            let defa = UserDefaults.standard
            defa.set(phoneTextField.text , forKey: savedPhoneNumber)
            defa.set(passwordTF.text , forKey: savedPassword)
        }else{
            ZVProgressHUD.showText(dict["message"] as! String)
        }
    }
    


}
