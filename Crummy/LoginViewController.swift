//
//  LoginViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, CreateUserViewControllerDelegate {

  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var constraintContainerCenterY: NSLayoutConstraint!
  
  let crummyApiService = CrummyApiService()
  var bufferForSlidingLoginView: CGFloat = 70
  var animationDuration: Double = 0.2
  
  var tapGestureRecognizer: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.usernameTextField.delegate = self
    self.passwordTextField.delegate = self
    
    self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    self.view.addGestureRecognizer(self.tapGestureRecognizer!)
  }
  
  @IBAction func loginPressed(sender: UIButton) {
    let username = usernameTextField.text
    let password = passwordTextField.text
    
    self.crummyApiService.postLogin(username, password: password, completionHandler: { (status) -> (Void) in
      
      if status == "200" {
        self.performSegueWithIdentifier("ShowHomeMenu", sender: self)
      } else {
        println("Error logging in \(status)")
        // send error message to login screen here
      }
    })
  }
  
  func dismissKeyboard() {
    self.usernameTextField.resignFirstResponder()
    self.passwordTextField.resignFirstResponder()
  }
  
  //MARK:
  //MARK: UITextFieldDelegate
  
  func textFieldDidBeginEditing(textField: UITextField) {
    self.constraintContainerCenterY.constant += bufferForSlidingLoginView
    UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
        self.constraintContainerCenterY.constant -= self.bufferForSlidingLoginView
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
  
  
  func getUsernameFromRegister(username: String) {
    self.usernameTextField.text = username
  }
  
  //MARK:
  //MARK: prepareForSegue
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "Register" {
      let destinationController = segue.destinationViewController as! UINavigationController
    let createUser = destinationController.viewControllers[0] as! CreateUserViewController
      createUser.delegate = self
    }
  }
}
