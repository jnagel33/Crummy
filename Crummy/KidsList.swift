
//
//  KidsList.swift
//  Crummy
//
//  Created by Ed Abrahamsen on 4/22/15.
//  Copyright (c) 2015 CF. All rights reserved.
//
import Foundation

class KidsList {
  
  var name: String
  var id: Int
  var phone: String?
  
  init(name: String, id: Int, phone: String) {
    
    self.name = name
    self.id = id
    self.phone = phone
  }
}