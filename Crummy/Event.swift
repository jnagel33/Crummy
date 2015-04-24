//
//  Event.swift
//  Crummy
//
//  Created by Josh Nagel on 4/21/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import Foundation

class Event: NSObject{
  var id: String?
  var type: EventType
  var temperature: String?
  var medication: String?
  var height: String?
  var weight: String?
  var symptom: String?
  var date: NSDate
  
  init(id: String?, type: EventType, temperature: String?, medication: String?, height: String?, weight: String?, symptom: String?, date: NSDate) {
    self.id = id
    self.type = type
    self.temperature = temperature
    self.medication = medication
    self.height = height
    self.weight = weight
    self.symptom = symptom
    self.date = date
  }
}
