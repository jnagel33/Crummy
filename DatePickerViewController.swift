//
//  DatePickerViewController.swift
//  Crummy
//
//  Created by Randy McLain on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

  var date : String?
  
  @IBOutlet weak var datePicker: UIDatePicker!
  
    override func viewDidLoad() {
        super.viewDidLoad()
   
      datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
  
  
  // func to set the date from the picker if no date is set.
  // https://github.com/ioscreator/ioscreator/blob/master/IOSSwiftDatePickerTutorial/IOSSwiftDatePickerTutorial/ViewController.swift
  func datePickerChanged(datePicker:UIDatePicker) {
    var dateFormatter = NSDateFormatter()
    
    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    
    var strDate = dateFormatter.stringFromDate(datePicker.date)
    date = strDate
    
    // call here to send back to edit kid view controller?
    
    
  }

  @IBAction func dateButtonPressed(sender: AnyObject) {
    
    
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
