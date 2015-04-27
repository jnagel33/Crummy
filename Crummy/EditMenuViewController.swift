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
  
  var kiddo: Kid!
  var kidList: [KidsList]?
  let titleFontSize: CGFloat = 26
  let titleLabel = UILabel(frame: CGRectMake(0, 0, 80, 40))
  let titleColor = UIColor(red: 0.060, green: 0.158, blue: 0.408, alpha: 1.000)
  var indexPaths: [NSIndexPath]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.titleLabel.textAlignment = .Center
    self.titleLabel.textColor = self.titleColor
    self.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: self.titleFontSize)
    self.titleLabel.text = "Edit Menu"
    self.navigationItem.titleView = self.titleLabel
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let kidCount = self.kidList?.count {
      return kidCount
    }
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EditMenuCell", forIndexPath: indexPath) as! EditMenuTableViewCell
    cell.textLabel?.text = nil
    if let kids = self.kidList?[indexPath.row] {
      cell.textLabel!.text = kids.name
    }
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let selectedMunchkin = self.kidList?[indexPath.row]
    let id = selectedMunchkin?.id
    let idString = String(stringInterpolationSegment: id!)
    
    crummyApiService.getKid(idString, completionHandler: { (kiddos, error) -> (Void) in
      if error != nil {
        println("error getting kid")
      } else {
        self.kiddo = kiddos!
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("EditKidVC") as! EditKidViewController
        viewController.selectedKid = self.kiddo
        self.navigationController?.pushViewController(viewController, animated: false)
      }
    })
  }
  
  @IBAction func addButtonPressed(sender: AnyObject) {
    let destinationController = storyboard?.instantiateViewControllerWithIdentifier("EditKidVC") as? EditKidViewController
    destinationController?.selectedKid = nil
    
    performSegueWithIdentifier("ShowEditKidVC", sender: EditMenuViewController.self)
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
    let selectedMunchkin = self.kidList?[indexPath.row]
    let id = selectedMunchkin?.id
    let idString = String(stringInterpolationSegment: id!)
    let name = selectedMunchkin?.name
    self.indexPaths = [indexPath]
    
    let alertController = UIAlertController(title: "Alert", message: "Seriously! Delete your own child? Eviscerate poor \(name!)?", preferredStyle: .Alert)
    
    let defaultActionHandler = { (action: UIAlertAction!) -> Void in
      self.kidList?.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths(self.indexPaths!, withRowAnimation: .Automatic)
      println("Deleteing kid with ID: \(idString)")
      self.crummyApiService.deleteKid(idString, completionHandler: { (error) -> (Void) in
      })
    }
    let defaultAction = UIAlertAction(title: "Delete anyway you monster!", style: .Default, handler: defaultActionHandler)
    alertController.addAction(defaultAction)
    
    let cancelActionHandler = { (action:UIAlertAction!) -> Void in
      self.tableView.reloadRowsAtIndexPaths(self.indexPaths!, withRowAnimation: .Automatic)
      
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: cancelActionHandler)
    alertController.addAction(cancelAction)
    self.presentViewController(alertController, animated: true, completion: nil)
  }
}