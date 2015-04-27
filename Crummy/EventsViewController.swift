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
  
  @IBOutlet weak var constraintButtonViewContainerBottom: NSLayoutConstraint!
  @IBOutlet weak var constraintDatePickerCenterX: NSLayoutConstraint!
  @IBOutlet weak var constraintToolbarCenterX: NSLayoutConstraint!
  @IBOutlet weak var temperatureButton: UIButton!
  @IBOutlet weak var medicationButton: UIButton!
  @IBOutlet weak var symptomButton: UIButton!
  @IBOutlet weak var measurementButton: UIButton!
  @IBOutlet weak var symptomsDoneButton: UIButton!
  @IBOutlet weak var measurementsDoneButton: UIButton!
  @IBOutlet weak var temperatureDoneButton: UIButton!
  @IBOutlet weak var medicationDoneButton: UIButton!
  @IBOutlet weak var symptomsTextField: UITextField!
  @IBOutlet weak var measurementsHeightTextField: UITextField!
  @IBOutlet weak var measurementWeightTextField: UITextField!
  @IBOutlet weak var temperatureTextField: UITextField!
  @IBOutlet weak var medicationTextField: UITextField!
  @IBOutlet weak var eventTypeContainerView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  let crummyApiService = CrummyApiService()
  let medicationContainerViewHeight: CGFloat = 75
  let measurementsContainerViewHeight: CGFloat = 96
  let symptomsContainerViewHeight: CGFloat = 75
  let temperatureContainerViewHeight: CGFloat = 86
  let medicationCellHeight: CGFloat = 56
  let measurementCellHeight: CGFloat = 92
  let symptomsCellHeight: CGFloat = 55
  let temperatureCellHeight: CGFloat = 53
  let eventTypeContainerHeight: CGFloat = 75
  let datePickerToolbarBuffer: CGFloat = 600
  let toolBarHeight: CGFloat = 50
  let headerHeight: CGFloat = 32
  let rowSelectedBorderSize: CGFloat = 3
  let animationDuration: Double = 0.2
  let longerAnimationDuration: Double = 0.4
  let headerViewFrame: CGRect = CGRectMake(15, 0, 300, 30)
  let titleFontSize: CGFloat = 26
  let titleLabel = UILabel(frame: CGRectMake(0, 0, 80, 40))
  let headerFontSize: CGFloat = 23
  let titleColor = UIColor(red: 0.060, green: 0.158, blue: 0.408, alpha: 1.000)
  let eventTypeConstraintBuffer: CGFloat = 600
  
  var currentCellHeight: CGFloat = 0
  var currentContainerViewHeight: CGFloat = 0
  var constraintContainerViewBottom: NSLayoutConstraint?
  var currentTextField: UITextField?
  var keyboardHeight: CGFloat = 0
  var kid = Kid()
  var selectedType: EventType?
  var currentContainerView: UIView?
  var sections = [[Event]]()
  var currentCellY: CGFloat?
  var contentOffsetChangeAmount: CGFloat?
  var dateFormatter = NSDateFormatter()
  var currentEvent: Event?
  var kidId: String?
  var kidName: String?
  var allEvents = [Event]()
  var currentCell: UITableViewCell?
  
  //MARK:
  //MARK: ViewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.dataSource = self
    
    var containerBarColor = UIColor(patternImage: UIImage(named: "ContainerViewBar")!)
    self.eventTypeContainerView.backgroundColor = containerBarColor
    self.titleLabel.textAlignment = .Center
    self.titleLabel.textColor = self.titleColor
    self.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: self.titleFontSize)
    self.titleLabel.text = "Events - \(self.kidName!)"
    self.navigationItem.titleView = self.titleLabel
    
    var cellNib = UINib(nibName: "MedicationTableViewCell", bundle: NSBundle.mainBundle())
    self.tableView.registerNib(cellNib, forCellReuseIdentifier: "MedicationCell")
    cellNib = UINib(nibName: "MeasurementsTableViewCell", bundle: NSBundle.mainBundle())
    self.tableView.registerNib(cellNib, forCellReuseIdentifier: "MeasurementCell")
    cellNib = UINib(nibName: "TemperatureTableViewCell", bundle: NSBundle.mainBundle())
    self.tableView.registerNib(cellNib, forCellReuseIdentifier: "TemperatureCell")
    cellNib = UINib(nibName: "SymptomsTableViewCell", bundle: NSBundle.mainBundle())
    self.tableView.registerNib(cellNib, forCellReuseIdentifier: "SymptomCell")
    
    self.crummyApiService.getEvents(self.kidId!, completionHandler: { (events, error) -> (Void) in
      if error != nil {
        println("error")
      } else {
        if !events!.isEmpty {
          self.kid.events = events!
          self.getSections(true)
          self.tableView.reloadData()
        }
      }
    })
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
  }
  
  //MARK:
  //MARK: Custom Methods
  
  @IBAction func eventTypePressed(sender: UIButton) {
    self.constraintButtonViewContainerBottom.constant += self.eventTypeContainerHeight
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
      self.constraintContainerViewBottom =  NSLayoutConstraint(item: medicationView, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
          self.view.addConstraint(self.constraintContainerViewBottom!)
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
      self.constraintContainerViewBottom =  NSLayoutConstraint(item: measurementView, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
      self.view.addConstraint(self.constraintContainerViewBottom!)
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
      self.constraintContainerViewBottom =  NSLayoutConstraint(item: symptomsView, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
      self.view.addConstraint(self.constraintContainerViewBottom!)
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
      self.constraintContainerViewBottom =  NSLayoutConstraint(item: temperatureView, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
      self.view.addConstraint(self.constraintContainerViewBottom!)
      temperatureView.addConstraint(NSLayoutConstraint(item: temperatureView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: self.temperatureContainerViewHeight))
      self.temperatureTextField.delegate = self
    }
    var containerBarColor = UIColor(patternImage: UIImage(named: "ContainerViewBar")!)
    self.currentContainerView!.backgroundColor = containerBarColor
  }
  
  
  func dismissKeyboard() {
    if self.medicationTextField != nil && self.medicationTextField.isFirstResponder() {
      self.medicationTextField.resignFirstResponder()
    } else if self.measurementsHeightTextField != nil && measurementsHeightTextField.isFirstResponder() {
      self.measurementsHeightTextField.resignFirstResponder()
    } else if self.symptomsTextField != nil && symptomsTextField.isFirstResponder() {
      self.symptomsTextField.resignFirstResponder()
    } else if self.temperatureTextField != nil && temperatureTextField.isFirstResponder() {
      self.temperatureTextField.resignFirstResponder()
    }
    self.constraintContainerViewBottom!.constant = 0
    self.tableView.userInteractionEnabled = true
    self.selectedType = nil
  }
  
  func dismissKeyboard(textField: UITextField) {
    textField.resignFirstResponder()
    self.constraintContainerViewBottom!.constant = 0
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
        self.constraintContainerViewBottom?.constant = -self.keyboardHeight
        UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
          self.view.layoutIfNeeded()
        })
      }
    }
    if currentEvent != nil {
      var viewHeight = self.view.frame.height
      let cellBottomY = currentCellY! + self.currentCellHeight
      let visibleView = self.view.frame.height - self.keyboardHeight
      if cellBottomY > visibleView - self.currentContainerViewHeight {
        self.contentOffsetChangeAmount = cellBottomY - visibleView + self.currentContainerViewHeight
        self.animateTableViewOffset(false)
      }
    }
  }
  
  func animateTableViewOffset(toOriginalOffset: Bool) {
    if toOriginalOffset {
      self.tableView.contentOffset.y = self.tableView.contentOffset.y - self.contentOffsetChangeAmount!
    } else {
      self.tableView.contentOffset.y = self.tableView.contentOffset.y + self.contentOffsetChangeAmount!
    }
    UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
  }
  
  func duplicatePressed(sender: UIButton) {
    if self.currentCell != nil {
      return
    }
    
    if let contentView = sender.superview,
                  cell = contentView.superview as? UITableViewCell,
             indexPath = self.tableView.indexPathForCell(cell) {
      let section = self.sections[indexPath.section]
      var eventToDuplicate = section[indexPath.row]
      var newEvent = Event(id: nil, type: eventToDuplicate.type, temperature: eventToDuplicate.temperature, medication: eventToDuplicate.medication, height: eventToDuplicate.height, weight: eventToDuplicate.weight, symptom: eventToDuplicate.symptom, date: NSDate())
      self.createOrUpdateEvent(newEvent)
    }
  }
  
  func createOrUpdateEvent(event: Event) {
    if event.id != nil {
      self.getSections(false)
      self.tableView.reloadData()
      self.crummyApiService.editEvent(self.kidId!, event: event) { (event, error) -> (Void) in
        if error != nil {
          println("fail")
        } else {
          println("success")
        }
      }
    } else {
      self.crummyApiService.createEvent(self.kidId!, event: event) { (eventId, error) -> (Void) in
        if error != nil {
          println("fail")
        } else {
          if let id = eventId {
            event.id = id
            if self.allEvents.count > 0 {
              self.sections[0].insert(event, atIndex: 0)
            } else {
              self.sections.append([event])
            }
            self.getSections(false)
            self.tableView.reloadData()
          }
        }
      }
    }
  }

  func getSections(isOnLoad: Bool) {
    if isOnLoad {
      self.allEvents = self.kid.events
    } else {
      self.allEvents = self.sections.flatMap{ $0 }
    }
    self.allEvents.sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
    self.sections.removeAll(keepCapacity: false)
    self.sections = [[Event]]()
    var checkedEvents = [Event]()
    for event in self.allEvents {
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
  
  @IBAction func menuButtonPressed(sender: UIButton?) {
    self.currentContainerView?.removeFromSuperview()
    self.currentContainerView = nil
    self.constraintButtonViewContainerBottom.constant = 0
    UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    self.currentEvent = nil
    self.tableView.userInteractionEnabled = true
    if let cell = currentCell {
      cell.contentView.layer.borderColor = UIColor.clearColor().CGColor
      cell.contentView.layer.borderWidth = 0
      cell.selected = false
      self.currentCell = nil
    }
    if self.contentOffsetChangeAmount != nil {
      self.animateTableViewOffset(true)
      self.contentOffsetChangeAmount = nil
    }
  }
  
  
  @IBAction func doneButtonPressed(sender: UIButton) {
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
    self.constraintButtonViewContainerBottom.constant = 0
    self.eventTypeContainerView.alpha = 0
    self.currentContainerView?.removeFromSuperview()
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.eventTypeContainerView.alpha = 1
      self.view.layoutIfNeeded()
    })
    self.tableView.userInteractionEnabled = true
    self.currentEvent = nil
    if let cell = currentCell {
      cell.contentView.layer.borderColor = UIColor.clearColor().CGColor
      cell.contentView.layer.borderWidth = 0
      self.currentCell = nil
    }
    self.currentContainerView = nil
    if self.contentOffsetChangeAmount != nil {
      self.animateTableViewOffset(true)
      self.contentOffsetChangeAmount = nil
    }
  }
  
  func showDatePicker(button: UIButton) {
    if self.currentCell != nil {
      return
    }
    self.tableView.userInteractionEnabled = false
    self.eventTypeContainerView.userInteractionEnabled = false
    if let contentView = button.superview,
    cell = contentView.superview as? UITableViewCell,
      indexPath = self.tableView.indexPathForCell(cell) {
      let section = indexPath.section
      let event = self.sections[section][indexPath.row]
      self.currentEvent = event
      self.datePicker.date = event.date
      self.datePicker.frame.height + self.view.frame.height
      self.constraintDatePickerCenterX.constant = 0
      self.constraintToolbarCenterX.constant = 0
      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
        self.view.layoutIfNeeded()
        self.datePicker.backgroundColor = UIColor.whiteColor()
      })
    }
  }
  
  @IBAction func doneDatePicker(sender: UIBarButtonItem) {
    if let event = self.currentEvent {
      if event.date != self.datePicker.date {
        event.date = self.datePicker.date
        self.getSections(false)
        self.tableView.reloadData()
        self.createOrUpdateEvent(event)
      }
        self.tableView.userInteractionEnabled = true
        self.eventTypeContainerView.userInteractionEnabled = true
        self.constraintDatePickerCenterX.constant = -self.datePickerToolbarBuffer
        self.constraintToolbarCenterX.constant = -self.datePickerToolbarBuffer
        UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
          self.view.layoutIfNeeded()
          self.datePicker.backgroundColor = UIColor.whiteColor()
        })
      }
    
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
      self.constraintContainerViewBottom?.constant == 0 {
      self.constraintContainerViewBottom?.constant = -self.keyboardHeight
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
    
    self.currentContainerView?.removeFromSuperview()
    self.constraintButtonViewContainerBottom.constant = 0
    UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    self.currentEvent = nil
    self.tableView.userInteractionEnabled = true
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
        var toolBar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.width, self.toolBarHeight))
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
      medicationCell.timeButton.setTitle(nil, forState: .Normal)
      medicationCell.medicationLabel.text = event.medication
      medicationCell.timeButton.setTitle(self.dateFormatter.stringFromDate(event.date), forState: .Normal)
      medicationCell.timeButton.addTarget(self, action: "showDatePicker:", forControlEvents: UIControlEvents.TouchUpInside)
      medicationCell.duplicateButton.addTarget(self, action: "duplicatePressed:", forControlEvents: UIControlEvents.TouchUpInside)
      return medicationCell
    } else if event.type == EventType.Measurement {
      var measurementCell = tableView.dequeueReusableCellWithIdentifier("MeasurementCell", forIndexPath: indexPath) as! MeasurementTableViewCell
      measurementCell.heightLabel.text = nil
      measurementCell.weightLabel.text = nil
      measurementCell.timeButton.setTitle(nil, forState: .Normal)
      measurementCell.weightLabel.text = event.weight
      measurementCell.heightLabel.text = event.height
      measurementCell.timeButton.setTitle(self.dateFormatter.stringFromDate(event.date), forState: .Normal)
      measurementCell.timeButton.addTarget(self, action: "showDatePicker:", forControlEvents: UIControlEvents.TouchUpInside)
      measurementCell.duplicateButton.addTarget(self, action: "duplicatePressed:", forControlEvents: UIControlEvents.TouchUpInside)
      return measurementCell
    } else if event.type == EventType.Symptom {
      var symptomCell = tableView.dequeueReusableCellWithIdentifier("SymptomCell", forIndexPath: indexPath) as! SymptomsTableViewCell
      symptomCell.symptomsLabel.text = nil
      symptomCell.timeButton.setTitle(nil, forState: .Normal)
      symptomCell.symptomsLabel.text = event.symptom
      symptomCell.timeButton.setTitle(self.dateFormatter.stringFromDate(event.date), forState: .Normal)
      symptomCell.timeButton.addTarget(self, action: "showDatePicker:", forControlEvents: UIControlEvents.TouchUpInside)
      symptomCell.duplicateButton.addTarget(self, action: "duplicatePressed:", forControlEvents: UIControlEvents.TouchUpInside)
      return symptomCell
    } else {
      var temperatureCell = tableView.dequeueReusableCellWithIdentifier("TemperatureCell", forIndexPath: indexPath) as! TemperatureTableViewCell
      temperatureCell.temperatureLabel.text = nil
      temperatureCell.timeButton.setTitle(nil, forState: .Normal)
      temperatureCell.temperatureLabel.text = event.temperature
      temperatureCell.timeButton.setTitle(self.dateFormatter.stringFromDate(event.date), forState: .Normal)
      temperatureCell.timeButton.addTarget(self, action: "showDatePicker:", forControlEvents: UIControlEvents.TouchUpInside)
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
      dateFormatter.dateFormat = "EEEE, MMMM dd"
      let dateStr = dateFormatter.stringFromDate(dateForSection)
      return dateStr
    }
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    let currentSection = indexPath.section
    self.crummyApiService.deleteEvent(self.kidId!, eventId: self.sections[currentSection][indexPath.row].id!) { (eventId, error) -> (Void) in
      if error != nil {
        println("error occured")
      } else {
        if error != nil {
          println("error on delete")
        }
        println("successful delete")
      }
    }
    var section = self.sections[indexPath.section]
    section.removeAtIndex(indexPath.row)
    self.sections[indexPath.section] = section
    let indexPaths = [indexPath]
    
    if section.count < 1 {
      self.sections.removeAtIndex(indexPath.section)
      tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Left)
    } else {
      tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
  }
  
  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    if let currentCell = tableView.cellForRowAtIndexPath(indexPath) {
      currentCell.contentView.layer.borderColor = UIColor.clearColor().CGColor
      currentCell.contentView.layer.borderWidth = 0
      self.currentCell = nil
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    self.menuButtonPressed(nil)
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let currentCell = tableView.cellForRowAtIndexPath(indexPath) {
      if currentCell == self.currentCell {
        self.tableView(tableView, didDeselectRowAtIndexPath: indexPath)
        if self.contentOffsetChangeAmount != nil {
          self.animateTableViewOffset(true)
          self.contentOffsetChangeAmount = nil
        }
        return
      }
      currentCell.contentView.layer.borderColor = UIColor.redColor().CGColor
      currentCell.contentView.layer.borderWidth = self.rowSelectedBorderSize
      self.currentCell = currentCell
      let rectOfCellInTableView = tableView.rectForRowAtIndexPath(indexPath)
      let rectOfCellInSuperview = tableView.convertRect(rectOfCellInTableView, toView: self.view)
      self.currentCellY = rectOfCellInSuperview.origin.y
    }
    if currentContainerView != nil {
      self.currentContainerView!.removeFromSuperview()
      self.constraintButtonViewContainerBottom.constant = 0
      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
    }
    let currentSection = indexPath.section
    let event = self.sections[currentSection][indexPath.row]
    self.currentEvent = event
    self.constraintButtonViewContainerBottom.constant += self.eventTypeContainerHeight
    UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    if event.type == EventType.Medication {
      self.selectedType = EventType.Medication
      let medicationView = NSBundle.mainBundle().loadNibNamed("MedicationContainerView", owner: self, options: nil).first as! UIView
      self.currentContainerView = medicationView
      self.currentContainerViewHeight = medicationContainerViewHeight
      self.constraintContainerViewBottom = NSLayoutConstraint(item: medicationView, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
      self.currentContainerViewHeight = self.medicationContainerViewHeight
      self.medicationTextField.delegate = self
      self.medicationTextField.text = event.medication
      self.currentCellHeight = self.medicationCellHeight
      self.medicationTextField.becomeFirstResponder()
    } else if event.type == EventType.Measurement {
      self.selectedType = EventType.Measurement
      let measurementView = NSBundle.mainBundle().loadNibNamed("MeasurementsContainerView", owner: self, options: nil).first as! UIView
      self.currentContainerView = measurementView
      self.currentContainerViewHeight = measurementsContainerViewHeight
    self.constraintContainerViewBottom = NSLayoutConstraint(item: measurementView, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
      self.currentContainerViewHeight = self.measurementsContainerViewHeight
      self.measurementsHeightTextField.delegate = self
      self.measurementWeightTextField.delegate = self
      self.measurementsHeightTextField.text = event.height
      self.measurementWeightTextField.text = event.weight
      self.currentCellHeight = self.measurementCellHeight
      self.measurementsHeightTextField.becomeFirstResponder()
    } else if event.type == EventType.Symptom {
      self.selectedType = EventType.Symptom
      let symptomsView = NSBundle.mainBundle().loadNibNamed("SymptomsContainerView", owner: self, options: nil).first as! UIView
      self.currentContainerView = symptomsView
      self.currentContainerViewHeight = self.symptomsContainerViewHeight
    self.constraintContainerViewBottom = NSLayoutConstraint(item: symptomsView, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
      self.symptomsTextField.delegate = self
      self.symptomsTextField.text = event.symptom
      self.currentCellHeight = self.symptomsCellHeight
      self.symptomsTextField.becomeFirstResponder()
    } else if event.type == EventType.Temperature {
      self.selectedType = EventType.Temperature
      let temperatureView = NSBundle.mainBundle().loadNibNamed("TemperatureContainerView", owner: self, options: nil).first as! UIView
      self.currentContainerView = temperatureView
      self.currentContainerViewHeight = temperatureContainerViewHeight
      self.constraintContainerViewBottom = NSLayoutConstraint(item: temperatureView, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
      self.currentContainerViewHeight = self.temperatureContainerViewHeight
      self.temperatureTextField.delegate = self
      self.temperatureTextField.text = event.temperature
      self.currentCellHeight = self.temperatureCellHeight
      self.temperatureTextField.becomeFirstResponder()
    }
    self.currentContainerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.view.addSubview(self.currentContainerView!)
    var constraintTrailing = NSLayoutConstraint(item: self.currentContainerView!, attribute: NSLayoutAttribute.Trailing, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: self.eventTypeConstraintBuffer)
    self.view.addConstraint(constraintTrailing)
    var constraintLeading = NSLayoutConstraint(item: self.currentContainerView!, attribute: NSLayoutAttribute.Leading, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: -self.eventTypeConstraintBuffer)
    self.view.addConstraint(constraintLeading)
    self.view.addConstraint(self.constraintContainerViewBottom!)
    self.currentContainerView!.addConstraint(NSLayoutConstraint(item: self.currentContainerView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: self.currentContainerViewHeight))
    self.view.layoutIfNeeded()
    constraintTrailing.constant = 0
    constraintLeading.constant = 0
    self.currentContainerView!.alpha = 0
    UIView.animateWithDuration(self.longerAnimationDuration, animations: { () -> Void in
      self.currentContainerView!.alpha = 1
      self.view.layoutIfNeeded()
    })
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    var view = CustomHeaderView()
    var headerLabel = UILabel(frame: self.headerViewFrame)
    headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
    headerLabel.textColor = UIColor.whiteColor()
    headerLabel.font = UIFont(name: "HelveticaNeue-Light", size: self.headerFontSize)
    view.addSubview(headerLabel)
    return view
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return self.headerHeight
  }
}
