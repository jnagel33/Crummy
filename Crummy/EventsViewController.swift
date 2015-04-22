//
//  EventsViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var constraintButtonViewContainerBottom: NSLayoutConstraint!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var constraintViewContainerBottom: NSLayoutConstraint!
  @IBOutlet weak var medicationButton: UIButton!
  @IBOutlet weak var temperatureButton: UIButton!
  @IBOutlet weak var symptomButton: UIButton!
  @IBOutlet weak var measurementButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  
  @IBOutlet weak var symptomsTextField: UITextField!
  @IBOutlet weak var symptomsDoneButton: UIButton!
  @IBOutlet weak var measurementsFeetTextField: UITextField!
  @IBOutlet weak var measurementInchesTextField: UITextField!
  @IBOutlet weak var measurementWeightTextField: UITextField!
  @IBOutlet weak var measurementsDoneButton: UIButton!
  @IBOutlet weak var temperatureTextField: UITextField!
  @IBOutlet weak var temperatureDoneButton: UIButton!
  @IBOutlet weak var medicationTextField: UITextField!
  @IBOutlet weak var medicationDoneButton: UIButton!
  @IBOutlet weak var eventTypeContainerView: UIView!
  @IBOutlet weak var constraintEventTypeContainerHeight: NSLayoutConstraint!
  
  
  let medicationContainerViewHeight: CGFloat = 63
  let measurementsContainerViewHeight: CGFloat = 96
  let symptomsContainerViewHeight: CGFloat = 72
  let temperatureContainerViewHeight: CGFloat = 86
  
  let medicationCellHeight: CGFloat = 56
  let measurementCellHeight: CGFloat = 92
  let symptomsCellHeight: CGFloat = 55
  let temperatureCellHeight: CGFloat = 53
  
  var constraintMedicationContainerViewBottom: NSLayoutConstraint?
  var constraintMeasurementContainerViewBottom: NSLayoutConstraint?
  var constraintSymptomsContainerViewBottom: NSLayoutConstraint?
  var constraintTemperatureContainerViewBottom: NSLayoutConstraint?
  
  
  
  var keyboardHeight: CGFloat = 0
  var animationDuration: Double = 0.2
  var tapGestureRecognizer: UITapGestureRecognizer?
  var kid: Kid!
  var selectedType: EventType?
  var currentContainerView: UIView?
  var sections: [[String]]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    var cellNib = UINib(nibName: "MedicationTableViewCell", bundle: NSBundle.mainBundle())
    self.tableView.registerNib(cellNib, forCellReuseIdentifier: "MedicationCell")
    cellNib = UINib(nibName: "MeasurementsTableViewCell", bundle: NSBundle.mainBundle())
    self.tableView.registerNib(cellNib, forCellReuseIdentifier: "MeasurementCell")
    cellNib = UINib(nibName: "TemperatureTableViewCell", bundle: NSBundle.mainBundle())
    self.tableView.registerNib(cellNib, forCellReuseIdentifier: "TemperatureCell")
    cellNib = UINib(nibName: "SymptomsTableViewCell", bundle: NSBundle.mainBundle())
    self.tableView.registerNib(cellNib, forCellReuseIdentifier: "SymptomCell")
    
    
    let today = NSDate()
    let cal = NSCalendar.currentCalendar()
    let yesterday = cal.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: -1, toDate: today, options: nil)
    
    
    self.kid.events.append(Event(id: 1, type: EventType.Medication, temperature: 98.9, medication: "2 Advil", heightInches: 78, weight: 43, symptom: "symptom", date: yesterday!))
    self.kid.events.append(Event(id: 1, type: EventType.Symptom, temperature: 98.9, medication: "meds", heightInches: 78, weight: 43, symptom: "symptom", date: NSDate()))
    self.kid.events.append(Event(id: 1, type: EventType.Temperature, temperature: 98.9, medication: "advil", heightInches: 78, weight: 43, symptom: "symptom", date: NSDate()))
    self.kid.events.append(Event(id: 1, type: EventType.Measurement, temperature: 98.9, medication: "test", heightInches: 78, weight: 43, symptom: "symptom", date: NSDate()))
    
    
    
    self.getSections()
    self.tableView.dataSource = self
    
    self.navigationItem.title = "Events - \(kid!.name)"
    
    self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    self.view.addGestureRecognizer(self.tapGestureRecognizer!)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
  }
  
  @IBAction func eventTypePressed(sender: UIButton) {
    self.constraintButtonViewContainerBottom.constant += 60
    UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    if sender == self.medicationButton {
      self.selectedType = EventType.Medication
      let medicationView = NSBundle.mainBundle().loadNibNamed("MedicationContainerView", owner: self, options: nil).first as! UIView
      self.currentContainerView = medicationView
      medicationView.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.view.addSubview(medicationView)
      self.view.addConstraint(NSLayoutConstraint(item: medicationView, attribute: NSLayoutAttribute.Trailing, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
      self.view.addConstraint(NSLayoutConstraint(item: medicationView, attribute: NSLayoutAttribute.Leading, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
      self.constraintMedicationContainerViewBottom = NSLayoutConstraint(item: medicationView, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
      self.view.addConstraint(self.constraintMedicationContainerViewBottom!)
      medicationView.addConstraint(NSLayoutConstraint(item: medicationView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: self.medicationContainerViewHeight))
      self.medicationTextField.delegate = self
      self.currentContainerView?.backgroundColor = UIColor.lightGrayColor()
    } else if sender == self.measurementButton {
      self.selectedType = EventType.Measurement
      let measurementView = NSBundle.mainBundle().loadNibNamed("MeasurementsContainerView", owner: self, options: nil).first as! UIView
      self.currentContainerView = measurementView
      self.view.addSubview(measurementView)
      measurementView.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.view.addConstraint(NSLayoutConstraint(item: measurementView, attribute: NSLayoutAttribute.Trailing, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
      self.view.addConstraint(NSLayoutConstraint(item: measurementView, attribute: NSLayoutAttribute.Leading, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
      self.constraintMeasurementContainerViewBottom = NSLayoutConstraint(item: measurementView, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
      self.view.addConstraint(self.constraintMeasurementContainerViewBottom!)
      measurementView.addConstraint(NSLayoutConstraint(item: measurementView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: self.measurementsContainerViewHeight))
      self.measurementsFeetTextField.delegate = self
      self.measurementInchesTextField.delegate = self
      self.measurementWeightTextField.delegate = self
      self.currentContainerView?.backgroundColor = UIColor.lightGrayColor()
    } else if sender == self.symptomButton {
      self.selectedType = EventType.Symptom
      let symptomsView = NSBundle.mainBundle().loadNibNamed("SymptomsContainerView", owner: self, options: nil).first as! UIView
      self.currentContainerView = symptomsView
      self.view.addSubview(symptomsView)
      symptomsView.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.view.addConstraint(NSLayoutConstraint(item: symptomsView, attribute: NSLayoutAttribute.Trailing, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
      self.view.addConstraint(NSLayoutConstraint(item: symptomsView, attribute: NSLayoutAttribute.Leading, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
      self.constraintSymptomsContainerViewBottom = NSLayoutConstraint(item: symptomsView, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
      self.view.addConstraint(self.constraintSymptomsContainerViewBottom!)
      symptomsView.addConstraint(NSLayoutConstraint(item: symptomsView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: self.symptomsContainerViewHeight))
      self.symptomsTextField.delegate = self
      self.currentContainerView?.backgroundColor = UIColor.lightGrayColor()
    } else if sender == self.temperatureButton {
      self.selectedType = EventType.Temperature
      let temperatureView = NSBundle.mainBundle().loadNibNamed("TemperatureContainerView", owner: self, options: nil).first as! UIView
      self.currentContainerView = temperatureView
      self.view.addSubview(temperatureView)
      temperatureView.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.view.addConstraint(NSLayoutConstraint(item: temperatureView, attribute: NSLayoutAttribute.Trailing, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
      self.view.addConstraint(NSLayoutConstraint(item: temperatureView, attribute: NSLayoutAttribute.Leading, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
      self.constraintTemperatureContainerViewBottom = NSLayoutConstraint(item: temperatureView, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
      self.view.addConstraint(self.constraintTemperatureContainerViewBottom!)
      temperatureView.addConstraint(NSLayoutConstraint(item: temperatureView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: self.temperatureContainerViewHeight))
      self.temperatureTextField.delegate = self
      self.currentContainerView?.backgroundColor = UIColor.lightGrayColor()
    }
  }
  
  
  func dismissKeyboard() {
    if self.medicationTextField != nil && self.medicationTextField.isFirstResponder() {
      self.medicationTextField.resignFirstResponder()
      self.constraintMedicationContainerViewBottom?.constant = 0
    } else if self.measurementsFeetTextField != nil && measurementsFeetTextField.isFirstResponder() {
      self.measurementsFeetTextField.resignFirstResponder()
      self.constraintMeasurementContainerViewBottom!.constant = 0
    } else if self.measurementInchesTextField != nil && measurementInchesTextField.isFirstResponder() {
      self.measurementInchesTextField.resignFirstResponder()
      self.constraintSymptomsContainerViewBottom!.constant = 0
    } else if self.symptomsTextField != nil && symptomsTextField.isFirstResponder() {
      self.symptomsTextField.resignFirstResponder()
      self.constraintSymptomsContainerViewBottom!.constant = 0
    } else if self.temperatureTextField != nil && temperatureTextField.isFirstResponder() {
      self.temperatureTextField.resignFirstResponder()
      self.constraintTemperatureContainerViewBottom!.constant = 0
    }
  }
  
  func dismissKeyboard(textField: UITextField) {
    textField.resignFirstResponder()
    if selectedType == EventType.Medication {
      self.constraintMedicationContainerViewBottom?.constant = 0
    } else if selectedType == EventType.Measurement {
      self.constraintMeasurementContainerViewBottom!.constant = 0
    } else if selectedType == EventType.Symptom {
      self.constraintSymptomsContainerViewBottom!.constant = 0
    } else if selectedType == EventType.Temperature {
      self.constraintTemperatureContainerViewBottom!.constant = 0
    }
    UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
  }
  
  func keyboardWillShow(notification: NSNotification) {
    if self.selectedType != nil {
      if let userInfo = notification.userInfo {
        if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
          self.keyboardHeight = keyboardSize.height
          if selectedType == EventType.Medication {
            self.constraintMedicationContainerViewBottom?.constant = -self.keyboardHeight
          } else if selectedType == EventType.Measurement {
            self.constraintMeasurementContainerViewBottom!.constant = -self.keyboardHeight
          } else if selectedType == EventType.Symptom {
            self.constraintSymptomsContainerViewBottom!.constant = -self.keyboardHeight
          } else if selectedType == EventType.Temperature {
            self.constraintTemperatureContainerViewBottom!.constant = -self.keyboardHeight
          }
          UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
            self.view.layoutIfNeeded()
          })
        }
      }
    }
  }
  
  @IBAction func duplicateRow(sender: UIButton) {
    let contentView = sender.superview
    let cell = contentView!.superview as! EventTableViewCell
    let indexPath = self.tableView.indexPathForCell(cell)
    let eventToDuplicate = kid.events[indexPath!.row]
    eventToDuplicate.id = nil
    kid.events.insert(eventToDuplicate, atIndex: 0)
    self.tableView.reloadData()
  }
  
  func filter() {
    
  }
  
  func getSections() {
    self.sections = [[String]]()
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MM/dd/YYYY"
    for event in self.kid.events {
      var checkedEvents = [String]()
      let date = event.date
      let dateStr = dateFormatter.stringFromDate(date)
      if checkedEvents.isEmpty {
        self.sections!.append([dateStr])
      } else {
        
        for (index, date) in enumerate(checkedEvents) {
          if dateStr == date {
            var section = self.sections![index - 1]
            section.append(dateStr)
          } else {
            self.sections!.append([dateStr])
          }
          checkedEvents.append(dateStr)
        }
      }
    }
  }
  
  @IBAction func doneButtonPressed(sender: UIButton) {
    if self.medicationDoneButton != nil && sender == self.medicationDoneButton {
      let medication = "my meds"
//      let medication = self.medicationTextField.text
      let event = Event(id: nil, type: EventType.Medication, temperature: nil, medication: medication, heightInches: nil, weight: nil, symptom: nil, date: NSDate())
      self.kid.events.insert(event, atIndex: 0)
    } else if self.measurementsDoneButton != nil && sender == self.measurementsDoneButton {
      let heightFeet: Int? = 6
      let heightInches: Int? = 5
//      let heightFeet = self.measurementsFeetTextField.text.toInt()
//      let heightInches = self.measurementInchesTextField.text.toInt()
      let heightTotal = (heightFeet! * 12) + heightInches!
      let weight = self.measurementWeightTextField.text.toInt()
      let event = Event(id: nil, type: EventType.Measurement, temperature: nil, medication: nil, heightInches: heightTotal, weight: weight, symptom: nil, date: NSDate())
      self.kid.events.insert(event, atIndex: 0)
    } else if self.symptomsDoneButton != nil && sender == self.symptomsDoneButton {
      let symptoms = "New symptoms"
//      let symptoms = self.symptomsTextField.text
      let event = Event(id: nil, type: EventType.Symptom, temperature: nil, medication: nil, heightInches: nil, weight: nil, symptom: symptoms, date: NSDate())
      self.kid.events.insert(event, atIndex: 0)
    } else if self.temperatureDoneButton != nil && sender == self.temperatureDoneButton {
      let temperature = 45.4
      let temperatureStr = self.temperatureTextField.text
//      let temperature = (temperatureStr as NSString).doubleValue
      let event = Event(id: nil, type: EventType.Temperature, temperature: temperature, medication: nil, heightInches: nil, weight: nil, symptom: nil, date: NSDate())
      self.kid.events.insert(event, atIndex: 0)
    }
    self.tableView.reloadData()
  }
  
  //MARK:
  //MARK: UITextFieldDelegate
  
  func textFieldDidEndEditing(textField: UITextField) {
//    if textField == self.containerTextField {
//      self.constraintViewContainerBottom.constant -= self.keyboardHeight
//      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
//        self.view.layoutIfNeeded()
//      })
//    } else {
//      self.constraintViewContainerBottom.constant -= self.keyboardHeight
//      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
//        self.view.layoutIfNeeded()
//      })
//    }
    self.dismissKeyboard(textField)
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
//    if textField != self.containerTextField {
//      self.constraintViewContainerBottom.constant -= self.keyboardHeight
//      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
//        self.view.layoutIfNeeded()
//      })
////    } else if textField
//    if textField == self.medicationAmountTextField || textField == self.medicationNameTextField {
//      self.constraintMedicationContainerViewBottom!.constant -= self.keyboardHeight
//      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
//        self.view.layoutIfNeeded()
//      })
//    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.dismissKeyboard(textField)
    return true
  }
  
  //MARK:
  //MARK: UITableViewDataSource
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.kid!.events.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    self.getSections()
    let event = kid.events[indexPath.row]
    if event.type == EventType.Medication {
    var medicationCell = tableView.dequeueReusableCellWithIdentifier("MedicationCell", forIndexPath: indexPath) as! MedicationTableViewCell
      medicationCell.nameTextField.text = self.kid!.events[indexPath.row].medication
      return medicationCell
    } else if event.type == EventType.Measurement {
      var measurementCell = tableView.dequeueReusableCellWithIdentifier("MeasurementCell", forIndexPath: indexPath) as! MeasurementTableViewCell
      if let heightTotalInches = self.kid!.events[indexPath.row].heightInches {
        let heightFeet: Int = heightTotalInches / 12
        let heightInches: Int = heightTotalInches % 12
        measurementCell.heightFeetTextField.text = "\(heightFeet)"
        measurementCell.heightInchesTextField.text = "\(heightInches)"
      }
      if let weight = self.kid!.events[indexPath.row].weight {
        measurementCell.weightTextField.text = "\(weight)"
      }
      return measurementCell
    } else if event.type == EventType.Symptom {
      var symptomCell = tableView.dequeueReusableCellWithIdentifier("SymptomCell", forIndexPath: indexPath) as! SymptomsTableViewCell
      symptomCell.symptomsTextField.text = self.kid!.events[indexPath.row].symptom
      return symptomCell
    } else {
      var temperatureCell = tableView.dequeueReusableCellWithIdentifier("TemperatureCell", forIndexPath: indexPath) as! TemperatureTableViewCell
      temperatureCell.temperatureTextField.text = "\(self.kid!.events[indexPath.row].temperature!)"
      return temperatureCell
    }
  }
  
  //MARK:
  //MARK: UITableViewDelegate
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let event = kid.events[indexPath.row]
    if event.type == EventType.Medication {
      return self.medicationCellHeight
    } else if event.type == EventType.Measurement {
      return self.measurementCellHeight
    } else if event.type == EventType.Symptom {
      return self.symptomsCellHeight
    } else {
      return self.temperatureCellHeight
    }
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//    return self.sections!.count
    return 1
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let section = sections![section]
    return section.first
  }
  
  
}
