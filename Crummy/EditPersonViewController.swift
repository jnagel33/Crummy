//
//  EditPersonViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class EditPersonViewController: UIViewController {
  
  // properties 

  @IBOutlet weak var personNameField: UITextField!
  
  @IBOutlet weak var personDOBField: UITextField!
  
  @IBOutlet weak var personInsuranceField: UITextField!
  
  @IBOutlet weak var personNursePhoneField: UITextField!
  
  @IBOutlet weak var personInfoBox: UITextView!
  
  @IBOutlet weak var doneButton: UIButton!
  
  @IBOutlet weak var datePicker: UIDatePicker!
  
  var date = NSDate()
  
  
  
  
  // setup the constraints on the picker image view here:
  
  
  // person passed from the "list of people controller.  
  var selectedPerson : Person!

  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    self.title = selectedPerson.name
    
    // hide the done button.
    doneButton.hidden = true
    
    
    datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)

        // Do any additional setup after loading the view.
    } // viewDidLoad
  
  @IBAction func datePressed(sender: AnyObject) {
  
    
  // button to remove the UIPicker from view and apply date to person object
  }
  
  @IBAction func donePressed(sender: AnyObject) {
    
  } // donePressed

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  // func to set the date from the picker if no date is set.  
  // https://github.com/ioscreator/ioscreator/blob/master/IOSSwiftDatePickerTutorial/IOSSwiftDatePickerTutorial/ViewController.swift
  func datePickerChanged(datePicker:UIDatePicker) {
    var dateFormatter = NSDateFormatter()
    
    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    
    var strDate = dateFormatter.stringFromDate(datePicker.date)
    selectedPerson.DOBString = strDate
  }
  
  // pragma MARK: UIPickerViewDataSource Delegate
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  /* func pickerView(pickerView: UIPickerView, numberOfRowsInComponent: component) {
  return colors.count
  }*/
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return colors.count
  }
  
  // pragma MARK: UIPickerViewDelegate
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    return colors[row]
  }
  
  
    
}
