//
//  Person.swift
//  Crummy
//
//  Created by Randy McLain on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import Foundation

class Person {
  
  
  let name : String
  
  let DOB : NSDate
  
  var insuranceID : String
  
  var consultantPhone : String
  
  
  // the Person Object
  init(theName : String, theDOB : NSDate, theInsuranceID : String, theConsultantPhone : String) {
    
    name = theName
    DOB = theDOB
    insuranceID = theInsuranceID
    consultantPhone = theConsultantPhone
  } // init
  
  
}