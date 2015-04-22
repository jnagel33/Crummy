//
//  Event.swift
//  Crummy
//
//  Created by Josh Nagel on 4/21/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import Foundation

class Event {
  var id: Int?
  var type: EventType
  var temperature: Double?
  var medication: String?
  var heightInches: Int?
  var weight: Int?
  var symptom: String?
  var date: NSDate
  
  init(id: Int?, type: EventType, temperature: Double?, medication: String?, heightInches: Int?, weight: Int?, symptom: String?, date: NSDate) {
    self.id = id
    self.type = type
    self.temperature = temperature
    self.medication = medication
    self.heightInches = heightInches
    self.weight = weight
    self.symptom = symptom
    self.date = date
  }
  
}
