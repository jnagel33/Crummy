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
  @IBOutlet weak var constraintStatusViewCenterX: NSLayoutConstraint!
  
  @IBOutlet weak var activityWheel: UILabel!
  
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var statusView: UIView!
  let crummyApiService = CrummyApiService()
  var bufferForSlidingLoginView: CGFloat = 70
  var animationDuration: Double = 0.2
  let animationDurationLonger: Double = 0.5
  
  var tapGestureRecognizer: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.usernameTextField.delegate = self
    self.passwordTextField.delegate = self
    self.activityWheel.hidden = true
    
    self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    self.view.addGestureRecognizer(self.tapGestureRecognizer!)
  }
  
  @IBAction func loginPressed(sender: UIButton) {
    self.activityWheel.hidden = false
    let username = usernameTextField.text
    let password = passwordTextField.text
    self.crummyApiService.postLogin(username!, password: password!, completionHandler: { (status, error) -> (Void) in
      
      if status != nil {
          self.activityWheel.hidden = true
          self.statusView.backgroundColor = UIColor.greenColor()
          self.statusLabel.text = "Success"
          self.constraintStatusViewCenterX.constant = 0
          UIView.animateWithDuration(self.animationDurationLonger, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: { (finshed) -> Void in
              self.performSegueWithIdentifier("ShowHomeMenu", sender: self)
          })
      } else {
        self.activityWheel.hidden = true
        self.statusView.backgroundColor = UIColor.redColor()
        self.statusLabel.text = "Error creating user"
        self.constraintStatusViewCenterX.constant = 0
        UIView.animateWithDuration(self.animationDurationLonger, animations: { () -> Void in
          self.view.layoutIfNeeded()
        })
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
      self.constraintStatusViewCenterX.constant = 600
      UIView.animateWithDuration(self.animationDurationLonger, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
      let destinationController = segue.destinationViewController as! UINavigationController
    let createUser = destinationController.viewControllers[0] as! CreateUserViewController
      createUser.delegate = self
    }
  }
}
