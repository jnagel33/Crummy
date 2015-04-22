//
//  CrummyApiService.swift
//  Crummy
//
//  Created by Ed Abrahamsen on 4/21/15.
//  Copyright (c) 2015 CF. All rights reserved.
//
import Foundation

class CrummyApiService {
  
  static let sharedInstance: CrummyApiService = CrummyApiService()
  
  func postLogin(userName: String, password: String, completionHandler: (String?) ->(Void)) {
    
    let sessionUrl = "http://crummy.herokuapp.com/api/v1/sessions"
    let url = NSURL(string: sessionUrl)
    let parameterString = "username=\(userName)" + "&" + "password=\(password)"
    let data = parameterString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "POST"
    request.HTTPBody = data
    request.setValue("\(data!.length)", forHTTPHeaderField: "Content-Length")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      
      if error == nil {
        if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject] {
          println(jsonDictionary)
          let token = jsonDictionary["auth_token"] as! String
          println(token)
          
          NSUserDefaults.standardUserDefaults().setObject(token, forKey: "crummyToken")
          NSUserDefaults.standardUserDefaults().synchronize()
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(token)
            
          })
        }
      }
      
    })
    dataTask.resume()
  }
  
  
  
  func getKids(searchTerm: String, completionHandler: ([Kid]?, String?) ->(Void)) {
    
    let kidSearchUrl = "https://api.kid.com/search/"
    let queryString = "?q=\(searchTerm)"
    let requestUrl = kidSearchUrl + queryString
    println(requestUrl)
    let url = NSURL(string: requestUrl)
    let request = NSURLRequest(URL: url!)
    
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      
      if let httpResponse = response as? NSHTTPURLResponse {
        println(httpResponse.statusCode)
        if httpResponse.statusCode == 200 {
          let parsedKids = KidJsonParser.parseJson(data)
          
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(parsedKids, nil)
          })
        }
      }
    })
    dataTask.resume()
  }
  
}
