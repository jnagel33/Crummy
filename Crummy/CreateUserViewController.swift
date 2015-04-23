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

  @IBOutlet weak var constraintCenterY: NSLayoutConstraint!
  
  let crummyApiService = CrummyApiService()
  var bufferForSlidingLoginViewEmail: CGFloat = 80
  var bufferForSlidingLoginViewPassword: CGFloat = 40
  var animationDuration: Double = 0.2
  var tapGestureRecognizer: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.usernameTextField.delegate = self
    self.passwordTextField.delegate = self
    
    self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    self.view.addGestureRecognizer(self.tapGestureRecognizer!)
  }
  
  @IBAction func doneBarButton(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
    let username = usernameTextField.text
    let password = passwordTextField.text
    
    self.crummyApiService.createNewUser(username, password: password, completionHandler: { (status) -> (Void) in
      
      if status == "200" {
        self.performSegueWithIdentifier("ShowHomeMenu", sender: self)
      } else {
        println("Error creating user \(status)")
        // send error message to login screen here
      }
    })
  }

  @IBAction func cancelPressed(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func dismissKeyboard() {
    self.usernameTextField.resignFirstResponder()
    self.passwordTextField.resignFirstResponder()
  }
  
  //MARK:
  //MARK: UITextFieldDelegate
  
  func textFieldDidBeginEditing(textField: UITextField) {
    if textField == self.passwordTextField {
      self.constraintCenterY.constant += self.bufferForSlidingLoginViewPassword
      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    if textField == self.passwordTextField {
      self.constraintCenterY.constant -= self.bufferForSlidingLoginViewPassword
      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.usernameTextField.resignFirstResponder()
    if textField == self.usernameTextField{
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