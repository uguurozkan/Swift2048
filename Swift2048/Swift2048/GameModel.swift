//
//  GameModel.swift
//  Swift2048
//
//  Created by student6 on 23/12/14.
//  Copyright (c) 2014 Ugur Ozkan. All rights reserved.
//

import UIKit

enum TileObject {
  case Empty, Tile(value: Int, isMerged: Bool)
  
  func getValue () -> Int {
    switch self {
    case let .Empty: return 0
    case let .Tile(value, _) : return value
    }
  }
  
  func getMergeCondition() -> Bool {
    switch self {
    case let .Empty: return true
    case let .Tile(_, isMerged) : return isMerged
    }
  }
}

enum TileAction {
  case NoAction, Move, Merge
}

enum GameState {
  case InProgress, Finished
}

enum Direction {
  case Up, Right, Down, Left
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
  
  func move(direction: Direction){
    for var row = 0; row < board.count; row++ {
      for var col = 0; col < board[row].count; col++ {
        var tileValue = board[row][col].getValue()
 
        if tileValue != 0 {
          switch (direction) {
          case .Down:
            break
          case .Right:
            moveRight(row, sCol: col, value: tileValue)
            break
          case .Up:
            moveUp(row, sCol: col, value: tileValue)
            break
          case .Left:
            moveLeft(row, sCol: col, value: tileValue)
            break
          }
        }
      }
    }
  }
  
  func moveDown(sRow: Int, sCol: Int, value: Int){
    var row = sRow
    var col = sCol
    
    var currentTile = board[row][col]
    var targetTile = board[row + 1][col]
    
    while isInBoundary(row + 1, col: col) {
      
      switch (determineAction(currentTile, targetTile: targetTile)) {
      case TileAction.Merge:
        propagate((row, col), to: (row + 1, col), value: value, merge: true)
        break
      case TileAction.Move:
        propagate((row, col), to: (row + 1, col), value: value, merge: false)
        break
      case TileAction.NoAction:
        break
      }
      
      row = row + 1
      var currentTile = board[row][col]
      var targetTile = board[row - 1][col]
      
    }
  }
  
  func moveRight(sRow: Int, sCol: Int, value: Int){
    var row = sRow
    var col = sCol
    
    var currentTile = board[row][col]
    var targetTile = board[row][col + 1]
    
    while isInBoundary(row, col: col + 1) {
      
      switch (determineAction(currentTile, targetTile: targetTile)) {
      case TileAction.Merge:
        propagate((row, col), to: (row, col + 1), value: value, merge: true)
        break
      case TileAction.Move:
        propagate((row, col), to: (row, col + 1), value: value, merge: false)
        break
      case TileAction.NoAction:
        break
      }
      
      col = col + 1
      var currentTile = board[row][col]
      var targetTile = board[row][col + 1]
      
    }
  }
  
  func moveUp(sRow: Int, sCol: Int, value: Int){
    var row = sRow
    var col = sCol
    
    var currentTile = board[row][col]
    var targetTile = board[row - 1][col]
    
    while isInBoundary(row - 1, col: col) {
      
      switch (determineAction(currentTile, targetTile: targetTile)) {
      case TileAction.Merge:
        propagate((row, col), to: (row - 1, col), value: value, merge: true)
        break
      case TileAction.Move:
        propagate((row, col), to: (row - 1, col), value: value, merge: false)
        break
      case TileAction.NoAction:
        break
      }
      
      row = row - 1
      var currentTile = board[row][col]
      var targetTile = board[row - 1][col]
      
    }
  }
  
  func moveLeft(sRow: Int, sCol: Int, value: Int){
    var row = sRow
    var col = sCol
    
    var currentTile = board[row][col]
    var targetTile = board[row][col - 1]
    
    while isInBoundary(row, col: col - 1) {
      
      switch (determineAction(currentTile, targetTile: targetTile)) {
      case TileAction.Merge:
        propagate((row, col), to: (row, col - 1), value: value, merge: true)
        break
      case TileAction.Move:
        propagate((row, col), to: (row, col - 1), value: value, merge: false)
        break
      case TileAction.NoAction:
        break
      }
      
      col = col - 1
      var currentTile = board[row][col]
      var targetTile = board[row][col - 1]
      
    }
  }
  
  func isInBoundary (row: Int, col: Int) -> Bool {
    if row >= 0 && row < board.count && col >= 0 && col < board.count {
      return true
    } else {
      return false
    }
  }
  
  func determineAction(currentTile: TileObject, targetTile: TileObject) -> TileAction {
    if targetTile.getValue() == currentTile.getValue() && targetTile.getMergeCondition() == false {
      return TileAction.Merge
    }
    
    if targetTile.getValue() == 0 {
      return TileAction.Move
    }
    
    return TileAction.NoAction
  }
  
  func propagate(from: (Int, Int), to: (Int, Int), value: Int, merge: Bool) {
    let (fromRow, fromCol) = from
    let (toRow, toCol) = to

    if merge {
      board[fromRow][fromCol] = TileObject.Empty
      board[toRow][toCol] = TileObject.Tile(value: value * 2, isMerged: true)
    } else {
      board[fromRow][fromCol] = TileObject.Empty
      board[toRow][toCol] = TileObject.Tile(value: value, isMerged: false)
    }
  }
  

  
  
  
}
