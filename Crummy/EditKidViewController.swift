//
//  EditKidViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class EditKidViewController: UIViewController {
  
  // properties
  
  @IBOutlet weak var kidNameField: UITextField!
  
  @IBOutlet weak var kidInsuranceField: UITextField!
  
  @IBOutlet weak var kidNursePhoneField: UITextField!
  
  @IBOutlet weak var kidInfoBox: UITextView!

  @IBOutlet weak var kidDobField: UITextField!
  
  var date = NSDate()

  
  // person passed from the "list of people controller.
  var selectedKid : Kid!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = selectedKid.name

  } // viewDidLoad
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
