//
//  ViewControllerFactory.swift
//  ContactsApp
//
//  Created by Sachin Rao on 20/01/22.
//

import Foundation
import UIKit

protocol ViewControllerProvider {
  func provideHomeViewController() -> HomeViewController
}

struct ViewControllerFactory: ViewControllerProvider {
  typealias Dependency = AllInjectables
  private let dependency: Dependency
  init(dependency: Dependency) {
    self.dependency = dependency
  }

  func provideHomeViewController() -> HomeViewController {
    let uiStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    return uiStoryBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
  }
}
