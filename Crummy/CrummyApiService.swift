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
  
  func postLogin(userName: String, password: String, completionHandler: (String?) -> (Void)) {
    
    let url = "http://crummy.herokuapp.com/api/v1/sessions"
    let parameterString = "email=\(userName)" + "&" + "password=\(password)"
    let data = parameterString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    
    var request = NSMutableURLRequest(URL: NSURL(string: url)!)
    request.HTTPMethod = "POST"
    request.HTTPBody = data
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

func listKid(completionHandler: [KidsList]? -> (Void)) {
    
    let requestUrl = "http://crummy.herokuapp.com/api/v1/kids"
  
    let url = NSURL(string: requestUrl)
    
    let request = NSMutableURLRequest(URL: url!)
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("crummyToken") as? String {
          println("retrieved token:")
          println(token)
          request.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
      
        }
    
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      
      if let httpResponse = response as? NSHTTPURLResponse {
        println(httpResponse.statusCode)
       
          if httpResponse.statusCode == 200 {
          let parsedKids = CrummyJsonParser.parseJsonListKid(data)
          
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(parsedKids)
          })
        }
      }
    })
    dataTask.resume()
  }
  
  
  func getKid(searchTerm: String, completionHandler: ([Kid]?, String?) -> (Void)) {
    
    let kidIdUrl = "http://crummy.herokuapp.com/api/v1/kids"
    let queryString = "?:\(searchTerm)"
    let requestUrl = kidIdUrl + queryString
    let url = NSURL(string: requestUrl)
    let request = NSURLRequest(URL: url!)
    
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      
      if let httpResponse = response as? NSHTTPURLResponse {
        println(httpResponse.statusCode)
        if httpResponse.statusCode == 200 {
          let parsedKids = CrummyJsonParser.parseJsonGetKid(data)
          
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(parsedKids, nil)
          })
        }
      }
    })
    dataTask.resume()
  }

  
  func errorResponse(httpStatusCode: Int) -> String {
    
    switch httpStatusCode {
    case 200:
      println("200")
    case 401:
      println("Incorrect username or password")
    default:
      println("x")
    }
    
  return "200"
  }
  
  
}
