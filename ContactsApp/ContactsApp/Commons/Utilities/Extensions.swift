//
//  Extensions.swift
//  ContactsApp
//
//  Created by Sachin Rao on 22/01/22.
//

import Foundation
public extension Array {
  subscript(safeIndex index: Int) -> Element? {
    guard index >= 0, index < endIndex else {
      return nil
    }

    return self[index]
  }
}
