//
//  StorksWebserviceCalls.swift
//  Storkks
//
//  Created by gaian  on 8/13/18.
//  Copyright © 2018 gaian . All rights reserved.
//

import UIKit

let apiKey = "x-api-key"
let apiValue = "taya@123"
let authKey = "Authorization"
let authvalue = "Basic YWRtaW46MTIzNA=="

class SocraticaWebserviceCalls: NSObject {
    private var session: URLSession
    
    /// Initialize with custom session configuraion
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    /// Initialize with default session configuraion
    convenience override init() {
        let sessionConfig = URLSessionConfiguration.default
        self.init(configuration: sessionConfig)
    }
    
    /// Call this method when you are sending URL, POST body instead of URLRequest. If postBody is nil, then it is considered as GET URL
    func dataTask(with urlStr: String, and postBody: String?, withSuccess: @escaping (Data?) -> (), withFailure: @escaping (Error?) -> ()) {
        let currentUrl = URL(string: urlStr)
        var request = URLRequest(url: currentUrl!)
        if let postBody = postBody {
            request.httpBody = postBody.data(using: .utf8)
            self.sendPOST(request, withSuccess: withSuccess, withFailure: withFailure)
        }else{
            self.sendGET(request, withSuccess: withSuccess, withFailure: withFailure)
        }
    }
    
    /// Call this method when you are sending GET Request.
    func sendGET(_ request: URLRequest, withSuccess: @escaping (Data?) -> (), withFailure: @escaping (Error?) -> ()) {
        var request = request
        request.httpMethod = "GET"
        self.sendRequest(request, withSuccess: withSuccess, withFailure: withFailure)
    }
    
    /// Call this method when you are sending POST Request.
    func sendPOST(_ request: URLRequest, withSuccess: @escaping (Data?) -> (), withFailure: @escaping (Error?) -> ()) {
        var request = request
        request.httpMethod = "POST"
        self.sendRequest(request, withSuccess: withSuccess, withFailure: withFailure)
    }
    
    /// Call this method when you are sending request of type GET/POST/ANY. If you don't specify method type by default then the request is considered as "application/x-www-form-urlencoded"
    func sendRequest(_ request: URLRequest, withSuccess: @escaping (Data?) -> (), withFailure: @escaping (Error?) -> ()) {
        // Setup URLRequest
        var request = request
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 30.0
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
//        if request.value(forHTTPHeaderField: "Accept") == nil {
//            request.addValue("application/json", forHTTPHeaderField: "Accept")
//        }
//        if request.value(forHTTPHeaderField: "x-api-key") == nil {
//            request.addValue(apiValue, forHTTPHeaderField: "x-api-key")
//        }
//        if request.value(forHTTPHeaderField: "Authorization") == nil {
//            request.addValue(authvalue, forHTTPHeaderField: "Authorization")
//        }
        if request.httpMethod == "POST" {
            print("Network Request: ", request.url!,  request.httpMethod!, String(data: request.httpBody! , encoding: .utf8)!, separator: "\n")
        }else if request.httpMethod == "GET"{
            print("Network Request: ", request.url!,  request.httpMethod!, separator: "\n")
        }
        // Setup URLSession
        let dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                if(response.statusCode == 400||response.statusCode == 200)
                {
                print("Network Response:", request.url!, String(data: data, encoding: .utf8)!, separator:"\n" )
                withSuccess(data)
                }
            }else{
                print("Network error: ", request.url!, error?.localizedDescription ?? "Some thing went wrong!", separator:"\n")
                withFailure(error)
            }
        })
        dataTask.resume()
    }
    
    /// Cancels the current session
    func cancel() {
        self.session.invalidateAndCancel()
    }
    
}
