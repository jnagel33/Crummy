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
  var medicationName: String?
  var medicationAmount: String?
  var heightInches: Int?
  var weight: Int?
  var symptom: String?
  
  init(id: Int, type: EventType, temperature: Double?, medicationName: String?, medicationAmount: String?, heightInches: Int?, weight: Int?, symptom: String?) {
    self.id = id
    self.type = type
    self.temperature = temperature
    self.medicationName = medicationName
    self.medicationAmount = medicationAmount
    self.heightInches = heightInches
    self.weight = weight
    self.symptom = symptom
  }
  
}
