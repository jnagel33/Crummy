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
  
  let datePickerInterval : NSTimeInterval = 1.0
  let astheticSpacing : CGFloat = 8.0
  let datePickerHeight: CGFloat = 216.0
  let pickerViewHeight: CGFloat = 250
  let doneButtonHeight: CGFloat = 25
  let doneButtonWidth: CGFloat = 50
  let pickerWidth: CGFloat = 50
  let dateRow : Int = 1
  let crummyApiService = CrummyApiService()
  var pickerView : UIView!
  var datePicker : UIDatePicker!
  var guess: Int = 0
  let pickerCellIndexPath = 4
  var kidImage: UIImage?
  var addKid = false
  let titleFontSize: CGFloat = 26
  let titleLabel = UILabel(frame: CGRectMake(0, 0, 80, 40))
  let titleColor = UIColor(red: 0.060, green: 0.158, blue: 0.408, alpha: 1.000)
  
  // person passed from the "list of people controller.
  var selectedKid : Kid?
  
    override func viewDidLoad() {
    super.viewDidLoad()
      
    self.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: self.titleFontSize)
    self.titleLabel.textAlignment = .Center
    self.titleLabel.textColor = self.titleColor
    if let name = selectedKid?.name {
      self.titleLabel.text = selectedKid!.name
    } else {
      self.titleLabel.text = "Edit"
      }
    self.navigationItem.titleView = self.titleLabel
      
    var cellNib = UINib(nibName: "ImagePickerCell", bundle: nil)
    tableView.registerNib(cellNib,
      forCellReuseIdentifier: "ImagePickerCell")
    
    if selectedKid == nil {
      selectedKid = Kid(theName: "", theDOB: "", theInsuranceID: "", theNursePhone: "", theKidID: "")
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
      
    // non gray out cells
//    if let tableView = self.view as? UITableView {
//      tableView.allowsSelection = false
//    }
    
    self.view.layoutIfNeeded()
  } // viewDidLoad
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    //println(self.notesTextView.text)
    selectedKid!.notes = notesTextView.text
    
    if addKid == true {
      self.crummyApiService.postNewKid(selectedKid!.name, dobString: selectedKid!.DOBString, insuranceID: selectedKid!.insuranceId, nursePhone: selectedKid!.nursePhone, notes: selectedKid!.notes!, completionHandler: { (status) -> Void in
        //println(self.selectedKid.notes)
        if status! == "201" {
          // launch a popup signifying data saved.
          self.addKid = false
        }
      })
    } else {
      self.crummyApiService.editKid(selectedKid!.kidID, name: selectedKid!.name, dobString: selectedKid!.DOBString, insuranceID: selectedKid!.insuranceId, nursePhone: selectedKid!.nursePhone, notes: selectedKid!.notes!, completionHandler: { (status) -> Void in
      })
    }
  } // viewWillDisappear
  
  // MARK: - Date Picker
  // func to set the date from the picker if no date is set.
  // https://github.com/ioscreator/ioscreator/blob/master/IOSSwiftDatePickerTutorial/IOSSwiftDatePickerTutorial/ViewController.swift
  func datePickerChanged(datePicker: UIDatePicker) {
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    let strDate = dateFormatter.stringFromDate(datePicker.date)
    selectedKid!.DOBString = strDate
    
    self.birthdateLabel.text = selectedKid!.DOBString
    birthdateLabel.textColor = UIColor.blackColor()
  } // datePickerChanged
  
  
  func pickerCloserPressed(sender: AnyObject) {

    self.datePickerChanged(datePicker)
    self.dateButton.hidden = false
    
    UIView.animateWithDuration(datePickerInterval, animations: { () -> Void in
      self.pickerView.frame.origin.y = self.view.frame.height + self.datePickerHeight
    })
    
  } // pickerCloserPressed
  
  
  // MARK: - Date Button
  @IBAction func datePressed(sender: AnyObject) {
    // if the button is pressed, it brings up the datePicker object.
    
    
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
    
  } // datePressed
  
  // MARK: - Text Fields
  
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
    }
  }
  
  
  //MARK:
  //MARK: UIImagePickerControllerDelegate
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
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
