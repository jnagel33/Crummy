//
//  HomeViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource {
  
  let crummyApiService = CrummyApiService()
  
  @IBOutlet weak var collectionView: UICollectionView!
  
//   var kids = [Kid(theName: "Josh", theDOB: "2014-10-10", theInsuranceID: "130831", theNursePhone: "8010380024"), Kid(theName: "Randy", theDOB: "2014-10-10", theInsuranceID: "244553", theNursePhone: "4200244244"), Kid(theName: "Ed", theDOB: "2014-10-10", theInsuranceID: "43988305", theNursePhone: "94835553"), Kid(theName: "Josh", theDOB: "2014-10-10", theInsuranceID: "130831", theNursePhone: "8010380024"), Kid(theName: "Randy", theDOB: "2014-10-10", theInsuranceID: "244553", theNursePhone: "4200244244"), Kid(theName: "Ed", theDOB: "2014-10-10", theInsuranceID: "43988305", theNursePhone: "94835553")]
  var kidList = [KidsList]()
  
  // Randy is working on this...
  
  let phonePopoverAC = UIAlertController(title: "PhoneList", message: "Select a number to dial.", preferredStyle: UIAlertControllerStyle.ActionSheet)
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
  
  //MARK:
  //MARK: UICollectionViewDataSource
  
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
  
  // Randy is working on this..
  
  @IBAction func phoneButtonPressed(sender: AnyObject) {
  }
  
  
  
}