//
//  HTWebRequest.swift
//  upload
//
//  Created by Admin on 1/26/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit

class HTWebRequest{
    static func makeRequest(method: String, url: String, params: Dictionary<String,String>?, completion: (data: NSData?, response: NSURLResponse, error: NSError?)-> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = method
        if(params != nil){
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            do{
                try request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params!, options: NSJSONWritingOptions.PrettyPrinted)
            }
            catch{
            }
        }
        NSURLSession.sharedSession().dataTaskWithRequest(request){(data, response, error) in
            completion(data: data, response: response!, error: error)
            }.resume()
    }
    
    static func parseJson(data: NSData?) -> AnyObject?{
        do{
            let dataResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            return dataResult
        }
        catch{
            print("parseJson Error")
        }
        return nil
    }
    
    static func makeUploadRequest(method: String, url: String, params: Dictionary<String,String>?, completion: (data: NSData?, response: NSURLResponse, error: NSError?)-> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = method
        if(params != nil){
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            do{
                try request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params!, options: NSJSONWritingOptions.PrettyPrinted)
            }
            catch{
            }
        }
        NSURLSession.sharedSession().dataTaskWithRequest(request){(data, response, error) in
            completion(data: data, response: response!, error: error)
            }.resume()
    }
    
}
