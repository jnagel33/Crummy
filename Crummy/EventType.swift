//
//  EventType.swift
//  Crummy
//
//  Created by Josh Nagel on 4/21/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import Foundation

enum EventType: Int {
  
  case Medication
  case Measurement
  case Symptom
  case Temperature
  
  func description() -> String {
    switch self {
    case .Medication:
      return "Medicine"
    case .Measurement:
      return "HeightWeight"
    case .Symptom:
      return "Symptom"
    case .Temperature:
      return "Temperature"
    default:
      return String(self.rawValue)
    }
  }
}
