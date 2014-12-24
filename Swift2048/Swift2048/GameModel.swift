//
//  GameModel.swift
//  Swift2048
//
//  Created by student6 on 23/12/14.
//  Copyright (c) 2014 Ugur Ozkan. All rights reserved.
//

import UIKit

enum TileObject {
  case Empty, Tile(value: Int)
}

enum TileAction {
  case NoAction(source: Int, value: Int)
  case Move(source: Int, value: Int)
  case Combine(source: Int, value: Int)
}

enum GameState {
  case InProgress, Finished
}

class GameModel {
  let dimension: Int = 4
  let maxValue: Int
  var gameState = GameState.InProgress
  var board: [[TileObject]]
  // TODO implement score mechanism later.
  
  
  init(maxValue: Int) {
    self.maxValue = maxValue
    
    let boardRow = [TileObject](count: dimension, repeatedValue: .Empty)
    board = [[TileObject]] (count: dimension, repeatedValue: boardRow)
  }
  
  func propagate(){
    
  }
  
  
}
