//
//  EditKidViewController.swift
//  Crummy
//
//  Created by Randy McLain on 4/21/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit


class EditKidViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // parameters
  
  @IBOutlet weak var notesTextView: UITextView!
  @IBOutlet weak var consultingNurseHotline: UITextField!
  @IBOutlet weak var insuranceTextField: UITextField!
  @IBOutlet weak var dobTableCell: UITableViewCell!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var birthdateLabel: UILabel!
  @IBOutlet weak var dateButton: UIButton!
  
  let animationDuration: Double = 0.3
  let datePickerInterval: NSTimeInterval = 1.0
  let astheticSpacing: CGFloat = 8.0
  let datePickerHeight: CGFloat = 216.0
  let pickerViewHeight: CGFloat = 250
  let doneButtonHeight: CGFloat = 25
  let doneButtonWidth: CGFloat = 50
  let pickerWidth: CGFloat = 50
  let crummyApiService = CrummyApiService()
  var pickerIsUp: Bool = false
  var pickerView: UIView!
  var datePicker: UIDatePicker!
  var guess: Int = 0
  let pickerCellIndexPath = 4
  let dateCellIndexPath = 1
  var kidImage: UIImage?
  var addKid = false
  let titleFontSize: CGFloat = 26
  let titleLabel = UILabel(frame: CGRectMake(0, 0, 80, 40))
  let titleColor = UIColor(red: 0.060, green: 0.158, blue: 0.408, alpha: 1.000)
  let blurViewTag = 99
  
  // person passed from the "list of people controller.
  var selectedKid : Kid?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: self.titleFontSize)
    self.titleLabel.textAlignment = .Center
    self.titleLabel.textColor = self.titleColor
    if let name = selectedKid?.name {
      self.titleLabel.text = "Edit"
    } else {
      self.titleLabel.text = "Add"
    }
    self.navigationItem.titleView = self.titleLabel
    
    var cellNib = UINib(nibName: "ImagePickerCell", bundle: nil)
    tableView.registerNib(cellNib,
      forCellReuseIdentifier: "ImagePickerCell")
    
    if selectedKid == nil {
      selectedKid = Kid(theName: "", theDOB: "", theInsuranceID: "", theNursePhone: "", theNotes: "", theKidID: "")
      addKid = true
    }
    
    // setup tags
    // assign the text fields tags.
    self.nameTextField.tag = 0
    self.insuranceTextField.tag = 2
    self.consultingNurseHotline.tag = 3
    self.notesTextView.tag = 4
    
    // delegates
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.notesTextView.delegate = self
    self.consultingNurseHotline.delegate = self
    self.insuranceTextField.delegate = self
    self.nameTextField.delegate = self
    
    // setup fields
    self.nameTextField.text = selectedKid!.name
    self.birthdateLabel.text = selectedKid!.DOBString
    self.insuranceTextField.text = selectedKid!.insuranceId
    self.consultingNurseHotline.text = selectedKid!.nursePhone
    
    if selectedKid!.notes != "" {
      self.notesTextView.text = selectedKid!.notes
    }
    
    self.view.layoutIfNeeded()
    
  } // viewDidLoad
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "appWillResign", name: UIApplicationWillResignActiveNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "appBecameActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  
  func appWillResign() {
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
    var blurView = UIVisualEffectView(effect: blurEffect)
    blurView.tag = self.blurViewTag
    blurView.frame = self.view.frame
    self.view.addSubview(blurView)
  }
  
  func appBecameActive() {
    let blurView = self.view.viewWithTag(self.blurViewTag)
    UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
      blurView?.removeFromSuperview()
    })
  }
  
  // MARK: - Date Picker
  // func to set the date from the picker if no date is set.
  // https://github.com/ioscreator/ioscreator/blob/master/IOSSwiftDatePickerTutorial/IOSSwiftDatePickerTutorial/ViewController.swift
  func datePickerChanged(datePicker: UIDatePicker) {
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let strDate = dateFormatter.stringFromDate(datePicker.date)
    selectedKid!.DOBString = strDate
    
    self.birthdateLabel.text = selectedKid!.DOBString
    birthdateLabel.textColor = UIColor.blackColor()
  } // datePickerChanged
  
  @IBAction func donePressed(sender: UIBarButtonItem) {
    selectedKid!.notes = self.notesTextView.text
    selectedKid!.name = self.nameTextField.text
    selectedKid!.nursePhone = self.consultingNurseHotline.text
    selectedKid!.insuranceId = self.insuranceTextField.text

    if addKid == true {
      self.crummyApiService.postNewKid(selectedKid!.name, dobString: selectedKid!.DOBString, insuranceID: selectedKid!.insuranceId, nursePhone: selectedKid!.nursePhone, notes: selectedKid!.notes!, completionHandler: { (status) -> Void in
        //println(self.selectedKid.notes)
        if status! == "201" || status! == "200" {
          // launch a popup signifying data saved.
          self.navigationController?.popViewControllerAnimated(true)
        }
      })
    } else {
      self.crummyApiService.editKid(selectedKid!.kidID, name: selectedKid!.name, dobString: selectedKid!.DOBString, insuranceID: selectedKid!.insuranceId, nursePhone: selectedKid!.nursePhone, notes: selectedKid!.notes!, completionHandler: { (status) -> Void in
        self.navigationController?.popViewControllerAnimated(true)
      })
    }
  }

  func pickerCloserPressed(sender: AnyObject) {
    
    self.datePickerChanged(datePicker)
    self.dateButton.hidden = false
    
    UIView.animateWithDuration(datePickerInterval, animations: { () -> Void in
      self.pickerView.frame.origin.y = self.view.frame.height + self.datePickerHeight
    })
    // window is down
    self.pickerIsUp = false
    
  } // pickerCloserPressed
  
  
  // MARK: - Date Button
  @IBAction func datePressed() {
    // if the button is pressed, it brings up the datePicker object.
    
    self.dismisKeyboard()
    self.pickerIsUp = true;
    self.dateButton.hidden = true
    
    pickerView = UIView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: pickerViewHeight))
    pickerView.backgroundColor = UIColor.lightGrayColor()
    self.view.addSubview(pickerView)
    
    datePicker = UIDatePicker(frame: CGRect(x: 0, y: doneButtonHeight, width: pickerView.frame.width, height: datePickerHeight))
    datePicker.datePickerMode = UIDatePickerMode.Date
    datePicker.backgroundColor = UIColor.lightGrayColor()
    
    // its off screen.
    pickerView.addSubview(datePicker)
    
    let pickerCloser = UIButton(frame: CGRect(x: 0, y: astheticSpacing, width: pickerWidth, height: doneButtonHeight))
    pickerCloser.setTitle("Done", forState: UIControlState.Normal)
    pickerCloser.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    pickerCloser.center.x = self.view.center.x
    
    pickerView.addSubview(pickerCloser)
    pickerCloser.addTarget(self, action: "pickerCloserPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    
    UIView.animateWithDuration(datePickerInterval, animations: { () -> Void in
      
      self.pickerView.frame.origin.y = self.view.frame.height - self.datePickerHeight
      
    })
    // window is up
    self.pickerIsUp = true
    
  } // datePressed
  
  // MARK: - Text Fields
  
  func textFieldDidBeginEditing(textField: UITextField) {
    // check to see if the picker visual is up, and if so move it down.
    if pickerIsUp == true {
      self.pickerCloserPressed(datePicker)
    }
  } // textFieldDidBeginEditing
  
  func textFieldDidEndEditing(textField: UITextField) {
    // if textfield == the outlet to an individual text field
    
    switch textField.tag {
    case 0:
      selectedKid!.name = textField.text
    case 2:
      selectedKid!.insuranceId = textField.text
    case 3:
      selectedKid!.nursePhone = textField.text
    case 4:
      selectedKid!.notes = self.notesTextView!.text
    default:
      println("no choice here!")
    } // switch
    selectedKid!.kidToString()
    textField.resignFirstResponder()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  // MARK: - Logic
  
  func getThisTextField (theRow : Int, theText : String) -> Void {
    //take in a string value and set the kid object located in that field to that value.  Pretty simple.
    
    var text : String = theText
    var row : Int = theRow
    
    switch row {
      
    case 0:
      selectedKid!.name = text
    case 1:
      return selectedKid!.DOBString = text
    case 2:
      return selectedKid!.insuranceId = text
    case 3:
      return selectedKid!.nursePhone = text
    case 4:
      return selectedKid!.notes = notesTextView.text
    default:
      println("out of range")
    }
    selectedKid!.kidToString()
    
    // println("got to end")
  } // getThisTextField
  
  func dismisKeyboard() {
    
    if (self.nameTextField.isFirstResponder()) {
      nameTextField.resignFirstResponder()
    } else if
      (self.insuranceTextField.isFirstResponder()) {
        insuranceTextField.resignFirstResponder()
    } else if
      (self.consultingNurseHotline.isFirstResponder()) {
        consultingNurseHotline.resignFirstResponder()
    } else if
      (self.notesTextView.isFirstResponder()) {
        notesTextView.resignFirstResponder()
    }
    
  } // dismisKeyboard
  //MARK:
  //MARK: UITableViewDataSource
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.row == self.pickerCellIndexPath {
      let cell = tableView.dequeueReusableCellWithIdentifier("ImagePickerCell", forIndexPath: indexPath) as! ImagePickerCell
      cell.kidImageView.image = self.kidImage
      return cell
    }
    return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
  }
  
  //MARK:
  //MARK: UITableViewDelegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if indexPath.row == self.pickerCellIndexPath {
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
        var imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerController.allowsEditing = true
        self.presentViewController(imagePickerController, animated: true, completion: nil)
      }
    } else if indexPath.row == self.dateCellIndexPath {
      if !pickerIsUp {
        self.datePressed()
      }
    }
  }
  
  //MARK:
  //MARK: UIImagePickerControllerDelegate
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
    if let photo = info[UIImagePickerControllerEditedImage] as? UIImage {
      self.kidImage = photo
    }
    tableView.reloadData()
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
}
