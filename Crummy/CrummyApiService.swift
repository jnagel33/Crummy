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
  
  func postLogin(username: String, password: String, completionHandler: (String?) -> (Void)) {
    
    let url = "http://crummy.herokuapp.com/api/v1/sessions"
    let parameterString = "email=\(username)" + "&" + "password=\(password)"
    let data = parameterString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    
    var request = NSMutableURLRequest(URL: NSURL(string: url)!)
    request.HTTPMethod = "POST"
    request.HTTPBody = data
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      let status = self.statusResponse(response)
      if status == "200" {
        if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject] {
          println(jsonDictionary)
          let token = jsonDictionary["auth_token"] as! String
          println(token)
          NSUserDefaults.standardUserDefaults().setObject(token, forKey: "crummyToken")
          NSUserDefaults.standardUserDefaults().synchronize()
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(status)
          })
        }
      } else {
        completionHandler(status)
      }
    })
    dataTask.resume()
  }
  
  func createNewUser(username: String, password: String, completionHandler: (String?) -> (Void)) {
    
    let url = "http://crummy.herokuapp.com/api/v1/users"
    let parameterString = "email=\(username)" + "&" + "password=\(password)"
    let data = parameterString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    
    var request = NSMutableURLRequest(URL: NSURL(string: url)!)
    request.HTTPMethod = "POST"
    request.HTTPBody = data
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      let status = self.statusResponse(response)
      if status == "200" {
        
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          completionHandler(status)
        })
      } else {
        completionHandler(status)
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
      
      let status = self.statusResponse(response)
      if status == "200" {
        let parsedKids = CrummyJsonParser.parseJsonListKid(data)
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          completionHandler(parsedKids)
        })
      }
    })
    dataTask.resume()
  }
  
  func getKid(searchTerm: String, completionHandler: ([Kid]?, String?) -> (Void)) {
    
    // listKid
    
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
  
  func getEvents(id: Int, completionHandler: ([Event]?, String?) -> (Void)) {
    let eventIdUrl = "http://crummy.herokuapp.com/api/v1/kids/45/events"
    let url = NSURL(string: eventIdUrl)
    
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("Token token=VfbcZZWaDdqTzoahGVZf", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        
      } else {
        if let httpResponse = response as? NSHTTPURLResponse {
          println(httpResponse.statusCode)
          if httpResponse.statusCode == 200 {
            let events = CrummyJsonParser.parseEvents(data)
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(events, nil)
            })
          }
        }
      }
    })
    dataTask.resume()
  }

  func statusResponse(response: NSURLResponse) -> String {
    
    if let httpResponse = response as? NSHTTPURLResponse {
      let httpStatus = httpResponse.statusCode
      
      switch httpStatus {
      case 200:
        return "200"
      case 201:
        return "200"
      case 400:
        return "Problems parsing JSON"
      case 401:
        return "Incorrect username or password"
      case 404:
        return "Object does not exist"
      case 422:
        return "Validation failed"
      default:
        return "Unkown error"
      }
    }
    return "Unknown error"
  }
}