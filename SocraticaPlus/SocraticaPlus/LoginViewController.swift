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
    
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneTextField: NKVPhonePickerTextField!
    var rememberPhoneNumber = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.pickerTextfield()
        self.navigationController?.isNavigationBarHidden = true
        ZVProgressHUD.displayStyle = .dark
        if #available(iOS 12, *) {
            // iOS 12: Not the best solution, but it works.
            phoneTextField.textContentType = .oneTimeCode
            passwordTF.textContentType = .oneTimeCode
        } else {
            // iOS 11: Disables the autofill accessory view.
            // For more information see the explanation below.
            phoneTextField.textContentType = .init(rawValue: "")
            passwordTF.textContentType = .init(rawValue: "")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        phoneTextField.text = rememberPhoneNumber
    }
    
    func pickerTextfield() {
        
        phoneTextField.phonePickerDelegate = self
        //        phoneTxtField.favoriteCountriesLocaleIdentifiers = ["RU", "ER", "JM"]
        phoneTextField.enablePlusPrefix = true
        // Setting initial custom country
        let country = Country.country(for: NKVSource.init(countryCode: Locale.isoCurrencyCodes[0]))
        phoneTextField?.country = country
        phoneTextField.shouldScrollToSelectedCountry = true
        rememberPhoneNumber = phoneTextField.text
        
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
        
        
        guard let phoneNum = phoneTextField.phoneNumber, phoneNum.isPhoneNumber,SocraticaSharedClass.shared.validatePhoneNumber(for: phoneNum, country: (phoneTextField.country?.countryCode)!, and: phoneTextField.code!) else {
            ZVProgressHUD.showError(with: "Please enter a valid phone number", in: self.view, delay: 0.0)
            return
        }
        guard let password = passwordTF.text, !password.isEmpty else {
            ZVProgressHUD.showError(with: "Please enter a valid password", in: self.view, delay: 0.0)
            return
        }
        
        ZVProgressHUD.show()
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
            ZVProgressHUD.dismiss()
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            guard data.count != 0 else {
                print("Zero bytes of data")
                DispatchQueue.main.async {
                    ZVProgressHUD.showText("Zero bytes of data")
                }
                return
            }
            do{
                let myDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
                print(myDict!)

                    self.perform(#selector(self.movetoTabbarAfterSuccessfulllogin(dict:)), on: .main, with: myDict, waitUntilDone: true)


            }catch{
                print("Error")
                DispatchQueue.main.async {
                     ZVProgressHUD.showText("Error")
                }
                
            }
        }) { (error) in
            print(error?.localizedDescription as Any)
            ZVProgressHUD.dismiss()

        }
        //ZVProgressHUD.showText("submit clicked")
        
    }
    
    @objc func movetoTabbarAfterSuccessfulllogin(dict : Dictionary<String, AnyObject>) {
        
        let boolVal = dict["token"]
       
        if(boolVal != nil){
            let tabB = self.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
            //let parentProfile = self.storyboard?.instantiateViewController(withIdentifier: "ParentProfile") as! UIViewController
            self.navigationController?.pushViewController(tabB, animated: true)
            let defa = UserDefaults.standard
          
            
            
            defa.set("+\(phoneTextField.phoneNumber!)" , forKey: savedPhoneNumber)
            defa.set(passwordTF.text , forKey: savedPassword)
            defa.set(boolVal, forKey: "parentToken")
            
        }else{
             DispatchQueue.main.async {
            ZVProgressHUD.showText(dict["message"] as! String, in:self.view)
            }
            
            //self.perform(#selector(self.presentAlertonMainThread(dic:)), on: .main, with: dict, waitUntilDone: true)
        }
    }
    @objc func presentAlertonMainThread(dic:Dictionary<String,AnyObject>){
        let alert = UIAlertController(title: "Socratica", message: (dic["message"] as! String), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        })
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    


}
