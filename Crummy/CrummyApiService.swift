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
  var list = [KidsList]()
  
  let baseUrl = "http://crummy.herokuapp.com/api/v1"
  
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
          let token = jsonDictionary["authentication_token"] as! String
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
  
  func getKid(selectedKid: String, completionHandler: ([Kid]?) -> (Void)) {
    
    let kidIdUrl = "http://crummy.herokuapp.com/api/v1/kids"
    let queryString = "?:ID"
    let requestUrl = kidIdUrl + queryString
    let url = NSURL(string: requestUrl)
    let request = NSURLRequest(URL: url!)
    
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      
      if let httpResponse = response as? NSHTTPURLResponse {
        if httpResponse.statusCode == 200 {
          let parsedKids = CrummyJsonParser.parseJsonGetKid(data)
          
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(parsedKids)
          })
        }
      }
    })
    dataTask.resume()
  }
  
  func getEvents(id: Int, completionHandler: ([Event]?, String?) -> (Void)) {
//    let eventUrl = "\(self.baseUrl)/kids/\(kidId)/events/"
    let eventIdUrl = "http://crummy.herokuapp.com/api/v1/kids/16/events"
    let url = NSURL(string: eventIdUrl)
    
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("Token token= /(token)", forHTTPHeaderField: "Authorization")
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
  
  func deleteEvent(kidId: String, eventId: String, completionHandler: (String?, String?) -> (Void)) {
    let deleteEventUrl = "\(self.baseUrl)/kids/\(kidId)/events/\(eventId)"
//    let deleteEventUrl = "http://crummy.herokuapp.com/api/v1/kids/45/events/144"
    let url = NSURL(string: deleteEventUrl)
    
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "DELETE"
    request.setValue("Token token=nvZPt85uUZKh3itdoQkz", forHTTPHeaderField: "Authorization")
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        println("error")
      } else {
        if let httpResponse = response as? NSHTTPURLResponse {
          println(httpResponse.statusCode)
          if httpResponse.statusCode == 204 {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(eventId, nil)
            })
          }
        }
      }
    })
    dataTask.resume()
  }
  
  func createEvent(kidId: String, event: Event, completionHandler: (Event?, String?) -> (Void)) {
    let createEventUrl = "\(self.baseUrl)/kids/\(kidId)/events/"
    let url = NSURL(string: createEventUrl)
    var error: NSError?
    
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd-mm-yyyy hh:mm:ss"
    let eventDate = dateFormatter.stringFromDate(event.date)
    
    var newEvent = [String: AnyObject]()
//    newEvent["datetime"] = eventDate
    newEvent["type"] = event.type.description()
    if let eventTemperature = event.temperature {
      newEvent["temperature"] = eventTemperature
    }
    if let eventHeight = event.heightInches {
      newEvent["height"] = "\(eventHeight)"
    }
    if let eventWeight = event.weight {
      newEvent["weight"] = "\(eventWeight)"
    }
    if let eventDescription = event.symptom {
      newEvent["description"] = eventDescription
    }
    if let eventMed = event.medication {
      newEvent["meds"] = event.medication
    }
    
    
    let data = NSJSONSerialization.dataWithJSONObject(newEvent, options: nil, error: &error)
    
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "POST"
    request.HTTPBody = data
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Token token=nvZPt85uUZKh3itdoQkz", forHTTPHeaderField: "Authorization")
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        println("error")
      } else {
        if let httpResponse = response as? NSHTTPURLResponse {
          println(httpResponse.statusCode)
          if httpResponse.statusCode == 201 {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(event, nil)
            })
          }
        }
      }
    })
    dataTask.resume()
  }
  
  func editEvent(kidId: String, event: Event, completionHandler: (Event?, String?) -> (Void)) {
    let createEventUrl = "\(self.baseUrl)/kids/\(kidId)/events/\(event.id!)"
    let url = NSURL(string: createEventUrl)
    var error: NSError?
    
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd-mm-yyyyThh:mm:ss"
    let eventDate = dateFormatter.stringFromDate(event.date)
    
    var updatedEvent = [String: AnyObject]()
    updatedEvent["id"] = event.id!
//    updatedEvent["datetime"] = eventDate
    updatedEvent["type"] = event.type.description()
    if let eventTemperature = event.temperature {
      updatedEvent["temperature"] = eventTemperature
    }
    if let eventHeight = event.heightInches {
      updatedEvent["height"] = "\(eventHeight)"
    }
    if let eventWeight = event.weight {
      updatedEvent["weight"] = "\(eventWeight)"
    }
    if let eventDescription = event.symptom {
      updatedEvent["description"] = eventDescription
    }
    if let eventMed = event.medication {
      updatedEvent["meds"] = event.medication
    }
    
    
    let data = NSJSONSerialization.dataWithJSONObject(updatedEvent, options: nil, error: &error)
    
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "POST"
    request.HTTPBody = data
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Token token=nvZPt85uUZKh3itdoQkz", forHTTPHeaderField: "Authorization")
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        println("error")
      } else {
        if let httpResponse = response as? NSHTTPURLResponse {
          println(httpResponse.statusCode)
          if httpResponse.statusCode == 201 {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(event, nil)
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