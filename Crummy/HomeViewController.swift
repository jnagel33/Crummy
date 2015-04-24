//
//  HomeViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  
  let kidNumberHeight: CGFloat = 50.0
  let crummyApiService = CrummyApiService()
  var kids = [Kid(theName: "Josh", theDOB: "2014-10-10", theInsuranceID: "130831", theNursePhone: "8010380024"), Kid(theName: "Randy", theDOB: "2014-10-10", theInsuranceID: "244553", theNursePhone: "4200244244"), Kid(theName: "Ed", theDOB: "2014-10-10", theInsuranceID: "43988305", theNursePhone: "94835553"), Kid(theName: "Josh", theDOB: "2014-10-10", theInsuranceID: "130831", theNursePhone: "8010380024"), Kid(theName: "Randy", theDOB: "2014-10-10", theInsuranceID: "244553", theNursePhone: "4200244244"), Kid(theName: "Ed", theDOB: "2014-10-10", theInsuranceID: "43988305", theNursePhone: "94835553")]
  
  // Randy is working on this...
  let phonePopoverAC = UIAlertController(title: "PhoneList", message: "Select a number to dial.", preferredStyle: UIAlertControllerStyle.ActionSheet)
  // find the Nib in the bundle.
  let phoneNib = UINib(nibName: "PhoneTableViewCell", bundle: NSBundle.mainBundle())
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.dataSource = self
    
    
    //    self.phoneMenuView.delegate = self
    //    self.phoneMenuView.dataSource = self
  }
  
  //MARK:
  //MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return kids.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCell", forIndexPath: indexPath) as! HomeCollectionViewCell
    cell.nameLabel.text = kids[indexPath.row].name
    cell.kidImageView.image = UIImage(named: "PersonPlaceholderImage")
    
    return cell
  }
  
  //MARK:
  //MARK: prepareForSegue
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowEditMenu" {
      let destinationController = segue.destinationViewController as? EditMenuViewController
      destinationController?.kid = self.kids
    } else if segue.identifier == "ShowEvents" {
      let destinationController = segue.destinationViewController as? EventsViewController
      let indexPath = self.collectionView.indexPathsForSelectedItems().first as! NSIndexPath
      destinationController?.kid = kids[indexPath.row]
    }
  }
  
  //MARK:
  //MARK: - popover VC.
  
  // Randy is working on this..
  
  @IBAction func phoneButtonPressed(sender: AnyObject) {
    // adding table view properties for the phone table view popover.
    
    var kidCount = CGFloat(kids.count)
    
    println("button pressed")
    var phoneMenuView : UITableView!
    let phoneMenuViewHeight: CGFloat =  CGFloat(self.view.frame.height) - (kidCount * kidNumberHeight)
    phoneMenuView = UITableView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: -phoneMenuViewHeight))
    phoneMenuView.registerNib(phoneNib, forCellReuseIdentifier: "phoneCell")
    
    UIView.animateWithDuration(1.4, animations: { () -> Void in
      self.view.addSubview(phoneMenuView)
    })
  } // phoneButtonPressed
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("phoneCell", forIndexPath: indexPath) as! PhoneTableViewCell
    
    cell.Name.text = kids[indexPath.row].name
    cell.InsuranceID.text = kids[indexPath.row].insuranceId
    cell.Phone.text = kids[indexPath.row].nursePhone
    
    return cell
  } // cellForRowAtIndexPath
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return kids.count
  } // numberOfRowsInSection
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    UIApplication.sharedApplication().openURL(NSURL(fileURLWithPath: "tel://\(kids[indexPath.row].nursePhone)")!)
  } // didSelectRowAtIndexPath
}
