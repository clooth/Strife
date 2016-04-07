//
//  Array2D.swift
//  Strife
//
//  Created by Nico Hämäläinen on 08/10/15.
//  Copyright © 2015 sizeof.io. All rights reserved.
//

import Foundation

/// Represents a typed two-dimensional (x,y) array
struct Array2D<T>: CustomStringConvertible {
  /// Number of columns (y)
  let columns: Int
  /// Number of rows (x)
  let rows: Int
  
  /// The internal array for tracking
  var array: Array<T?>
  
  /// Create a new Array2D struct
  ///
  /// - parameter columns:	Number of columns in the Array
  /// - parameter rows:			Number of rows in the Array
  ///
  /// - returns: The new Array2D struct
  init(columns: Int, rows: Int) {
    self.columns = columns
    self.rows = rows
    array = Array<T?>(count: rows*columns, repeatedValue: nil)
  }
  
  /// Get the value for a specific position
  ///
  /// - parameter column: The column of the wanted value
  /// - parameter row:    The row of the wanted value
  ///
  /// - returns: The value if it exists
  subscript(column: Int, row: Int) -> T? {
    get {
      return array[row*columns + column]
    }
    
    set {
      array[row*columns + column] = newValue
    }
  }
  
  mutating func shuffle() {
    array.shuffle()
  }
  
  var description: String {
    var res = ""
    for row in 0..<rows {
      for col in 0..<columns {
        res += "\(self[col, row]!), "
      }
      res += "\n"
    }
    return res
  }
  
}