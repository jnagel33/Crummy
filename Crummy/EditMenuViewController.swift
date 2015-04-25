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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
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
    
    kidList?.removeAtIndex(indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    
     println("Deleteing kid with ID: \(idString)")
    
    crummyApiService.deleteKid(idString, completionHandler: { (error) -> (Void) in
     
      
      

      
    })
  }
}