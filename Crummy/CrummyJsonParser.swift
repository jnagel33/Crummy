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
          kidId = objects["id"] as? Int {
            let listData = KidsList(name: kidName, id: kidId)
            parse.append(listData)
        }
      }
      
    }
    return parse
  }
  
  class func parseJsonGetKid(jsonData: NSData) -> [Kid] {
    var parse = [Kid]()
    var jsonError: NSError?
    
    if let
      jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &jsonError) as? [String: AnyObject],
      dictionaryItems = jsonDictionary["auth_token"] as? [[String: AnyObject]] {
              
        for objects in dictionaryItems {
          if let
            kidName = objects["name"] as? String,
            kidDOB = objects["dob"] as? String,
            kidInsuranceId = objects["ins"] as? String,
            kidNursePhone = objects["phone"] as? String {
              let kidData = Kid(theName: kidName, theDOB: kidDOB, theInsuranceID: kidInsuranceId, theNursePhone: kidNursePhone)
              parse.append(kidData)
          }
        }
    }
    return parse
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
          
          let event = Event(id: id, type: eventType!, temperature: temperature, medication: name, heightInches: height, weight: weight, symptom: description, date: NSDate())
          events.append(event)
        }
      }
    }
    return events
  }
}
