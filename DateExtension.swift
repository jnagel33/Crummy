//
//  DateExtension.swift
//  Crummy
//
//  Created by Randy McLain on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import Foundation

extension NSDate
{
  convenience
  init(dateString:String) {
    let dateStringFormatter = NSDateFormatter()
    dateStringFormatter.dateFormat = "yyyy-MM-dd"
    dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    let d = dateStringFormatter.dateFromString(dateString)
    self.init(timeInterval:0, sinceDate:d!)
  }
}