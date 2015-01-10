//
//  HighScoresViewController.swift
//  Swift2048
//
//  Created by Ugur Ozkan on 23/12/14.
//  Copyright (c) 2014 Ugur Ozkan. All rights reserved.
//

import UIKit

class HighScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var scores: [Int]!

  func getTime() -> String{
    let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
    
    return timestamp
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return scores.count > 10 ? 10 : scores.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Score") as UITableViewCell
    
    cell.textLabel!.text = scores[indexPath.item].description
    cell.detailTextLabel!.text = getTime()
    
    return cell
  }
  
  @IBAction func backButtonTapped(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    if let defaultScores = userDefaults.arrayForKey("scores") {
      scores = (defaultScores as [Int])
      scores.sort { $1 < $0 }
    } else {
      scores = [Int]()
      userDefaults.setObject(scores, forKey: "scores")
    }

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}