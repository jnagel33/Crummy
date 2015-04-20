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
  
  var person: [Person]!

  override func viewDidLoad() {
    super.viewDidLoad()
    
   self.tableView.delegate = self
    self.tableView.dataSource = self
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let personCount = self.person?.count {
      return personCount
      }
    return 0
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EditMenuCell", forIndexPath: indexPath) as! EditMenuTableViewCell
       cell.textLabel?.text = nil
    if let persons = self.person?[indexPath.row] {
      cell.textLabel!.text = persons.name
    }
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("EditPersonVC") as? EditPersonViewController
    let selectedPerson = self.person[indexPath.row]
    viewController?.selectedPerson.name
    viewController?.selectedPerson.DOB
    
    self.navigationController?.pushViewController(viewController!, animated: true)
  }
}
