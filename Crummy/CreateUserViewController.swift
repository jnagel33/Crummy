//
//  CreateUserViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var emailAddressTextField: UITextField!

  @IBOutlet weak var constraintCenterY: NSLayoutConstraint!
  
  var bufferForSlidingLoginViewEmail: CGFloat = 80
  var bufferForSlidingLoginViewPassword: CGFloat = 40
  var animationDuration: Double = 0.2
  var tapGestureRecognizer: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.usernameTextField.delegate = self
    self.passwordTextField.delegate = self
    self.emailAddressTextField.delegate = self
    
    tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    self.view.addGestureRecognizer(self.tapGestureRecognizer!)

  }
  
  @IBAction func doneBarButton(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func cancelPressed(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func dismissKeyboard() {
    self.usernameTextField.resignFirstResponder()
    self.passwordTextField.resignFirstResponder()
    self.emailAddressTextField.resignFirstResponder()
  }
  
  //MARK:
  //MARK: UITextFieldDelegate
  
  func textFieldDidBeginEditing(textField: UITextField) {
    if textField == self.emailAddressTextField {
      self.constraintCenterY.constant += self.bufferForSlidingLoginViewEmail
      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
    } else if textField == self.passwordTextField {
      self.constraintCenterY.constant += self.bufferForSlidingLoginViewPassword
      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    if textField == self.emailAddressTextField {
      self.constraintCenterY.constant -= self.bufferForSlidingLoginViewEmail
      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
    } else if textField == self.passwordTextField {
      self.constraintCenterY.constant -= self.bufferForSlidingLoginViewPassword
      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.usernameTextField.resignFirstResponder()
    if textField == self.usernameTextField {
      self.passwordTextField.becomeFirstResponder()
    } else if self.passwordTextField == textField {
      self.passwordTextField.resignFirstResponder()
      self.emailAddressTextField.becomeFirstResponder()
    } else {
      self.emailAddressTextField.resignFirstResponder()
    }
    return true
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if textField == usernameTextField {
      if string.validForUsername() {
        return true
      } else {
        return false
      }
    }
    return true
  }

}
