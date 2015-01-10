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
  case InProgress, UserHasWon, UserHasLost
}

enum Direction{
  case Up, Right, Down, Left
  
  func getDirectionValues() -> (Int, Int) {
    switch self {
    case .Up: return (-1, 0)
    case .Right: return (0, 1)
    case .Down: return (1, 0)
    case .Left: return (0, -1)
    }
  }
}

class GameModel {
  let dimension: Int = 4
  let maxValue: Int
  var gameState = GameState.InProgress
  var board: [[TileObject]]
  var replayQueueMoves = [Direction]()
  var replayQueueRandoms = [(Int, Int, TileObject)]()
  
  init(maxValue: Int, isReplay: Bool) {
    self.maxValue = maxValue
    
    let boardRow = [TileObject](count: dimension, repeatedValue: .Empty)
    board = [[TileObject]] (count: dimension, repeatedValue: boardRow)

    if !isReplay{
      addRandomTile()
    }
  }
  
  func move(direction: Direction){
    replayQueueMoves.append(direction)
    
    switch (direction) {
    case .Left:
      for var row = 0; row < board.count; row++ {
        for var col = 0; col < board[row].count; col++ {
          var tileValue = board[row][col].getValue()
          
          if tileValue != 0 {
            moveLeft(row, col, value: tileValue)
          }
        }
      }
      break
    case .Up:
      for var row = 0; row < board.count; row++ {
        for var col = 0; col < board[row].count; col++ {
          var tileValue = board[row][col].getValue()
          
          if tileValue != 0 {
            moveUp(row, col, value: tileValue)
          }
        }
      }
      break
    case .Right:
      for var row = board.count - 1; row >= 0; row-- {
        for var col = board[row].count - 1; col >= 0; col-- {
          var tileValue = board[row][col].getValue()
          
          if tileValue != 0 {
            moveRight(row, col, value: tileValue)
          }
        }
      }
      break
    case .Down:
      for var row = board.count - 1; row >= 0; row-- {
        for var col = board[row].count - 1; col >= 0; col-- {
          var tileValue = board[row][col].getValue()
          
          if tileValue != 0 {
            moveDown(row, col, value: tileValue)
          }
        }
      }
      break
    }
  }
  
  func moveDown(sRow: Int, _ sCol: Int, value: Int){
    var row = sRow
    var col = sCol
    
    while isInBounds(row + 1, col) {
      var currentTile = board[row][col]
      var targetTile = board[row + 1][col]
      
      var action = determineAction(currentTile, targetTile: targetTile)
      switch (action) {
      case TileAction.Merge:
        propagate((row, col), to: (row + 1, col), value: value, merge: true)
        break
      case TileAction.Move:
        propagate((row, col), to: (row + 1, col), value: value, merge: false)
        break
      case TileAction.NoAction:
        break
      }
     
      if action == TileAction.NoAction {
        break
      }
      row = row + 1
    }
  }
  
  func moveRight(sRow: Int, _ sCol: Int, value: Int){
    var row = sRow
    var col = sCol

    while isInBounds(row, col + 1) {
      var currentTile = board[row][col]
      var targetTile = board[row][col + 1]
      
      var action = determineAction(currentTile, targetTile: targetTile)
      switch (action) {
      case TileAction.Merge:
        propagate((row, col), to: (row, col + 1), value: value, merge: true)
        break
      case TileAction.Move:
        propagate((row, col), to: (row, col + 1), value: value, merge: false)
        break
      case TileAction.NoAction:
        break
      }
      
      if action == TileAction.NoAction {
        break
      }
      
      col = col + 1
    }
  }
  
  func moveUp(sRow: Int, _ sCol: Int, value: Int){
    var row = sRow
    var col = sCol
    
    while isInBounds(row - 1, col) {
      var currentTile = board[row][col]
      var targetTile = board[row - 1][col]
      
      var action = determineAction(currentTile, targetTile: targetTile)
      switch (action) {
      case TileAction.Merge:
        propagate((row, col), to: (row - 1, col), value: value, merge: true)
        break
      case TileAction.Move:
        propagate((row, col), to: (row - 1, col), value: value, merge: false)
        break
      case TileAction.NoAction:
        break
      }
      
      if action == TileAction.NoAction {
        break
      }
      
      row = row - 1
      
    }
  }
  
  func moveLeft(sRow: Int, _ sCol: Int, value: Int){
    var row = sRow
    var col = sCol
    
    while isInBounds(row, col - 1) {
      var currentTile = board[row][col]
      var targetTile = board[row][col - 1]
      
      var action = determineAction(currentTile, targetTile: targetTile)
      switch (action) {
      case TileAction.Merge:
        propagate((row, col), to: (row, col - 1), value: value, merge: true)
        break
      case TileAction.Move:
        propagate((row, col), to: (row, col - 1), value: value, merge: false)
        break
      case TileAction.NoAction:
        break
      }
      
      if action == TileAction.NoAction {
        break
      }
      
      col = col - 1
      
    }
  }
  
  func isInBounds (row: Int, _ col: Int) -> Bool {
    if row >= 0 && row < board.count && col >= 0 && col < board.count {
      return true
    } else {
      return false
    }
  }
  
  func determineAction(currentTile: TileObject, targetTile: TileObject) -> TileAction {
    if targetTile.getValue() == currentTile.getValue() && targetTile.getMergeCondition() == false && currentTile.getMergeCondition() == false{
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

    insertTile(fromRow, fromCol, TileObject.Empty)
    if merge {
      insertTile(toRow, toCol, TileObject.Tile(value: value * 2, isMerged: true))
    } else {
      insertTile(toRow, toCol, TileObject.Tile(value: value, isMerged: false))
    }
  }
  
  func refresh() {
    for var row = 0; row < board.count; row++ {
      for var col = 0; col < board[row].count; col++ {
        var tileValue = board[row][col].getValue()
        if tileValue != 0 {
          board[row][col] = TileObject.Tile(value: tileValue, isMerged: false)
        }
      }
    }
  }
  
  func addRandomTile() -> (Int, Int){
    let (row, col) = getRandomCoordinates()
    
    var newTile = TileObject.Tile(value: getRandomValue(), isMerged: false)
    insertTile(row, col, newTile)
    
    replayQueueRandoms.append((row, col, newTile))
    return (row, col)
  }
  
  func getRandomCoordinates() -> (Int, Int) {
    var row: Int
    var col: Int
    do {
      row = Int(arc4random_uniform(4))
      col = Int(arc4random_uniform(4))
    } while(!isAvailable(row, col: col))
    
    return (row, col)
  }
  
  func isAvailable(row: Int, col: Int) -> Bool{
    return board[row][col].getValue() == 0
  }
  
  func getRandomValue() -> Int {
    if Int(arc4random_uniform(100)) < 20 {
      return 4
    } else {
      return 2
    }
  }
  
  func insertTile(row: Int, _ col: Int, _ newTile: TileObject) {
    board[row][col] = newTile
  }
  
  func getGameState() -> GameState {
    if hasUserLost() {
      return .UserHasLost
    } else if hasUserWon() {
      return .UserHasWon
    } else {
      return .InProgress
    }
  }
  
  func hasUserWon() -> Bool {
    for var row = 0; row < board.count; row++ {
      for var col = 0; col < board[row].count; col++ {
        switch board[row][col] {
        case .Empty:
          break
        case let .Tile(value,_):
          if value >= maxValue {
            return true
          }
        }
      }
    }
    return false
  }
  
  func hasUserLost() -> Bool {
    if !isBoardFull() {
      return false
    }
    
    for var row = 0; row < board.count; row++ {
      for var col = 0; col < board[row].count; col++ {
        switch board[row][col] {
        case .Empty:
          continue
        case let .Tile(value,_):
          if isBelowSame((row, col), value) || isRightSame((row, col), value) {
            return false
          }
        }
      }
    }
    return true
  }
  
  func isBoardFull() -> Bool {
    var emptySpots = 0
    for var row = 0; row < board.count; row++ {
      for var col = 0; col < board[row].count; col++ {
        switch board[row][col] {
        case .Empty:
          emptySpots += 1
        case .Tile:
          break
        }
      }
    }
    
    return emptySpots == 0
  }
  
  func isBelowSame(tileCoordinate: (Int, Int), _ value: Int) -> Bool {
    let (row, col) = tileCoordinate
    if row == dimension - 1 {
      return false
    }
    
    switch board[row + 1][col] {
    case .Empty:
      return false
    case let .Tile(v, _):
      return v == value
    }
  }
  
  func isRightSame(tileCoordinate: (Int, Int), _ value: Int) -> Bool {
    let (row, col) = tileCoordinate
    if col == dimension - 1 {
      return false
    }
    
    switch board[row][col + 1] {
    case .Empty:
      return false
    case let .Tile(v,_):
      return v == value
    }
  }

  // TODO Change logic
  func getScore() -> Int {
    var score = 0
    for var row = 0; row < board.count; row++ {
      for var col = 0; col < board[row].count; col++ {
        score += board[row][col].getValue()
      }
    }
    return score
  }
}
