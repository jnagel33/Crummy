//
//  HomeViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource {

  @IBOutlet weak var collectionView: UICollectionView!
  
  var kids = [Kid(theName: "Josh", theDOB: "2014-10-10", theInsuranceID: "130831", theNursePhone: "8010380024"), Kid(theName: "Randy", theDOB: "2014-10-10", theInsuranceID: "244553", theNursePhone: "4200244244"), Kid(theName: "Ed", theDOB: "2014-10-10", theInsuranceID: "43988305", theNursePhone: "94835553"), Kid(theName: "Josh", theDOB: "2014-10-10", theInsuranceID: "130831", theNursePhone: "8010380024"), Kid(theName: "Randy", theDOB: "2014-10-10", theInsuranceID: "244553", theNursePhone: "4200244244"), Kid(theName: "Ed", theDOB: "2014-10-10", theInsuranceID: "43988305", theNursePhone: "94835553")]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.dataSource = self
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
}
