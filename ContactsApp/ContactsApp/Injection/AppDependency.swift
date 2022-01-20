//
//  AppDependency.swift
//  ContactsApp
//
//  Created by Sachin Rao on 20/01/22.
//

import Foundation
/// Top level dependency container for the entire application.
/// It creates and holds the concrete instances of the dependencies and inject them into
/// their consumers as protocols.
final class AppDependency: AllInjectables {
  // MARK: Singletons

  lazy var networkConnectivity: Connectivity = { NetworkConnectivity.shared }()
  lazy var viewControllerProvider: ViewControllerProvider = { ViewControllerFactory(dependency: self) }()

  // MARK: Factories
}
