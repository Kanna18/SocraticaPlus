//
//  ViewController.swift
//  SocraticaPlus
//
//  Created by Gaian on 05/10/18.
//  Copyright © 2018 Gaian. All rights reserved.
//

import UIKit
import ZVProgressHUD


class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var alertBaseView: UIView!    
    @IBOutlet weak var customAlertView: UIView!
    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var checkBtn: CustomButton!
    @IBOutlet weak var phoneTxtField: NKVPhonePickerTextField!
    @IBOutlet weak var emailTxtField: CustomTextField!
    @IBOutlet weak var popupImageView: UIImageView!    
    
    
    var reqEmail: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        customAlertView.dropShadow()
        alertBaseView.isHidden = true
        self.pickerTextfield()
//        let tapGe = UITapGestureRecognizer.init(target: self, action: #selector(moveTonextVC))
//        tapGe.numberOfTapsRequired = 1
//        tapGe.numberOfTouchesRequired = 1
//        popupImageView.addGestureRecognizer(tapGe)
        self.navigationController?.isNavigationBarHidden = true
        self.title = "Registration"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func okClick(_ sender: Any) {
        
        let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "oTPViewController") as! OTPViewController
        self.navigationController?.pushViewController(otpVC, animated: true)
    }
    func pickerTextfield() {
        
        phoneTxtField.phonePickerDelegate = self
//        phoneTxtField.favoriteCountriesLocaleIdentifiers = ["RU", "ER", "JM"]
        phoneTxtField.enablePlusPrefix = true
        // Setting initial custom country
        let country = Country.country(for: NKVSource.init(countryCode: Locale.isoCurrencyCodes[0]))
        phoneTxtField?.country = country
        phoneTxtField.shouldScrollToSelectedCountry = true
        
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        
        phoneTxtField?.resignFirstResponder()
        emailTxtField.resignFirstResponder()
        guard let text = phoneTxtField?.text, !text.isEmpty else {
            
            return
        }
        
        
        guard let phoneNumberText = phoneTxtField.phoneNumber , phoneNumberText.isPhoneNumber  else {
            ZVProgressHUD.showText("Please enter a valid phone number")
            return
        }
        guard let passwordtext = emailTxtField.text, passwordtext.isValidPassword else {
            ZVProgressHUD.showText("Please should contain atleast 6 letters")
         return
        }
        self.loParentFunction(a: "+\(phoneNumberText)", b: passwordtext)
        ZVProgressHUD.showProgress(0.0)
    }
    
    func loParentFunction(a: String, b: String) {
        let url = "\(ServiceDataConst.kParentRegistration)"
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
                SocraticaSharedClass.shared.registrationDict = myDict!
                if((myDict!["status"] as! Bool) == true){
                    
                    self.perform(#selector(self.otpAlert), on: .main, with: nil, waitUntilDone: true)
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
    
   @objc private func otpAlert()
    {
//        UIView.animate(withDuration: 0.3) {
//            self.alertBaseView.isHidden = false
//        }
        ZVProgressHUD.dismiss()
        let alert = UIAlertController.init(title: "", message: "A verification code has been sent to your mobile number please enter the number to continue ", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (alert) in

            let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "oTPViewController") as! OTPViewController
            otpVC.passwordWhileRegistration = self.emailTxtField.text!
            otpVC.isRegistrationOTP = true
            otpVC.phoneNumberWhileForgot = "+\(self.phoneTxtField.phoneNumber!)"
            self.navigationController?.pushViewController(otpVC, animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func checkBtnAction(_ sender: Any) {
        
        if checkBtn.isSelected == true {
            checkBtn.isSelected = false
            checkImg.isHighlighted = true
            reqEmail = false
            emailTxtField.isEnabled = false
//            emailTxtField.backgroundColor = UIColor.lightGray
        }else {
            checkBtn.isSelected = true
            checkImg.isHighlighted = false
            reqEmail = true
            emailTxtField.isEnabled = true
            emailTxtField.backgroundColor = UIColor.clear
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == phoneTxtField
//        {
//            let maxLength = 13
//            let currentString: NSString = (phoneTxtField?.phoneNumber)! as NSString
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            return newString.length <= maxLength
//        }
//       return true
//    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {        
        self.view.endEditing(true)
    }
}
extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    var isValidEmail: Bool {
        do {
            
            let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluate(with: self)
            return result
        } catch {
            return false
        }
    }
    var isValidPassword : Bool {
            let result = self.count
            if( result >= 6){
            return true
            }else{
                return false
        }
    }
}


extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        
        layer.cornerRadius = 30
        layer.borderColor = UIColor.lightGray.cgColor
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSize.init(width: 3.0, height: 3.0)
        
        
//        layer.cornerRadius = 20
//        layer.masksToBounds = false
//        layer.shadowColor = UIColor.gray.cgColor
//        layer.shadowOpacity = 0.5
//        layer.shadowOffset = CGSize(width: -1, height: 1)
//        layer.shadowRadius = 1
//
//
//
//        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

