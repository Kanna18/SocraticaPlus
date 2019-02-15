//
//  PatientDetailsViewController.swift
//  SocraticaPlus
//
//  Created by inlusr1 on 11/02/19.
//  Copyright © 2019 Gaian. All rights reserved.
//

import UIKit
import ZVProgressHUD
class ParentDetailsViewController: UIViewController,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

   
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var profileBtn: UIButton!
    
var imagePickerController : UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileBtn.layer.cornerRadius = self.profileBtn.frame.width/2
        self.profileBtn.layer.masksToBounds = true
        self.profileBtn.layer.borderWidth = 5.0
        self.profileBtn.layer.borderColor = UIColor.lightGray.cgColor
       
        addressTextView.text = "Enter Address"
        addressTextView.textColor = UIColor.lightGray
        //addressTextView.becomeFirstResponder()
        
        addressTextView.selectedTextRange = addressTextView.textRange(from: addressTextView.beginningOfDocument, to: addressTextView.beginningOfDocument)
        self.getParentDetails()
        self.disabelFieldsInteraction(bool: false)
       
    }
    func getParentDetails(){
        
         ZVProgressHUD.show()
        let url = URL.init(string: "\(ServiceDataConst.kParentProfile)")
       let request = NSMutableURLRequest.init(url: url!)
        let def = UserDefaults.standard
        
        let parentToken = def.value(forKey: "parentToken") as! String
        
        request.setValue("Bearer \(parentToken)", forHTTPHeaderField: "Authorization")
        
        SocraticaWebserviceCalls().sendGET(request as URLRequest, withSuccess: { (data) in
            ZVProgressHUD.dismiss()
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            do{
                let myDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
                print("parent details\(myDict!["firstName"]!) and \(myDict!["imagePath"]!) ")
               
                self.perform(#selector(self.assignDataForFields(dict:)), on: .main, with: myDict, waitUntilDone: true)
                
            }catch{
                print("Error")
            }
        }) { (error) in
             print(error?.localizedDescription as Any)
            ZVProgressHUD.dismiss()
        }
        
    }
    func updateParentProfile(with json: String){
        let url = URL.init(string: "\(ServiceDataConst.kParentProfile)")
        let request = NSMutableURLRequest.init(url: url!)
        let def = UserDefaults.standard
        
        let parentToken = def.value(forKey: "parentToken") as! String
        
        request.setValue("Bearer \(parentToken)", forHTTPHeaderField: "Authorization")
       // let json = "{\"FirstName\":\"\(self.nameTxt.text)\",\"LastName\":\"\(self.nameTxt.text)\",\"Email\":\"\(self.emailTxt.text)\",\"PhoneNumber\":\"\(self.mobileTxt.text)\",\"Address\":\"\(self.addressTextView.text)\",\"ImageFile\":\"\()\"}"
        request.httpBody = json.data(using: .utf8)
        SocraticaWebserviceCalls().sendPOST(request as URLRequest, withSuccess: { (data) in
            
        }) { (error) in
            
        }
        
    }
   @objc func assignDataForFields(dict : Dictionary<String, AnyObject>){
    let urlString = dict["imagePath"] != nil ? dict["imagePath"] as? String : ""
        let url = URL(string:urlString!)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        let parentImg  = UIImage(data: data!)
        self.profileBtn.setBackgroundImage(parentImg, for: .normal)
    self.nameTxt.text = dict["firstName"] != nil ? dict["firstName"] as? String : ""
     self.emailTxt.text = dict["email"] != nil ? dict["email"] as? String : ""
    self.mobileTxt.text = dict["phoneNumber"] != nil ? dict["phoneNumber"] as? String : ""
    self.addressTextView.text = dict["address"] != nil ? dict["address"] as? String : ""
    
    
    }
    
    @IBAction func onProfileBtnClick(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default, handler: { (_) in
            print("User click Camera button")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePickerController = UIImagePickerController()
            self.imagePickerController.delegate = self
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
            }else{
                print(" Camera Not Available")
            }
        })
        let photoLibraryAction = UIAlertAction(title: "Library", style: .default ,handler: { (_) in
            print("User click Library button")
            self.imagePickerController = UIImagePickerController()
            self.imagePickerController.delegate = self
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet,animated: true,completion: nil)
    }
    
    @IBAction func onSaveBtnClick(_ sender: UIButton) {
        if(sender.title(for: .normal ) == "Edit"){
            self.disabelFieldsInteraction(bool: true)
            self.nameTxt.becomeFirstResponder()
        }else{
            
        }
    }
    
    func disabelFieldsInteraction(bool : Bool){
        self.addressTextView.isUserInteractionEnabled = bool
        self.nameTxt.isUserInteractionEnabled = bool
        self.emailTxt.isUserInteractionEnabled = bool
        self.profileBtn.isUserInteractionEnabled = bool
    }
    
    
   @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    let photoImg = info[UIImagePickerControllerOriginalImage] as? UIImage
    self.profileBtn.setBackgroundImage(photoImg, for: .normal)
       // self.profileBtn.setImage(photoImg,for:.normal)
     self.imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("did bigin")
//        if textView.textColor == UIColor.lightGray {
//            addressTextView.text = nil
//            addressTextView.textColor = UIColor.black
//        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            addressTextView.text = "Enter Address"
            addressTextView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            addressTextView.text = "Enter Address"
            addressTextView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
            
            // For every other case, the text should change with the usual
            // behavior...
        else {
            return true
        }
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}

