//
//  Array+Shuffle.swift
//  Strife
//
//  Created by Nico Hämäläinen on 08/10/15.
//  Copyright © 2015 sizeof.io. All rights reserved.
//

import Foundation

extension MutableCollectionType where Self.Index == Int {
  mutating func shuffle() {
    var elements = self
    for index in 0..<elements.count {
      let newIndex = Int(arc4random_uniform(UInt32(elements.count-index)))+index
      if index != newIndex {
        swap(&elements[index], &elements[newIndex])
      }
    }
  }
}