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
    }
    
    gameModel.refresh()
    updateTileTitles()
    movesLabel.text = gameModel.replayQueueMoves.count.description
    scoreLabel.text = gameModel.getScore().description
  }
  
  func updateTileTitles() {
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
      refreshUI()
  }

  @IBAction func swipedLeft(sender: AnyObject) {
      gameModel.move(Direction.Left)
      refreshUI()
  }

  @IBAction func swipedDown(sender: AnyObject) {
      gameModel.move(Direction.Down)
      refreshUI()
  }
  
  @IBAction func swipedUp(sender: AnyObject) {
      gameModel.move(Direction.Up)
      refreshUI()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let replayVC = segue.destinationViewController as ReplayViewController
    replayVC.replayQueueMoves = gameModel.replayQueueMoves
    replayVC.replayQueueRandoms = gameModel.replayQueueRandoms
  }
  
  override func viewDidLoad() {
    refreshUI()
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}