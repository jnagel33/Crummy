//
//  HomeViewController.swift
//  Crummy
//
//  Created by Josh Nagel on 4/20/15.
//  Copyright (c) 2015 CF. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var buttonContainerView: UIView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  let kidNumberHeight: CGFloat = 50.0
  let doneButtonHeight: CGFloat = 25.0
  let astheticSpacing : CGFloat = 8.0
  let phoneInterval : NSTimeInterval = 1.0
  let crummyApiService = CrummyApiService()
  var phoneMenuContainer : UIView!
  let titleColor = UIColor(red: 0.060, green: 0.158, blue: 0.408, alpha: 1.000)
  let titleLabel = UILabel(frame: CGRectMake(0, 0, 80, 40))
  let titleSize: CGFloat = 26
  var kidCount: CGFloat = 0.0
  var kids = [Kid]()
  
  let phonePopoverAC = UIAlertController(title: "PhoneList", message: "Select a number to dial.", preferredStyle: UIAlertControllerStyle.ActionSheet)
  // find the Nib in the bundle.
  let phoneNib = UINib(nibName: "PhoneCellContainerView", bundle: NSBundle.mainBundle())
  
  override func viewDidLoad() {
    self.navigationItem.hidesBackButton = true
    self.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: self.titleSize)
    self.titleLabel.textAlignment = .Center
    self.titleLabel.textColor = self.titleColor
    titleLabel.text = "Home"
    self.navigationItem.titleView = self.titleLabel
    
    let navBarImage = UIImage(named: "CrummyNavBar")
    self.navigationController!.navigationBar.setBackgroundImage(navBarImage, forBarMetrics: .Default)
    
    var buttonBar = UIColor(patternImage: UIImage(named: "ContainerViewBar")!)
    self.buttonContainerView.backgroundColor = buttonBar
    
    self.crummyApiService.listKid { (kidList, error) -> (Void) in
      if error != nil {
        println("error getting kid list")
      } else {
        self.kids = kidList!
        self.collectionView.reloadData()
      }
    }
    super.viewDidLoad()
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
  }
  
  @IBAction func logoutPressed(sender: UIBarButtonItem) {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.removeObjectForKey("crummyToken")
    defaults.synchronize()
    let storyBoard = self.navigationController?.storyboard
    let login = storyboard?.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
    self.presentViewController(login, animated: true, completion: nil)
    
  }
  
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return kids.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCell", forIndexPath: indexPath) as! HomeCollectionViewCell
    cell.nameLabel.text = kids[indexPath.row].name
    cell.kidImageView.layer.cornerRadius = cell.kidImageView.frame.height / 2
    cell.kidImageView.layer.masksToBounds = true
    cell.kidImageView.layer.borderWidth = 8
    cell.kidImageView.layer.borderColor = UIColor(patternImage: UIImage(named: "ImageViewBorder")!).CGColor
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
      destinationController?.kidList = self.kids
    } else if segue.identifier == "ShowEvents" {
      let destinationController = segue.destinationViewController as? EventsViewController
      let indexPath = self.collectionView.indexPathsForSelectedItems().first as! NSIndexPath
      let kid = self.kids[indexPath.row]
      destinationController?.kidId = "\(kid.kidID)"
      destinationController?.kidName = kid.name
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    self.crummyApiService.listKid { (kidList, error) -> (Void) in
      if error != nil {
        println("error reloading kid list")
      } else {
        self.kids = kidList!
        self.collectionView.reloadData()
      }
    }
  }
    
  //MARK:
  //MARK: - popover VC.
  
  @IBAction func phoneButtonPressed(sender: AnyObject) {
    // adding table view properties for the phone table view popover.
    
    if kids.count == 0 {
      kidCount = 0
    } else {
      kidCount = CGFloat(kids.count)
    }
    
    

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
    
    ///// NEds to be kidslist.
    if let thephone = kids[indexPath.row].nursePhone {
      cell.Phone.text = thephone
    } else {
      cell.Phone.text = "no phone number"
    }
    
    
    return cell
  } // cellForRowAtIndexPath
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return kids.count
  } // numberOfRowsInSection
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://\(kids[indexPath.row].nursePhone)")!)
  } // didSelectRowAtIndexPath
}