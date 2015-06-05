//
//  DateObjects.swift
//  Crummy
//
//  Created by Randy McLain on 5/3/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit


class DateObject {
  
  var dateFormatter = NSDateFormatter()
  
  // we want to convert a string to "dd-MM-yyyy"
  
  func convertddMMYYYYToString (theDate : NSDate) -> (String) {
    
     dateFormatter.dateFormat = "dd-MM-yyyy"
    let stringDate = dateFormatter.stringFromDate(theDate)
    
    return stringDate
    
  } //convertddMMYYYYToString
}