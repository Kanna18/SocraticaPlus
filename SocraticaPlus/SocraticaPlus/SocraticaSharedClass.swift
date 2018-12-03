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
}
