//
//  EditKidViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class EditKidViewController: UIViewController {
  
  // properties
  
  @IBOutlet weak var kidNameField: UITextField!
  
  @IBOutlet weak var kidInsuranceField: UITextField!
  
  @IBOutlet weak var kidNursePhoneField: UITextField!
  
  @IBOutlet weak var kidInfoBox: UITextView!

  @IBOutlet weak var kidDobField: UITextField!
  
  var date = NSDate()

  
  // person passed from the "list of people controller.
  var selectedKid : Kid!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = selectedKid.name

  } // viewDidLoad
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func donePressed(sender: AnyObject) {
    
  } // donePressed
  
  // func to set the date from the picker if no date is set.  
  // https://github.com/ioscreator/ioscreator/blob/master/IOSSwiftDatePickerTutorial/IOSSwiftDatePickerTutorial/ViewController.swift
  func datePickerChanged(datePicker:UIDatePicker) {
    var dateFormatter = NSDateFormatter()
    
    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    
    var strDate = dateFormatter.stringFromDate(datePicker.date)
    selectedKid.DOBString = strDate
  }
  
  // pragma MARK: UIPickerViewDataSource Delegate
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  /* func pickerView(pickerView: UIPickerView, numberOfRowsInComponent: component) {
  return colors.count
  }*/
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 1
  }
  
  // pragma MARK: UIPickerViewDelegate
//  
//  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
//    return colors[row]
//  }
}