//
//  STRestManager.swift
//  SimilarTitles
//
//  Created by Armen Abrahamyan on 1/29/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import Foundation


public class STRestManager {
    
    // MARK: Create Request Part
    public class func sendGETRequest(let urlString: String, completionHandler:(response: Dictionary<String, AnyObject>?, errorObj: NSError?) -> Void) {
 
        let task: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(constructGetRequest(urlString)) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            var responseDictionary: Dictionary<String, AnyObject>?
            
            if error == nil {
            
                do {
                    responseDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String: AnyObject]
                    completionHandler(response: responseDictionary, errorObj: nil)
                    
                } catch {
                    print("Error parsing json to objects")
                }
            }
        }
        
        task.resume()
    }
    
    /**
    * Creates and returns 'GET' request
    */
    public class func constructGetRequest(let urlString: String) -> NSURLRequest {
        let url: NSURL? = NSURL(string: urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.timeoutInterval = 30.0
        return request
    }
    
}