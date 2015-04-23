//
//  StringExtension.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import Foundation

extension String {

  func validForUsername() -> Bool {
    
    let elements = count(self)
    let range = NSMakeRange(0,elements)
    let regex = NSRegularExpression(pattern: "[^.-@0-9a-zA-Z\n_'\'-]", options: nil, error: nil)
    let matches = regex?.numberOfMatchesInString(self, options: nil, range: range)
    
    if matches > 0 {
      return false
    }
    return true
  }
}
