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
  
  var kidList = [KidsList]()
  
  let kidNumberHeight: CGFloat = 50.0
  let doneButtonHeight: CGFloat = 25.0
  let astheticSpacing : CGFloat = 8.0
  let phoneInterval : NSTimeInterval = 1.0
  let crummyApiService = CrummyApiService()
  var phoneMenuContainer : UIView!
  var kids = [Kid(theName: "Josh", theDOB: "2014-10-10", theInsuranceID: "130831", theNursePhone: "8010380024"), Kid(theName: "Randy", theDOB: "2014-10-10", theInsuranceID: "244553", theNursePhone: "4200244244"), Kid(theName: "Ed", theDOB: "2014-10-10", theInsuranceID: "43988305", theNursePhone: "94835553"), Kid(theName: "Josh", theDOB: "2014-10-10", theInsuranceID: "130831", theNursePhone: "8010380024"), Kid(theName: "Randy", theDOB: "2014-10-10", theInsuranceID: "244553", theNursePhone: "4200244244"), Kid(theName: "Ed", theDOB: "2014-10-10", theInsuranceID: "43988305", theNursePhone: "94835553")]
  
  // Randy is working on this...
  
  let phonePopoverAC = UIAlertController(title: "PhoneList", message: "Select a number to dial.", preferredStyle: UIAlertControllerStyle.ActionSheet)
  // find the Nib in the bundle.
  let phoneNib = UINib(nibName: "PhoneCellContainerView", bundle: NSBundle.mainBundle())
  override func viewDidLoad() {
    
    self.crummyApiService.listKid { (kidList, error) -> (Void) in
      if error != nil {
        println("error getting kid list")
      } else {
        self.kidList = kidList!
        self.collectionView.reloadData()
      }
    }
    super.viewDidLoad()
    self.collectionView.dataSource = self
    
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return kidList.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCell", forIndexPath: indexPath) as! HomeCollectionViewCell
    cell.nameLabel.text = kidList[indexPath.row].name
    cell.kidImageView.layer.cornerRadius = cell.kidImageView.frame.height / 2
    cell.kidImageView.layer.masksToBounds = true
    if indexPath.row == 0 {
      cell.kidImageView.image = UIImage(named: "boy1")
    } else if indexPath.row == 1 {
      cell.kidImageView.image = UIImage(named: "culkin")
    } else if indexPath.row == 2 {
      cell.kidImageView.image = UIImage(named: "girl2")
    } else if indexPath.row == 3 {
      cell.kidImageView.image = UIImage(named: "girl")
    } else {
      cell.kidImageView.image = UIImage(named: "kid5")
    }
    
    return cell
  }
  
  //MARK:
  //MARK: prepareForSegue
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowEditMenu" {
      let destinationController = segue.destinationViewController as? EditMenuViewController
      destinationController?.kidList = self.kidList
    } else if segue.identifier == "ShowEvents" {
      let destinationController = segue.destinationViewController as? EventsViewController
      let indexPath = self.collectionView.indexPathsForSelectedItems().first as! NSIndexPath
      let kid = self.kidList[indexPath.row]
      destinationController?.kidId = "\(kid.id)"
      destinationController?.kidName = kid.name
    }
  }

  
  //MARK:
  //MARK: - popover VC.
  
  @IBAction func phoneButtonPressed(sender: AnyObject) {
    // adding table view properties for the phone table view popover.
    var kidCount = CGFloat(kids.count)
    let phoneMenuViewAndDoneHeight: CGFloat = ((kidCount * kidNumberHeight) + doneButtonHeight + astheticSpacing)
    // add the phone menu container
    phoneMenuContainer = UIView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: phoneMenuViewAndDoneHeight))
    phoneMenuContainer.backgroundColor = UIColor.lightGrayColor()
    self.view.addSubview(phoneMenuContainer)
    
    // adding the phone menu view
    let phoneMenuViewHeight: CGFloat =  CGFloat(kidCount * kidNumberHeight)
    var phoneMenuView = UITableView(frame: CGRect(x: 0, y: doneButtonHeight + astheticSpacing, width: phoneMenuContainer.frame.width, height: phoneMenuViewHeight))
    //phoneMenuView.backgroundColor = UIColor.lightGrayColor()
    phoneMenuView.registerNib(phoneNib, forCellReuseIdentifier: "phoneCell")
    phoneMenuContainer.addSubview(phoneMenuView)
    phoneMenuView.delegate = self
    phoneMenuView.dataSource = self
    
    let phoneCloser = UIButton(frame: CGRect(x: 0, y: astheticSpacing, width: phoneMenuContainer.frame.width, height: doneButtonHeight))
    phoneCloser.setTitle("Done", forState: UIControlState.Normal)
    phoneCloser.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    phoneCloser.center.x = self.view.center.x
    phoneCloser.addTarget(self, action: "phoneCloserPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    phoneMenuContainer.addSubview(phoneCloser)
    let phoneCellView = NSBundle.mainBundle().loadNibNamed("PhoneCellContainerView", owner: self, options: nil)
    UIView.animateWithDuration(phoneInterval, animations: { () -> Void in
      self.phoneMenuContainer.frame.origin.y = self.view.frame.height - phoneMenuViewAndDoneHeight
    })
  } // phoneButtonPressed
  
  func phoneCloserPressed(sender: AnyObject) {
    var kidCount = CGFloat(kids.count)
    let phoneMenuViewAndDoneHeight: CGFloat = ((self.view.frame.height) - (kidCount * kidNumberHeight) - doneButtonHeight)
    UIView.animateWithDuration(phoneInterval, animations: { () -> Void in
      self.phoneMenuContainer.frame.origin.y = self.view.frame.height + phoneMenuViewAndDoneHeight
    })
  } // phoneCloserPressed
  
  //MARK:
  //MARK: - TableView VC
  
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
    UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://\(kids[indexPath.row].nursePhone)")!)
  } // didSelectRowAtIndexPath
}