//
//  NewGameViewController.swift
//  Swift2048
//
//  Created by Ugur Ozkan on 23/12/14.
//  Copyright (c) 2014 Ugur Ozkan. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController {
  
  var gameModel = GameModel(maxValue: 2048, isReplay: false)
  var scores: [Int]!
  
  func refreshUI() {
    if !gameModel.isBoardFull() {
      gameModel.addRandomTile()
    }
    
    if gameModel.getGameState() != GameState.InProgress {
      swipeRightRecognizer.enabled = false
      swipeLeftRecognizer.enabled = false
      swipeDownRecognizer.enabled = false
      swipeUpRecognizer.enabled = false
      showPopUp()
      saveScore()
    }
    
    gameModel.refresh()
    updateTiles()
    
    movesLabel.text = gameModel.replayQueueMoves.count.description
    scoreLabel.text = gameModel.getScore().description
  }
  
  func updateTiles() {
    for tile in tiles {
      let row = tile.tag / gameModel.dimension
      let col = tile.tag % gameModel.dimension
      let state = gameModel.board[row][col]
      
      switch state {
      case TileObject.Empty:
        tile.setTitle(" ", forState: .Normal)
      case TileObject.Tile(value: _, isMerged: _):
        tile.setTitle(state.getValue().description, forState: .Normal)
      }
      tile.backgroundColor = getTileBackgroundColour(state.getValue())
      tile.setTitleColor(getTileForegroundColour(state.getValue()), forState: .Normal)
    }
  }
  
  func getTileBackgroundColour(value: Int) -> UIColor{
    switch (value) {
    case 0: return UIColor.lightGrayColor()
    case 2: return UIColor(red: 0xEE/255, green: 0xE4/255, blue: 0xDA/255, alpha: 1.0)
    case 4: return UIColor(red: 0xED/255, green: 0xE0/255, blue: 0xC8/255, alpha: 1.0)
    case 8: return UIColor(red: 0xF2/255, green: 0xB1/255, blue: 0x79/255, alpha: 1.0)
    case 16: return UIColor(red: 0xF5/255, green: 0x95/255, blue: 0x63/255, alpha: 1.0)
    case 32: return UIColor(red: 0xF6/255, green: 0x7C/255, blue: 0x5F/255, alpha: 1.0)
    case 64: return UIColor(red: 0xF6/255, green: 0x5E/255, blue: 0x3B/255, alpha: 1.0)
    case 128: return UIColor(red: 0xED/255, green: 0xCF/255, blue: 0x72/255, alpha: 1.0)
    case 256: return UIColor(red: 0xED/255, green: 0xCC/255, blue: 0x61/255, alpha: 1.0)
    case 512: return UIColor(red: 0xED/255, green: 0xC8/255, blue: 0x50/255, alpha: 1.0)
    case 1024: return UIColor(red: 0xED/255, green: 0xC5/255, blue: 0x3F/255, alpha: 1.0)
    case 2048: return UIColor(red: 0xED/255, green: 0xC2/255, blue: 0x2E/255, alpha: 1.0)
    default: return UIColor.redColor()
    }
  }
  
  func getTileForegroundColour(value: Int) -> UIColor {
    switch (value) {
    case 0, 2, 4: return UIColor.blackColor()
    default: return UIColor.whiteColor()
    }
  }
  
  func showPopUp() {
    var message = ""
    if gameModel.getGameState() == GameState.UserHasWon {
      message = "You Won"
    } else {
      message = "You Lost"
    }
    let alert = UIAlertView(title: "Game Over", message: message, delegate: nil, cancelButtonTitle: "OK")
    alert.show()
  }
  
  func saveScore() {
    scores.append(gameModel.getScore())
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setObject(scores, forKey: "scores")    
  }
  
  var count = 0
  func updateTime() {
    count++
    timeLabel.text = String(count)
  }
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var movesLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  
  @IBOutlet var tiles: [UIButton]!
  
  @IBOutlet var swipeRightRecognizer: UISwipeGestureRecognizer!
  @IBOutlet var swipeLeftRecognizer: UISwipeGestureRecognizer!
  @IBOutlet var swipeDownRecognizer: UISwipeGestureRecognizer!
  @IBOutlet var swipeUpRecognizer: UISwipeGestureRecognizer!
  
  @IBAction func backButtonTapped(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
    self.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func swipedRight(sender: AnyObject) {
    gameModel.move(Direction.Right)
    if gameModel.hasMovement() {
      refreshUI()
    }
  }

  @IBAction func swipedLeft(sender: AnyObject) {
    gameModel.move(Direction.Left)
    if gameModel.hasMovement() {
      refreshUI()
    }
  }

  @IBAction func swipedDown(sender: AnyObject) {
    gameModel.move(Direction.Down)
    if gameModel.hasMovement() {
      refreshUI()
    }
  }
  
  @IBAction func swipedUp(sender: AnyObject) {
    gameModel.move(Direction.Up)
    if gameModel.hasMovement() {
      refreshUI()
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let replayVC = segue.destinationViewController as ReplayViewController
    replayVC.replayQueueMoves = gameModel.replayQueueMoves
    replayVC.replayQueueRandoms = gameModel.replayQueueRandoms
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    refreshUI()
    var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
    
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