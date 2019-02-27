//
//  StorkksSharedClass.swift
//  Storkks
//
//  Created by Gaian on 20/09/18.
//  Copyright © 2018 gaian . All rights reserved.
//

import UIKit

class SocraticaSharedClass: NSObject {
    public var registrationDict = Dictionary<String , AnyObject>()
    
    private override init() { }
    // Can't init is singleton

    // MARK: Shared Instance
    static let shared = SocraticaSharedClass()
    
    // MARK: Local Variable
    
    func validatePhoneNumber(for number:String,country:String,and code:String) -> Bool{
        
        
        var phoneNumber : String!
        if let range =  number.range(of: code) {
            phoneNumber = number.replacingOccurrences(of: code, with: "", options: String.CompareOptions.caseInsensitive, range: range)
        }
        if( country == "AU" ){
           
            if phoneNumber.count == 8{
                return true
            } else{
                return false
            }
        } else if (country == "IN"){
            if phoneNumber.count == 10{
                return true
            } else{
                return false
            }
        }
        return true
        
    }
    
}
