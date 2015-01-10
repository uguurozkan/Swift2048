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
  
  @IBOutlet var tiles: [UIButton]!
  @IBOutlet weak var stepButton: UIButton!
  @IBOutlet weak var movesLabel: UILabel!
  
  @IBAction func backButtonTapped(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func stepButtonTapped(sender: AnyObject) {
    addMove(step)
    step++
    refreshUI()
  }
  
  func addMove(step: Int) {
    gameModel.move(replayQueueMoves[step])
  }
  
  func addRandom(step: Int) {
    let (row, col, newTile) = replayQueueRandoms[step + 1]
    gameModel.insertTile(row, col, newTile)
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
  
  func refreshUI() {
    addRandom(step)
    gameModel.refresh()
    updateTileTitles()
    if step >= replayQueueMoves.count {
      stepButton.enabled = false
    }
    movesLabel.text = step.description
  }
  
  func updateTileTitles() {
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
  
}