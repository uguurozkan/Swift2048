//
//  NewGameViewController.swift
//  Swift2048
//
//  Created by Ugur Ozkan on 23/12/14.
//  Copyright (c) 2014 Ugur Ozkan. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController {
  
  var gameModel = GameModel(maxValue: 4)
  
  
  @IBAction func backButtonTapped(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func refreshUI() {
    for tile in tiles{
      let row = tile.tag / 4
      let col = tile.tag % 4
      let state = gameModel.board[row][col]
      switch state {
      case TileObject.Empty:
        tile.setTitle(" ", forState: .Normal)
      case TileObject.Tile(value: _, isMerged: _):
        tile.setTitle(state.getValue().description, forState: .Normal)
      }
    }
    
  }
  
  @IBOutlet var tiles: [UIButton]!
  

  @IBOutlet var swipeRightRecognizer: UISwipeGestureRecognizer!

  @IBOutlet var swipeLeftRecognizer: UISwipeGestureRecognizer!

  @IBOutlet var swipeDownRecognizer: UISwipeGestureRecognizer!
 
  @IBOutlet var swipeUpRecognizer: UISwipeGestureRecognizer!
  
  
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
  
}