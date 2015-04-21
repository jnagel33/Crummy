//
//  EditKidViewController.swift
//  Crummy
//
//  Created by Randy McLain on 4/21/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class EditKidViewController: UITableViewController {
  
  
  // parameters
  
  @IBOutlet weak var notesTextView: UITextView!
  @IBOutlet weak var consultingNurseHotline: UITextField!
  @IBOutlet weak var insuranceTextField: UITextField!
  @IBOutlet weak var dobTableCell: UITableViewCell!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var birthdateLabel: UILabel!
  
  var datePickerInterval : NSTimeInterval = 1.0
  let datePickerVisualHeight: CGFloat = 216.0
  let dateRow : Int = 1
  var pickerView : UIView!
  var datePicker : UIDatePicker!
  var guess: Int = 0
  
  var date = NSDate()
  
  
  // person passed from the "list of people controller.
  var selectedKid : Kid!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // self.title = selectedKid.name
    
    self.view.layoutIfNeeded()
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }
  
  //MARK: - DatePicker
  // func to set the date from the picker if no date is set.
  // https://github.com/ioscreator/ioscreator/blob/master/IOSSwiftDatePickerTutorial/IOSSwiftDatePickerTutorial/ViewController.swift
  func datePickerChanged(datePicker: UIDatePicker) {
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    var strDate = dateFormatter.stringFromDate(datePicker.date)
    selectedKid.DOBString = strDate
    
    self.birthdateLabel.text = selectedKid.DOBString
    birthdateLabel.textColor = UIColor.blackColor()
    println(selectedKid.DOBString)
  } // datePickerChanged
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func datePressed(sender: AnyObject) {
    // if the button is pressed, it brings up the datePicker object.
    
    pickerView = UIView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 250))
    pickerView.backgroundColor = UIColor.lightGrayColor()
    self.view.addSubview(pickerView)
    
    datePicker = UIDatePicker(frame: CGRect(x: 0, y: 25, width: pickerView.frame.width, height: 216))
    datePicker.datePickerMode = UIDatePickerMode.Date
    datePicker.backgroundColor = UIColor.lightGrayColor()

    // its off screen.
    pickerView.addSubview(datePicker)
    
    let pickerCloser = UIButton(frame: CGRect(x: 0, y: 8, width: 50, height: 25))
    pickerCloser.setTitle("Done", forState: UIControlState.Normal)
    pickerCloser.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    pickerCloser.center.x = self.view.center.x
    
    pickerView.addSubview(pickerCloser)
    pickerCloser.addTarget(self, action: "pickerCloserPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    
    UIView.animateWithDuration(datePickerInterval, animations: { () -> Void in
      
    self.pickerView.frame.origin.y = self.view.frame.height - self.datePickerVisualHeight

    })
    
  } // datePressed
  
  func pickerCloserPressed(sender: AnyObject) {
    
    
    UIView.animateWithDuration(datePickerInterval, animations: { () -> Void in
      self.pickerView.frame.origin.y = self.view.frame.height + self.datePickerVisualHeight
    })
    guess++
    println(guess)
    self.datePickerChanged(datePicker)
  }
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    if indexPath.row == dateRow {
      // reveal the datePicker object.
    }
    
  }
  
  // MARK: - TableCell
  //
  //  func textFieldDidBeginEditing(textField: UITextField!) {
  //    hideDatePicker()
  //
  //  }
  
  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return NO if you do not want the specified item to be editable.
  return true
  }
  */
  
  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  if editingStyle == .Delete {
  // Delete the row from the data source
  tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
  } else if editingStyle == .Insert {
  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }
  }
  */
  
  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
  
  }
  */
  
  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return NO if you do not want the item to be re-orderable.
  return true
  }
  */
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using [segue destinationViewController].
  
  // Pass the kid object to the new view controller.
  
  }
  */
  
}
