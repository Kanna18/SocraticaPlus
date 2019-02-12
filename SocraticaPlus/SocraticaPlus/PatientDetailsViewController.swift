//
//  PatientDetailsViewController.swift
//  SocraticaPlus
//
//  Created by inlusr1 on 11/02/19.
//  Copyright © 2019 Gaian. All rights reserved.
//

import UIKit

class PatientDetailsViewController: UIViewController,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

   
  
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

