//
//  ViewController.swift
//  SocraticaPlus
//
//  Created by Gaian on 05/10/18.
//  Copyright © 2018 Gaian. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var alertBaseView: UIView!    
    @IBOutlet weak var customAlertView: UIView!
    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var checkBtn: CustomButton!
    @IBOutlet weak var phoneTxtField: CustomTextField!
    @IBOutlet weak var emailTxtField: CustomTextField!

    var reqEmail: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        customAlertView.dropShadow()
        alertBaseView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func okClick(_ sender: Any) {
        
        let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "oTPViewController") as! OTPViewController
        self.navigationController?.pushViewController(otpVC, animated: true)
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        
        phoneTxtField .resignFirstResponder()
        emailTxtField.resignFirstResponder()
        guard let text = phoneTxtField.text, !text.isEmpty else {
            
            return
        }
        
        if(!(phoneTxtField.text?.isPhoneNumber)!)
        {
            let alert = UIAlertController.init(title: "", message: "Please enter valid phone number", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction.init(title: "Ok", style: .default) { (alert) in

            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else
        {
            if !reqEmail
            {
                self.otpAlert()
                return
            }
            guard let text = emailTxtField.text, !text.isEmpty else {
                
                let alert = UIAlertController.init(title: "", message: "Please enter email", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction.init(title: "Ok", style: .default) { (alert) in
                    
                    
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if(!(emailTxtField.text?.isValidEmail)!)
            {
                let alert = UIAlertController.init(title: "", message: "Please enter valid email", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction.init(title: "Ok", style: .default) { (alert) in
                    
                    
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
       self.otpAlert()
        
    }
    private func otpAlert()
    {
        UIView.animate(withDuration: 0.3) {
            self.alertBaseView.isHidden = false
        }
//        UIView.transition(from: self.view, to: alertBaseView, duration: 0.2, options:.curveEaseOut, completion: nil)
//        let alert = UIAlertController.init(title: "", message: "A verification code has been sent to your mobile number please enter the number to continue ", preferredStyle: UIAlertControllerStyle.alert)
//        let okAction = UIAlertAction.init(title: "OK", style: .default) { (alert) in
//
//            let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "oTPViewController") as! OTPViewController
//            self.navigationController?.pushViewController(otpVC, animated: true)
//        }
//        alert.addAction(okAction)
//        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func checkBtnAction(_ sender: Any) {
        
        if checkBtn.isSelected == true {
            checkBtn.isSelected = false
            checkImg.isHighlighted = true
            reqEmail = false
        }else {
            checkBtn.isSelected = true
            checkImg.isHighlighted = false
            reqEmail = true
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTxtField
        {
            let maxLength = 13
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
       return true
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
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        
        layer.cornerRadius = 30
        layer.borderColor = UIColor.lightGray.cgColor
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSize.init(width: 2.0, height: 2.0)
        
        
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

