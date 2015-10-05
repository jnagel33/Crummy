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
    
    let elements = self.characters.count
    _ = NSMakeRange(0,elements)
//    let regex = try! NSRegularExpression(pattern: "[^.-@0-9a-zA-Z\n_'\'-]", options: case, error: nil)
    
    let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",options: [.CaseInsensitive])
   // return regex.firstMatchInString(self, options:[],
    //  range: NSMakeRange(0, utf16.count)) != nil
    //let matches = regex.numberOfMatchesInString(self, options: nil, range: range)
    let matches = regex.numberOfMatchesInString(self, options: NSMatchingOptions.Anchored, range: NSRange(location: 0, length: elements))
    
    if matches != 0 {
      return false
    }
    return true
  }
}
