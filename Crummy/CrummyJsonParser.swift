//
//  CrummyKidJsonParser.swift
//  Crummy
//
//  Created by Ed Abrahamsen on 4/21/15.
//  Copyright (c) 2015 CF. All rights reserved.
//
import Foundation

class CrummyJsonParser {
  
  class func parseJsonListKid(jsonData: NSData) -> [KidsList] {
    var parse = [KidsList]()
    var jsonError: NSError?
    
    if let jsonArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &jsonError) as? [[String: AnyObject]] {
      
      for objects in jsonArray {
        if let
          kidName = objects["name"] as? String,
          kidPhone = objects["nurse_phone"] as? String,
          kidId = objects["id"] as? Int {
            let listData = KidsList(name: kidName, id: kidId, phone: kidPhone)
            parse.append(listData)
        }
      }
      
    }
    return parse
  }
  
  class func parseJsonGetKid(jsonData: NSData) -> Kid {
    var editMenuKid: Kid!
    var jsonError: NSError?
    
    if let
      jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &jsonError) as? [String: AnyObject] {
        
      let name = jsonDictionary["name"] as! String
      let kidId = jsonDictionary["id"] as! Int
      let id = String(stringInterpolationSegment: kidId)
      var dob = jsonDictionary["dob"] as? String
      if dob == "" {
        dob = " "
      }
      var insuranceId = jsonDictionary["insurance_id"] as? String
      if insuranceId == "" {
        insuranceId = " "
      }
      var nursePhone = jsonDictionary["nurse_phone"] as? String
      if nursePhone == "" {
        nursePhone = " "
      }
      var notes = jsonDictionary["notes"] as? String  // Add notes when Kid obbject updated
      if notes == nil {
        notes = " "
      }
      editMenuKid = Kid(theName: name, theDOB: " ", theInsuranceID: insuranceId!, theNursePhone: nursePhone!, theNotes: notes!, theKidID: id)
    }
    return editMenuKid
  }
  
  class func parseEvents(jsonData: NSData) -> [Event] {
    var events = [Event]()
    var error: NSError?
    
    if let jsonObject = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as? [[String: AnyObject]] {
      for event in jsonObject {
        if let eventId = event["id"] as? Int {
          var id = "\(eventId)"
          var eventType: EventType?
          var name: String?
          var temperature: String?
          var height: String?
          var weight: String?
          var description: String?
          var date: NSDate?
          if let type = event["type"] as? String {
            if type == "Medicine" {
              eventType = EventType.Medication
            } else if type == "Temperature" {
              eventType = EventType.Temperature
            } else if type == "HeightWeight" {
              eventType = EventType.Measurement
            } else {
              eventType = EventType.Symptom
            }
          }
          if let datetime = event["datetime"] as? String {
            //Need dateFormatter
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            date = dateFormatter.dateFromString(datetime)
          }
          if let eventName = event["meds"] as? String {
            name = eventName
          }
          if let eventTemperature = event["temperature"] as? String {
            temperature = eventTemperature
          }
          if let eventHeight = event["height"] as? String {
            height = eventHeight
          }
          if let eventWeight = event["weight"] as? String {
            weight = eventWeight
          }
          if let eventDescription = event["description"] as? String {
            description = eventDescription
          }
          
          let event = Event(id: id, type: eventType!, temperature: temperature, medication: name, height: height, weight: weight, symptom: description, date: date!)
          events.append(event)
        }
      }
    }
    return events
  }
  
  class func getEventId(data: NSData) -> String? {
    
    if let event = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject], id = event["id"] as? Int {
      return "\(id)"
    }
    return nil
  }
}
