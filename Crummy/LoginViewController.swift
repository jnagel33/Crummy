//
//  LoginViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var constraintCenterY: NSLayoutConstraint!
  
  var bufferForSlidingLoginView: CGFloat = 50
  var animationDuration: Double = 0.2
  
  var tapGestureRecognizer: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.usernameTextField.becomeFirstResponder()
    self.usernameTextField.delegate = self
    self.passwordTextField.delegate = self
    
    tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    self.view.addGestureRecognizer(self.tapGestureRecognizer!)
  }
  
  @IBAction func loginPressed(sender: UIButton) {
    println(usernameTextField.text)
    println(passwordTextField.text)
    self.performSegueWithIdentifier("ShowHomeScreen", sender: self)
  }
  
  func dismissKeyboard() {
    self.usernameTextField.resignFirstResponder()
    self.passwordTextField.resignFirstResponder()
  }
  
  //MARK:
  //MARK: UITextFieldDelegate
  
  func textFieldDidBeginEditing(textField: UITextField) {
    self.constraintCenterY.constant += self.bufferForSlidingLoginView
    UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    self.constraintCenterY.constant -= self.bufferForSlidingLoginView
    UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.usernameTextField.resignFirstResponder()
    if textField == usernameTextField {
      self.passwordTextField.becomeFirstResponder()
    } else {
      self.passwordTextField.resignFirstResponder()
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
