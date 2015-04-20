//
//  EditPersonViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class EditPersonViewController: UIViewController {
  
  // properties 

  @IBOutlet weak var personNameField: UITextField!
  
  @IBOutlet weak var personDOBField: UITextField!
  
  @IBOutlet weak var personInsuranceField: UITextField!
  
  @IBOutlet weak var personNursePhoneField: UITextField!
  
  @IBOutlet weak var personInfoBox: UITextView!
  
  @IBOutlet weak var doneButton: UIButton!
  
  // person passed from the "list of people controller.  
  var selectedPerson : Person!
  
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
    self.title = "This Person"
    // hide the done button.
    doneButton.hidden = true
    

        // Do any additional setup after loading the view.
    } // viewDidLoad
  
  @IBAction func datePressed(sender: AnyObject) {
    
  } // datePressed
  

  // button to remove the UIPicker from view and apply date to person object

  @IBAction func donePressed(sender: AnyObject) {
    
  } // donePressed

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
