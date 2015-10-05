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
  
  let baseUrl = "http://crummy.herokuapp.com/api/v1"
  
  func postLogin(username: String, password: String, completionHandler: (String?, String?) -> (Void)) {
    let url = "http://crummy.herokuapp.com/api/v1/sessions"
    let parameterString = "email=\(username)" + "&" + "password=\(password)"
    let data = parameterString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    
    var request = NSMutableURLRequest(URL: NSURL(string: url)!)
    request.HTTPMethod = "POST"
    request.HTTPBody = data
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        completionHandler(nil, error.description)
      } else {
        let status = self.statusResponse(response)
        if status == "200" {
          if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject] {
            let token = jsonDictionary["authentication_token"] as! String
            
            NSUserDefaults.standardUserDefaults().setObject(token, forKey: "crummyToken")
            NSUserDefaults.standardUserDefaults().synchronize()
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(status, nil)
            })
          }
        } else {
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(nil, status)
          })
        }
      }
    })
    dataTask.resume()
  }
  
  func createNewUser(username: String, password: String, completionHandler: (String?, String?) -> (Void)) {
    
    let url = "http://crummy.herokuapp.com/api/v1/users"
    let parameterString = "email=\(username)" + "&" + "password=\(password)"
    let data = parameterString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    
    var request = NSMutableURLRequest(URL: NSURL(string: url)!)
    request.HTTPMethod = "POST"
    request.HTTPBody = data
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        completionHandler(nil, error.description)
      } else {
        let status = self.statusResponse(response)
        if status == "200" {
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(status, nil)
          })
        } else {
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(nil, status)
          })
        }
      }
    })
    dataTask.resume()
  }
  
  func listKid(completionHandler: ([Kid]?, String?) -> (Void)) {
    
    let requestUrl = "http://crummy.herokuapp.com/api/v1/kids"
    
    let url = NSURL(string: requestUrl)
    let request = NSMutableURLRequest(URL: url!)
    if let token = NSUserDefaults.standardUserDefaults().objectForKey("crummyToken") as? String {
      request.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
    }
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        completionHandler(nil, error.description)
      } else {
        let status = self.statusResponse(response)
        if status == "200" {
          let parsedKids = CrummyJsonParser.parseJsonListKid(data)
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(parsedKids, nil)
          })
        }
      }
    })
    dataTask.resume()
  }
  
  func getKid(id: String, completionHandler: (Kid?, String?) -> (Void)) {
    
    let kidIdUrl = "http://crummy.herokuapp.com/api/v1/kids/"
    let queryString = id
    let requestUrl = kidIdUrl + queryString
    let url = NSURL(string: requestUrl)
    let request = NSMutableURLRequest(URL: url!)
    if let token = NSUserDefaults.standardUserDefaults().objectForKey("crummyToken") as? String {
      request.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
    }
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        completionHandler(nil, error.description)
      } else {
        let status = self.statusResponse(response)
        if status == "200" {
          let editMenuKid = CrummyJsonParser.parseJsonGetKid(data)
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(editMenuKid, nil)
          })
        } else {
          completionHandler(nil,status)
        }
      }
    })
    dataTask.resume()
  }
  
  func editKid(id: String, name: String, dobString: String?, insuranceID: String?, nursePhone: String?, notes: String?, completionHandler: (String?, String?) -> Void) {
    let kidIdUrl = "http://crummy.herokuapp.com/api/v1/kids/"
    let queryString = id
    let requestUrl = kidIdUrl + queryString
    let url = NSURL(string: requestUrl)
    var error: NSError?
    var editedKid = [String: AnyObject]()
    
    editedKid["name"] = name
    if let kidDob = dobString {
      editedKid["dob"] = kidDob
    }
    if let kidInsuranceId = insuranceID {
      editedKid["insurance_id"] = kidInsuranceId
    }
    if let kidNursePhone = nursePhone {
      editedKid["nurse_phone"] = kidNursePhone
    }
    if let kidNotes = notes {
      editedKid["notes"]  = kidNotes
    }
    
    let data = NSJSONSerialization.dataWithJSONObject(editedKid, options: nil, error: &error)
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "PATCH"
    request.HTTPBody = data
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    if let token = NSUserDefaults.standardUserDefaults().objectForKey("crummyToken") as? String {
      request.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
    }
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        completionHandler(nil, error.description)
      } else {
        let status = self.statusResponse(response)
        if status == "200" {
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(status, nil)
          })
        } else {
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(nil, status)
          })
        }
      }
    })
    dataTask.resume()
  }

  func deleteKid(id: String, completionHandler: (String) -> (Void)) {
    
    let kidIdUrl = "http://crummy.herokuapp.com/api/v1/kids/"
    let queryString = id
    let requestUrl = kidIdUrl + queryString
    let url = NSURL(string: requestUrl)
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "DELETE"
    if let token = NSUserDefaults.standardUserDefaults().objectForKey("crummyToken") as? String {
      request.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
    }
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      
      let status = self.statusResponse(response)
      if status == "200" {
        
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          completionHandler(status)
        })
        } else {
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          completionHandler(status)
        })
      }
    })
    dataTask.resume()
  }
  
  func postNewKid(name: String, dobString: String?, insuranceID: String?, nursePhone: String?, notes: String?, completionHandler: (String?, String?) -> Void) {
    // url
    let requestUrl = "http://crummy.herokuapp.com/api/v1/kids"
    let url = NSURL(string: requestUrl)
    var request = NSMutableURLRequest(URL: url!)
    var error: NSError?
    var editedKid = [String: AnyObject]()
    editedKid["name"] = name
    if let kidDob = dobString {
      editedKid["dob"] = kidDob
    }
    if let kidInsuranceId = insuranceID {
      editedKid["insurance_id"] = kidInsuranceId
    }
    if let kidNursePhone = nursePhone {
      editedKid["nurse_phone"] = kidNursePhone
    }
    if let kidNotes = notes {
      editedKid["notes"]  = kidNotes
    }
    
    let data = NSJSONSerialization.dataWithJSONObject(editedKid, options: nil, error: &error)
    request.HTTPMethod = "POST"
    request.HTTPBody = data
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // token
    if let token = NSUserDefaults.standardUserDefaults().objectForKey("crummyToken") as? String {
      request.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
    }
    //post
    
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      let status = self.statusResponse(response)
      var error: NSError?
      if status == "201" || status == "200" {
        if let jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [String: AnyObject], id = jsonObject["id"] as? Int {
          let kidID = "\(id)"
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(kidID, status)
          })
        }
      } else {
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          completionHandler(nil, status)
        })
      }
    })
    
    dataTask.resume()
  } // postNewKid

  func getEvents(id: String, completionHandler: ([Event]?, String?) -> (Void)) {
    let eventUrl = "\(self.baseUrl)/kids/\(id)/events/"
    let url = NSURL(string: eventUrl)
    
    let request = NSMutableURLRequest(URL: url!)
    if let token = NSUserDefaults.standardUserDefaults().objectForKey("crummyToken") as? String {
      request.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
    }
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        
      } else {
        if let httpResponse = response as? NSHTTPURLResponse {
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
        completionHandler(nil, error.description)
      } else {
        if let httpResponse = response as? NSHTTPURLResponse {
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
  
  func createEvent(kidId: String, event: Event, completionHandler: (String?, String?) -> (Void)) {
    let createEventUrl = "\(self.baseUrl)/kids/\(kidId)/events/"
    let url = NSURL(string: createEventUrl)
    var error: NSError?
    
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let eventDate = dateFormatter.stringFromDate(event.date)
    
    var newEvent = [String: AnyObject]()
    newEvent["datetime"] = eventDate
    newEvent["type"] = event.type.description()
    if let eventTemperature = event.temperature {
      newEvent["temperature"] = eventTemperature
    }
    if let eventHeight = event.height {
      newEvent["height"] = "\(eventHeight)"
    }
    if let eventWeight = event.weight {
      newEvent["weight"] = "\(eventWeight)"
    }
    if let eventDescription = event.symptom {
      newEvent["description"] = eventDescription
    }
    if let eventMeds = event.medication {
      newEvent["meds"] = eventMeds
    }
    
    
    let data = NSJSONSerialization.dataWithJSONObject(newEvent, options: nil, error: &error)
    
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "POST"
    request.HTTPBody = data
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    if let token = NSUserDefaults.standardUserDefaults().objectForKey("crummyToken") as? String {
      request.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
    }
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        completionHandler(nil, error.description)
      } else {
        if let httpResponse = response as? NSHTTPURLResponse {
          if httpResponse.statusCode == 201 {
            if data != nil {
              if let id = CrummyJsonParser.getEventId(data) {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  completionHandler(id, nil)
                })
              }
            }
          }
        }
      }
    })
    dataTask.resume()
  }
  
  func editEvent(kidId: String, event: Event, completionHandler: (Event?, String?) -> (Void)) {
    let updateEventUrl = "\(self.baseUrl)/kids/\(kidId)/events/\(event.id!)"
    let url = NSURL(string: updateEventUrl)
    var error: NSError?
    
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let eventDate = dateFormatter.stringFromDate(event.date)
    
    var updatedEvent = [String: AnyObject]()
    updatedEvent["datetime"] = eventDate
    updatedEvent["type"] = event.type.description()
    if let eventTemperature = event.temperature {
      updatedEvent["temperature"] = eventTemperature
    }
    if let eventHeight = event.height {
      updatedEvent["height"] = "\(eventHeight)"
    }
    if let eventWeight = event.weight {
      updatedEvent["weight"] = "\(eventWeight)"
    }
    if let eventDescription = event.symptom {
      updatedEvent["description"] = eventDescription
    }
    if let eventMeds = event.medication {
      updatedEvent["meds"] = eventMeds
    }
    
    
    let data = NSJSONSerialization.dataWithJSONObject(updatedEvent, options: nil, error: &error)
    
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "PATCH"
    request.HTTPBody = data
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    if let token = NSUserDefaults.standardUserDefaults().objectForKey("crummyToken") as? String {
      request.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
    }
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        completionHandler(nil, error.description)
      } else {
        if let httpResponse = response as? NSHTTPURLResponse {
          if httpResponse.statusCode == 200 {
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