//
//  EventsViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var containerTextField: UITextField!
  @IBOutlet weak var constraintViewContainerBottom: NSLayoutConstraint!
  
  var keyboardHeight: CGFloat = 0
  var animationDuration: Double = 0.2
  var tapGestureRecognizer: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.containerTextField.delegate = self
    
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
}
