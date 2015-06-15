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
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  let kidNumberHeight: CGFloat = 100
  let doneButtonHeight: CGFloat = 30.0
  let astheticSpacing : CGFloat = 8.0
  let phoneInterval : NSTimeInterval = 0.4
  let crummyApiService = CrummyApiService()
  var phoneMenuContainer : UIView!
  let titleColor = UIColor(red: 0.060, green: 0.158, blue: 0.408, alpha: 1.000)
  let titleLabel = UILabel(frame: CGRectMake(0, 0, 80, 40))
  let titleSize: CGFloat = 26
  var kidCount: CGFloat = 0.0
  var kids = [Kid]()
  let blurViewTag = 99
  let animationDuration: Double = 0.3
  
  let phonePopoverAC = UIAlertController(title: "PhoneList", message: "Select a number to dial.", preferredStyle: UIAlertControllerStyle.ActionSheet)
  // find the Nib in the bundle.
  let phoneNib = UINib(nibName: "PhoneCellContainerView", bundle: NSBundle.mainBundle())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    
    self.navigationItem.hidesBackButton = true
    self.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: self.titleSize)
    self.titleLabel.textAlignment = .Center
    self.titleLabel.textColor = self.titleColor
    titleLabel.text = "Home"
    self.navigationItem.titleView = self.titleLabel
    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    self.navigationItem.backBarButtonItem = backButton
    
    let navBarImage = UIImage(named: "CrummyNavBar")
    self.navigationController!.navigationBar.setBackgroundImage(navBarImage, forBarMetrics: .Default)
    
    var buttonBar = UIColor(patternImage: UIImage(named: "ContainerViewBar")!)
    self.buttonContainerView.backgroundColor = buttonBar
    
    self.activityIndicator.startAnimating()
    self.crummyApiService.listKid { (kidList, error) -> (Void) in
      if let errorDescription = error {
        let alertController = UIAlertController(title: "An Error Occurred", message: errorDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
          self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
      } else {
        self.kids = kidList!
        self.collectionView.reloadData()
        self.activityIndicator.stopAnimating()
      }
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "appWillResign", name: UIApplicationWillResignActiveNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "appBecameActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func appWillResign() {
    if self.phoneMenuContainer != nil {
      let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
      var blurView = UIVisualEffectView(effect: blurEffect)
      blurView.tag = self.blurViewTag
      blurView.frame = self.view.frame
      self.phoneMenuContainer.addSubview(blurView)
    }
  }
  
  func appBecameActive() {
    if self.phoneMenuContainer != nil {
      let blurView = self.phoneMenuContainer.viewWithTag(self.blurViewTag)
      UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
        blurView?.removeFromSuperview()
      })
    }
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
    let kid = self.kids[indexPath.row]
    let image = self.loadImage(kid)
    if let kidImage = image {
      cell.kidImageView.image = self.loadImage(kid)
    } else {
      cell.kidImageView.image = UIImage(named: "PersonPlaceholderImage")
    }
    
    return cell
  }
  
  //MARK:
  //MARK: Load Image
  
  func loadImage(kid: Kid) -> UIImage? {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentsDirectoryPath = paths[0] as! String
    let filePath = documentsDirectoryPath.stringByAppendingPathComponent("appData")
    if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
      let savedData = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as! [String: AnyObject]
      let customImageLocation = "kid_photo_\(kid.kidID)"
      if let imageData = savedData[customImageLocation] as? NSData {
        return UIImage(data: imageData)
      }
    }
    return nil
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
      if let errorDescription = error {
        let alertController = UIAlertController(title: "An Error Occurred", message: errorDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
          self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
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
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if let nursePhone = self.kids[indexPath.row].nursePhone {
      UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://\(nursePhone)")!)
    }
  } // didSelectRowAtIndexPath
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100
  }
}