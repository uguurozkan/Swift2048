//
//  ReplayViewController.swift
//  Swift2048
//
//  Created by Ugur Ozkan on 09/01/15.
//  Copyright (c) 2015 Ugur Ozkan. All rights reserved.
//

import UIKit

class ReplayViewController: UIViewController {
  
  var gameModel = GameModel(maxValue: 2048, isReplay: true)
  var replayQueueMoves = [Direction]()
  var replayQueueRandoms = [(Int, Int, TileObject)]()
  var step = 0
  
  func addMove(step: Int) {
    gameModel.move(replayQueueMoves[step])
  }
  
  func addRandom(step: Int) {
    let (row, col, newTile) = replayQueueRandoms[step + 1]
    gameModel.insertTile(row, col, newTile)
  }
  
  func refreshUI() {
    addRandom(step)
    gameModel.refresh()
    updateTiles()
    if step >= replayQueueMoves.count {
      stepButton.enabled = false
    }
    movesLabel.text = step.description
    scoreLabel.text = gameModel.getScore().description
  }
  
  func updateTiles() {
    for tile in tiles{
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
  
  @IBOutlet var tiles: [UIButton]!
  @IBOutlet weak var stepButton: UIButton!
  @IBOutlet weak var movesLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  
  @IBAction func backButtonTapped(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func stepButtonTapped(sender: AnyObject) {
    addMove(step)
    step++
    refreshUI()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addRandom(-1) //Initial tile
    refreshUI()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}