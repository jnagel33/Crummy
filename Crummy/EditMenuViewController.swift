//
//  EditMenuViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//
import UIKit

class EditMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  let crummyApiService = CrummyApiService()
  
  var kid: [Kid]!

  override func viewDidLoad() {
    super.viewDidLoad()
    
   self.tableView.delegate = self
    self.tableView.dataSource = self
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let kidCount = self.kid?.count {
      return kidCount
      }
    return 0
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EditMenuCell", forIndexPath: indexPath) as! EditMenuTableViewCell
       cell.textLabel?.text = nil
    if let kids = self.kid?[indexPath.row] {
      cell.textLabel!.text = kids.name
    }
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let destinationController = self.storyboard!.instantiateViewControllerWithIdentifier("EditKidVC") as? EditKidViewController
    let indexPath = self.tableView.indexPathForSelectedRow()
    let selectedKid = self.kid[indexPath!.row]
    destinationController?.selectedKid = selectedKid
    performSegueWithIdentifier("ShowEditKidVC", sender: EditMenuViewController.self)
  }
  
  @IBAction func addButtonPressed(sender: AnyObject) {
    let destinationController = storyboard?.instantiateViewControllerWithIdentifier("EditKidVC") as? EditKidViewController
     destinationController?.selectedKid = nil
    
    performSegueWithIdentifier("ShowEditKidVC", sender: EditMenuViewController.self)
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
    kid.removeAtIndex(indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }
}
