//
//  CreateUserViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

protocol CreateUserViewControllerDelegate : class {
  func getUsernameFromRegister(username: String) -> Void
}

class CreateUserViewController: UIViewController, UITextFieldDelegate {

  
  @IBOutlet weak var constraintStatusViewCenterX: NSLayoutConstraint!
  @IBOutlet weak var statusView: UIView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var constraintCenterY: NSLayoutConstraint!
  
  let crummyApiService = CrummyApiService()
  var bufferForSlidingLoginViewEmail: CGFloat = 80
  var bufferForSlidingLoginViewPassword: CGFloat = 40
  var animationDuration: Double = 0.2
  let animationDurationLonger: Double = 0.5
  var tapGestureRecognizer: UITapGestureRecognizer?
  let titleColor = UIColor(red: 0.060, green: 0.158, blue: 0.408, alpha: 1.000)
  let titleLabel = UILabel(frame: CGRectMake(0, 0, 80, 40))
  let titleSize: CGFloat = 26
  var delegate: CreateUserViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.usernameTextField.delegate = self
    self.passwordTextField.delegate = self
    
    self.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: self.titleSize)
    self.titleLabel.textAlignment = .Center
    self.titleLabel.textColor = self.titleColor
    titleLabel.text = "Register"
    self.navigationItem.titleView = self.titleLabel
    
    let navBarImage = UIImage(named: "CrummyNavBar")
    self.navigationController!.navigationBar.setBackgroundImage(navBarImage, forBarMetrics: .Default)
    
    self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    self.view.addGestureRecognizer(self.tapGestureRecognizer!)
  }
  
  @IBAction func doneBarButton(sender: UIBarButtonItem) {
    let username = usernameTextField.text
    let password = passwordTextField.text
    
    self.crummyApiService.createNewUser(username, password: password, completionHandler: { (status, error) -> (Void) in
      
      if status != nil {
        self.statusView.backgroundColor = UIColor.greenColor()
        self.statusLabel.text = "Success"
        self.constraintStatusViewCenterX.constant = 0
        UIView.animateWithDuration(self.animationDurationLonger, animations: { () -> Void in
          self.view.layoutIfNeeded()
        }, completion: { (finshed) -> Void in
          self.delegate?.getUsernameFromRegister(self.usernameTextField.text)
          self.dismissViewControllerAnimated(true, completion: nil)
        })
      } else {
        self.statusView.backgroundColor = UIColor.redColor()
        self.statusLabel.text = "Error creating user"
        self.constraintStatusViewCenterX.constant = 0
        UIView.animateWithDuration(self.animationDurationLonger, animations: { () -> Void in
          self.view.layoutIfNeeded()
        })
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