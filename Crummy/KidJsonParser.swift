//
//  KidJsonParser.swift
//  Crummy
//
//  Created by Ed Abrahamsen on 4/21/15.
//  Copyright (c) 2015 CF. All rights reserved.
//
import Foundation

class KidJsonParser {
  
  class func parseJson(jsonData: NSData) -> [Kid] {
    var parse = [Kid]()
    var jsonError: NSError?
    
    if let
      jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &jsonError) as? [String: AnyObject],
      dictionaryItems = jsonDictionary["auth_token"] as? [[String: AnyObject]] {
        println(dictionaryItems)
//        
//        for objects in dictionaryItems {
//          if let
//            kidName = objects["name"] as? String,
//            kidDOB = objects["dob"] as? String,
//            kidInsuranceId = objects["ins"] as? String,
//            kidNursePhone = objects["phone"] as? String
//          {
//          let kidData = Kid(theName: kidName, theDOB: kidDOB, theInsuranceID: kidInsuranceId, theNursePhone: kidNursePhone)
//          parse.append(kidData)
//          }
//        }
      }
    return parse
  }
}
