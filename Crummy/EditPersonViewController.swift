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
  
  // person passed from the "list of people controller.  
  var selectedPerson : Person!
  
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
    self.title = "This Person"
    
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
