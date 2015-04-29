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
  
  var DOBString : String?
  // VVV is this even being used?  VVV
  var dob : NSDate?
  
  var insuranceId : String
  
  var nursePhone : String
  
  var kidImage : UIImage?
  
  var kidID : String
  
  var notes : String?
  
  var events: [Event] = [Event]()
  
  
  // the Person Object
  init(theName : String, theDOB : String?, theInsuranceID : String, theNursePhone : String, theNotes: String, theKidID: String) {
    
    name = theName
    DOBString = theDOB
    // setting the NSDate DOB object based on the DOB string from user input.
    // http://stackoverflow.com/questions/24089999/how-do-you-create-a-swift-date-object
    // we want it formatted as Date of birth, formatted dd-mm-yyyy
    // dob = NSDate(dateString: DOBString)
    insuranceId = theInsuranceID
    nursePhone = theNursePhone
    kidID = theKidID
    notes = theNotes
    
  } // init
  
  //convenienc init when needing an empty Kid object
  init() {
    self.events = [Event]()
    self.name = ""
    self.DOBString = ""
    self.insuranceId = ""
    self.nursePhone = ""
    self.kidID = ""
  }
  
  func kidToString() -> () {
    
//    println("name: " + self.name + " DOBString: " + self.DOBString! + " insuranceID: " + self.insuranceId + " nursePhone: " + self.nursePhone + " notes: ")
  }
  
}