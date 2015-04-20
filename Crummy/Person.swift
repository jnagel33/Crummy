//
//  Person.swift
//  Crummy
//
//  Created by Randy McLain on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class Person {
  
  // properties 
  
  let name : String
  
  let DOBString : String
  
  var DOB : NSDate
  
  var insuranceID : String
  
  var consultantPhone : String
  
  var personImage : UIImage?
  
  
  // the Person Object
  init(theName : String, theDOB : String, theInsuranceID : String, theConsultantPhone : String) {
    
    name = theName
    DOBString = theDOB
    // setting the NSDate DOB object based on the DOB string from user input.
    // http://stackoverflow.com/questions/24089999/how-do-you-create-a-swift-date-object
    DOB = NSDate(dateString: DOBString)
    insuranceID = theInsuranceID
    consultantPhone = theConsultantPhone
  } // init
}