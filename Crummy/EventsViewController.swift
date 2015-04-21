//
//  EventsViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {
  @IBOutlet weak var containerTextField: UITextField!
  @IBOutlet weak var constraintViewContainerBottom: NSLayoutConstraint!
  @IBOutlet weak var constraintEventTypeViewBottom: NSLayoutConstraint!
  
  @IBOutlet weak var eventTypeContainerView: UIView!
  @IBOutlet weak var textFieldContainerView: UIView!
  @IBOutlet weak var medicationButton: UIButton!
  @IBOutlet weak var symptomButton: UIButton!
  @IBOutlet weak var measurementButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  var keyboardHeight: CGFloat = 0
  var animationDuration: Double = 0.2
  var tapGestureRecognizer: UITapGestureRecognizer?
  var kid: Kid!
  
  
  
  @IBAction func eventTypePressed(sender: UIButton) {
    self.textFieldContainerView.userInteractionEnabled = true
    self.constraintEventTypeViewBottom.constant += 60
    UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    if sender == medicationButton {
      self.containerTextField.placeholder = "Enter medication name and amount"
    } else if sender == measurementButton {
      self.containerTextField.placeholder = "Enter height and weight"
    } else {
      self.containerTextField.placeholder = "Enter symptoms"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.kid.events.append(Event(id: 1, type: EventType.Medication, temperature: 98.9, medicationName: "test", medicationAmount: "2 pills", heightInches: 32, weight: 43, symptom: "symptom"))
    self.kid.events.append(Event(id: 1, type: EventType.Symptom, temperature: 98.9, medicationName: "test", medicationAmount: "2 pills", heightInches: 32, weight: 43, symptom: "symptom"))
    self.kid.events.append(Event(id: 1, type: EventType.Temperature, temperature: 98.9, medicationName: "test", medicationAmount: "2 pills", heightInches: 32, weight: 43, symptom: "symptom"))
    self.kid.events.append(Event(id: 1, type: EventType.Measurement, temperature: 98.9, medicationName: "test", medicationAmount: "2 pills", heightInches: 32, weight: 43, symptom: "symptom"))
    
    
    
    
    
    self.containerTextField.delegate = self
    self.tableView.dataSource = self
    self.textFieldContainerView.userInteractionEnabled = false
    
    self.navigationItem.title = kid.name
    
    self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    self.view.addGestureRecognizer(self.tapGestureRecognizer!)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
  }
  
  func dismissKeyboard() {
    self.containerTextField.resignFirstResponder()
  }
  
  func keyboardWillShow(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
          self.keyboardHeight = keyboardSize.height
          self.constraintViewContainerBottom.constant = self.keyboardHeight
          UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
            self.view.layoutIfNeeded()
          })
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
  
  //MARK:
  //MARK: UITextFieldDelegate
  
  func textFieldDidEndEditing(textField: UITextField) {
    if textField == containerTextField {
      self.constraintViewContainerBottom.constant -= self.keyboardHeight
      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.dismissKeyboard()
    return true
  }
  
  //MARK:
  //MARK: UITableViewDataSource
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return kid!.events.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
    cell.eventTextField.text = self.kid.events[indexPath.row].type.description()
    return cell
  }
}
