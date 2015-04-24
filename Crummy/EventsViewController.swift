//
//  EventsViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
  
  //MARK:
  //MARK: Outlets and Variables
  
  let crummyApiService = CrummyApiService()
  
  @IBOutlet weak var constraintButtonViewContainerBottom: NSLayoutConstraint!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var constraintViewContainerBottom: NSLayoutConstraint!
  @IBOutlet weak var medicationButton: UIButton!
  @IBOutlet weak var temperatureButton: UIButton!
  @IBOutlet weak var symptomButton: UIButton!
  @IBOutlet weak var measurementButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var constraintTableViewBottom: NSLayoutConstraint!
  @IBOutlet weak var constraintTableViewTop: NSLayoutConstraint!
  
  @IBOutlet weak var symptomsTextField: UITextField!
  @IBOutlet weak var symptomsDoneButton: UIButton!
  @IBOutlet weak var measurementsHeightTextField: UITextField!
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
  var currentCellHeight: CGFloat = 0
  
  var constraintMedicationContainerViewBottom: NSLayoutConstraint?
  var constraintMeasurementContainerViewBottom: NSLayoutConstraint?
  var constraintSymptomsContainerViewBottom: NSLayoutConstraint?
  var constraintTemperatureContainerViewBottom: NSLayoutConstraint?
  
  var currentTextField: UITextField?
  var keyboardHeight: CGFloat = 0
  var animationDuration: Double = 0.2
  var tapGestureRecognizer: UITapGestureRecognizer?
  var kid: Kid!
  var selectedType: EventType?
  var currentContainerView: UIView?
  var sections = [[Event]]()
  var currentCellY: CGFloat?
  var inchesInAFoot = 12
  var contentOffsetChangeAmount: CGFloat?
  
  var dateFormatter = NSDateFormatter()
  var currentEvent: Event?
  
  //MARK:
  //MARK: ViewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.dataSource = self
    self.navigationItem.title = "Events - \(kid!.name)"
    
    var cellNib = UINib(nibName: "MedicationTableViewCell", bundle: NSBundle.mainBundle())
    self.tableView.registerNib(cellNib, forCellReuseIdentifier: "MedicationCell")
    cellNib = UINib(nibName: "MeasurementsTableViewCell", bundle: NSBundle.mainBundle())
    self.tableView.registerNib(cellNib, forCellReuseIdentifier: "MeasurementCell")
    cellNib = UINib(nibName: "TemperatureTableViewCell", bundle: NSBundle.mainBundle())
    self.tableView.registerNib(cellNib, forCellReuseIdentifier: "TemperatureCell")
    cellNib = UINib(nibName: "SymptomsTableViewCell", bundle: NSBundle.mainBundle())
    self.tableView.registerNib(cellNib, forCellReuseIdentifier: "SymptomCell")
    
    self.crummyApiService.getEvents(1, completionHandler: { (events, error) -> (Void) in
      if error != nil {
        println("error")
      } else {
        self.kid.events = events!
        self.getSections()
        self.tableView.reloadData()
      }
    })
    
    kid.events.sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
    
    self.getSections()
    
//    self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//    self.view.addGestureRecognizer(self.tapGestureRecognizer!)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
  }
  
  //MARK:
  //MARK: Custom Methods
  
  @IBAction func eventTypePressed(sender: UIButton) {
    self.tableView.userInteractionEnabled = false
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
      self.measurementsHeightTextField.delegate = self
      self.measurementWeightTextField.delegate = self
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
    }
  }
  
  
  func dismissKeyboard() {
    if self.medicationTextField != nil && self.medicationTextField.isFirstResponder() {
      self.medicationTextField.resignFirstResponder()
      self.constraintMedicationContainerViewBottom?.constant = 0
    } else if self.measurementsHeightTextField != nil && measurementsHeightTextField.isFirstResponder() {
      self.measurementsHeightTextField.resignFirstResponder()
      self.constraintMeasurementContainerViewBottom!.constant = 0
    } else if self.measurementWeightTextField != nil && self.measurementWeightTextField.isFirstResponder() {
       self.constraintMeasurementContainerViewBottom!.constant = 0
    } else if self.symptomsTextField != nil && symptomsTextField.isFirstResponder() {
      self.symptomsTextField.resignFirstResponder()
      self.constraintSymptomsContainerViewBottom!.constant = 0
    } else if self.temperatureTextField != nil && temperatureTextField.isFirstResponder() {
      self.temperatureTextField.resignFirstResponder()
      self.constraintTemperatureContainerViewBottom!.constant = 0
    }
    self.tableView.userInteractionEnabled = true
    self.selectedType = nil
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
    self.tableView.userInteractionEnabled = true
    self.selectedType = nil
  }
  
  func keyboardWillShow(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
        self.keyboardHeight = keyboardSize.height
        if self.selectedType != nil {
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
        } else {
          var viewHeight = self.view.frame.height
          println("Bounds height \(viewHeight)")
          println("cell y: \(self.currentCellY!)")
          println("currentCellHeight: \(self.currentCellHeight)")
          println("Superview \(self.view.frame.height)")
          println("Keyboard Height \(self.keyboardHeight)")
          let cellBottomY = currentCellY! + self.currentCellHeight
          let visibleView = self.view.frame.height - self.keyboardHeight
          println("Cell bottom Y: \(cellBottomY)")
          println("Visible View: \(visibleView)")
          
          if cellBottomY > visibleView {
            self.contentOffsetChangeAmount = cellBottomY - visibleView
            println("Need to move \(self.contentOffsetChangeAmount) points")
            self.tableView.contentOffset.y = self.tableView.contentOffset.y + self.contentOffsetChangeAmount!
            UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
              self.view.layoutIfNeeded()
            })
          }
        }
      }
    }
  }
  
  func duplicatePressed(sender: UIButton) {
    if let contentView = sender.superview,
                  cell = contentView.superview as? UITableViewCell,
             indexPath = self.tableView.indexPathForCell(cell)
    {
      let section = self.sections[indexPath.section]
      var eventToDuplicate = section[indexPath.row]
      var newEvent = Event(id: nil, type: eventToDuplicate.type, temperature: eventToDuplicate.temperature, medication: eventToDuplicate.medication, height: eventToDuplicate.height, weight: eventToDuplicate.weight, symptom: eventToDuplicate.symptom, date: NSDate())
      self.createOrUpdateEvent(newEvent)
    }
  }
  
  func createOrUpdateEvent(event: Event) {
    if event.id != nil {
      self.getSections()
      self.tableView.reloadData()
      self.crummyApiService.editEvent("16", event: event) { (event, error) -> (Void) in
        if error != nil {
          println("fail")
        } else {
          println("success")
        }
      }
    } else {
      self.crummyApiService.createEvent("16", event: event) { (eventId, error) -> (Void) in
        if error != nil {
          println("fail")
        } else {
          if let id = eventId {
            event.id = id
            self.kid.events.insert(event, atIndex: 0)
            self.getSections()
            self.tableView.reloadData()
          }
        }
      }
    }
  }

  func getSections() {
    self.sections.removeAll(keepCapacity: false)
    self.sections = [[Event]]()
    var checkedEvents = [Event]()
    for event in self.kid.events {
      let date = event.date
      let cal = NSCalendar.currentCalendar()
      let yearComponent = cal.component(NSCalendarUnit.CalendarUnitYear, fromDate: date)
      let monthComponent = cal.component(NSCalendarUnit.CalendarUnitMonth, fromDate: date)
      let dayComponent = cal.component(NSCalendarUnit.CalendarUnitDay, fromDate: date)
      if checkedEvents.isEmpty {
        self.sections.append([event])
        checkedEvents.append(event)
      } else {
        let lastCheckedEvent = checkedEvents.last
        checkedEvents.append(event)
        let checkedYearComponent = cal.component(NSCalendarUnit.CalendarUnitYear, fromDate: lastCheckedEvent!.date)
        let checkedMonthComponent = cal.component(NSCalendarUnit.CalendarUnitMonth, fromDate: lastCheckedEvent!.date)
        let checkedDayComponent = cal.component(NSCalendarUnit.CalendarUnitDay, fromDate: lastCheckedEvent!.date)
        
        if yearComponent == checkedYearComponent && monthComponent == checkedMonthComponent && dayComponent == checkedDayComponent {
          self.sections[sections.count - 1].append(event)
        } else {
          self.sections.append([event])
        }
      }
    }
    println(sections.count)
  }
  
  @IBAction func menuButtonPressed(sender: UIButton) {
    self.currentContainerView?.removeFromSuperview()
    self.constraintButtonViewContainerBottom.constant = 0
    UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    self.currentEvent = nil
    self.tableView.userInteractionEnabled = true
  }
  
  
  @IBAction func doneButtonPressed(sender: UIButton) {
    var currentContainerView: UIView?
    var event: Event?
    if self.medicationDoneButton != nil && sender == self.medicationDoneButton {
      self.medicationTextField.resignFirstResponder()
      if !self.medicationTextField.text.isEmpty {
        if let updateEvent = self.currentEvent {
          event = updateEvent
          event!.medication = medicationTextField.text
        } else {
          event = Event(id: nil, type: EventType.Medication, temperature: nil, medication: self.medicationTextField.text, height: nil, weight: nil, symptom: nil, date: NSDate())
        }
        self.createOrUpdateEvent(event!)
      }
      self.medicationTextField.text = nil
    } else if self.measurementsDoneButton != nil && sender == self.measurementsDoneButton {
      self.measurementsHeightTextField.resignFirstResponder()
      self.measurementWeightTextField.resignFirstResponder()
      var height: String?
      var weight: String?
      if !self.measurementsHeightTextField.text.isEmpty {
        height = self.measurementsHeightTextField.text
      }
      if !self.measurementWeightTextField.text.isEmpty {
        weight = self.measurementWeightTextField.text
      }
      if let updatedEvent = self.currentEvent {
        event = updatedEvent
        event!.height = height
        event!.weight = weight
      } else {
        event = Event(id: nil, type: EventType.Measurement, temperature: nil, medication: nil, height: height, weight: weight, symptom: nil, date: NSDate())
      }
      self.createOrUpdateEvent(event!)
      self.measurementsHeightTextField.text = nil
      self.measurementWeightTextField.text = nil
    } else if self.symptomsDoneButton != nil && sender == self.symptomsDoneButton {
      self.symptomsTextField.resignFirstResponder()
      if !self.symptomsTextField.text.isEmpty {
        if let updatedEvent = self.currentEvent {
          event = updatedEvent
          event!.symptom = self.symptomsTextField.text
        } else {
          event = Event(id: nil, type: EventType.Symptom, temperature: nil, medication: nil, height: nil, weight: nil, symptom: self.symptomsTextField.text, date: NSDate())
        }
        self.createOrUpdateEvent(event!)
      }
      self.symptomsTextField.text = nil
    } else if self.temperatureDoneButton != nil && sender == self.temperatureDoneButton {
      self.temperatureTextField.resignFirstResponder()
      if !self.temperatureTextField.text.isEmpty {
        if let updateEvent = self.currentEvent {
          event = updateEvent
          event!.temperature = self.temperatureTextField.text
        } else {
          event = Event(id: nil, type: EventType.Temperature, temperature: self.temperatureTextField.text, medication: nil, height: nil, weight: nil, symptom: nil, date: NSDate())
        }
        self.createOrUpdateEvent(event!)
      }
      self.temperatureTextField.text = nil
    }
    self.currentContainerView?.removeFromSuperview()
    self.constraintButtonViewContainerBottom.constant = 0
    UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    
    self.currentEvent = nil
  }
  
  //MARK:
  //MARK: UITextFieldDelegate
  
  func textFieldDidEndEditing(textField: UITextField) {
    self.dismissKeyboard(textField)
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    if self.measurementsHeightTextField != nil && (textField == self.measurementsHeightTextField ||
      textField == self.measurementWeightTextField) &&
      self.constraintMeasurementContainerViewBottom?.constant == 0 {
      self.constraintMeasurementContainerViewBottom?.constant = -self.keyboardHeight
      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.dismissKeyboard(textField)
    
    if self.contentOffsetChangeAmount != nil {
      self.tableView.contentOffset.y -= self.contentOffsetChangeAmount!
      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
    }
    self.contentOffsetChangeAmount != nil
    return true
  }
  
  func doneNumberPadPressed(barButton: UIBarButtonItem) {
    self.currentTextField!.resignFirstResponder()
    if self.contentOffsetChangeAmount != nil {
      self.tableView.contentOffset.y -= self.contentOffsetChangeAmount!
      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
    }
    self.contentOffsetChangeAmount = nil
    
  }
  
  func enteredTextField(textField: UITextField) {
    if let contentView = textField.superview,
      cell = contentView.superview as? UITableViewCell,
      indexPath = self.tableView.indexPathForCell(cell)
{
      var rectOfCellInTableView = tableView.rectForRowAtIndexPath(indexPath)
      var rectOfCellInSuperview = tableView.convertRect(rectOfCellInTableView, toView: self.view)
      self.currentCellY = rectOfCellInSuperview.origin.y
      textField.delegate = self
      self.currentTextField = textField
      let section = self.sections[indexPath.section]
      let eventType = section[indexPath.row].type
      if eventType == EventType.Measurement || eventType == EventType.Temperature {
        if eventType == EventType.Measurement {
          self.currentCellHeight = self.measurementCellHeight
        } else {
          self.currentCellHeight = self.temperatureCellHeight
        }
        var toolBar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        toolBar.barStyle = UIBarStyle.Default
        let doneBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneNumberPadPressed:")
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),doneBarButton]
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
      } else if eventType == EventType.Symptom {
        self.currentCellHeight = self.symptomsCellHeight
      } else {
        self.currentCellHeight = self.medicationCellHeight
      }
    }
  }
  
  //MARK:
  //MARK: UITableViewDataSource
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sections[section].count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let section = sections[indexPath.section]
    
    self.dateFormatter.dateFormat = "hh:mm a"
    
    let event = section[indexPath.row]
    if event.type == EventType.Medication {
      var medicationCell = tableView.dequeueReusableCellWithIdentifier("MedicationCell", forIndexPath: indexPath) as! MedicationTableViewCell
      medicationCell.medicationLabel.text = nil
      medicationCell.timeLabel.text = nil
      medicationCell.medicationLabel.text = event.medication
      medicationCell.timeLabel.text = self.dateFormatter.stringFromDate(event.date)
      medicationCell.duplicateButton.addTarget(self, action: "duplicatePressed:", forControlEvents: UIControlEvents.TouchUpInside)
      return medicationCell
    } else if event.type == EventType.Measurement {
      var measurementCell = tableView.dequeueReusableCellWithIdentifier("MeasurementCell", forIndexPath: indexPath) as! MeasurementTableViewCell
      measurementCell.heightLabel.text = nil
      measurementCell.weightLabel.text = nil
      measurementCell.timeLabel.text = nil
      measurementCell.weightLabel.text = event.weight
      measurementCell.heightLabel.text = event.height
      measurementCell.timeLabel.text = self.dateFormatter.stringFromDate(event.date)
      measurementCell.duplicateButton.addTarget(self, action: "duplicatePressed:", forControlEvents: UIControlEvents.TouchUpInside)
      return measurementCell
    } else if event.type == EventType.Symptom {
      var symptomCell = tableView.dequeueReusableCellWithIdentifier("SymptomCell", forIndexPath: indexPath) as! SymptomsTableViewCell
      symptomCell.symptomsLabel.text = nil
      symptomCell.timeLabel.text = nil
      symptomCell.symptomsLabel.text = event.symptom
      symptomCell.timeLabel.text = self.dateFormatter.stringFromDate(event.date)
      symptomCell.duplicateButton.addTarget(self, action: "duplicatePressed:", forControlEvents: UIControlEvents.TouchUpInside)
      return symptomCell
    } else {
      var temperatureCell = tableView.dequeueReusableCellWithIdentifier("TemperatureCell", forIndexPath: indexPath) as! TemperatureTableViewCell
      temperatureCell.temperatureLabel.text = nil
      temperatureCell.timeLabel.text = nil
      temperatureCell.temperatureLabel.text = event.temperature
      temperatureCell.timeLabel.text = self.dateFormatter.stringFromDate(event.date)
      temperatureCell.duplicateButton.addTarget(self, action: "duplicatePressed:", forControlEvents: UIControlEvents.TouchUpInside)
      return temperatureCell
    }
  }
  
  //MARK:
  //MARK: UITableViewDelegate
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let section = sections[indexPath.section]
    let event = section[indexPath.row]
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
      return self.sections.count
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let section = sections[section]
    
    let cal = NSCalendar.currentCalendar()
    let dateForSection = cal.startOfDayForDate(section.first!.date)
    let today = cal.startOfDayForDate(NSDate())
    let yesterday = cal.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: -1, toDate: today, options: nil)
    if today == dateForSection {
     return "Today"
    } else if yesterday == dateForSection {
      return "Yesterday"
    } else {
      var dateFormatter = NSDateFormatter()
      dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
      let dateStr = dateFormatter.stringFromDate(dateForSection)
      return dateStr
    }
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
    self.crummyApiService.deleteEvent("16", eventId: self.kid.events[indexPath.row].id!) { (eventId, error) -> (Void) in
      if error != nil {
        println("error occured")
      } else {
        if error != nil {
          println("error on delete")
        }
        println("successful delete")
      }
    }
    var section = indexPath.section
    self.kid.events.removeAtIndex(indexPath.row)
    self.getSections()
    if tableView.numberOfSections() > self.sections.count {
      tableView.deleteSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Left)
    } else {
      let indexPaths = [indexPath]
      tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }

  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let event = self.kid.events[indexPath.row]
    self.currentEvent = event
    self.tableView.userInteractionEnabled = false
    self.constraintButtonViewContainerBottom.constant += 60
    UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    if event.type == EventType.Medication {
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
      self.medicationTextField.text = event.medication
    } else if event.type == EventType.Measurement {
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
      self.measurementsHeightTextField.delegate = self
      self.measurementWeightTextField.delegate = self
      self.measurementsHeightTextField.text = event.height
      self.measurementWeightTextField.text = event.weight
    } else if event.type == EventType.Symptom {
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
      self.symptomsTextField.text = event.symptom
    } else if event.type == EventType.Temperature {
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
      self.temperatureTextField.text = event.temperature
    }

  }
}
