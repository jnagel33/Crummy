//
//  Kid.swift
//  Crummy
//
//  Created by Randy McLain on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class Kid {
  
  // properties 
  
  var name : String
  
  var DOBString : String
  
  var dob : NSDate
  
  var insuranceId : String
  
  var nursePhone : String
  
  var kidImage : UIImage?

  var kidID : String?
  
  //var notes : String
  
  var events: [Event] = [Event]()
  
  
  // the Person Object
  init(theName : String, theDOB : String, theInsuranceID : String, theNursePhone : String) {
    
    name = theName
    DOBString = theDOB
    // setting the NSDate DOB object based on the DOB string from user input.
    // http://stackoverflow.com/questions/24089999/how-do-you-create-a-swift-date-object
    dob = NSDate(dateString: DOBString)
    insuranceId = theInsuranceID
    nursePhone = theNursePhone
    //notes = theNotes
    
  } // init
  
  func kidToString() -> () {
    
    println(self.name + self.DOBString + self.insuranceId + self.nursePhone)
      }
  
}