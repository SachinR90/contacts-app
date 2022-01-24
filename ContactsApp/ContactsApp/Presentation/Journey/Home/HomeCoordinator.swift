//
//  HomeCoordinator.swift
//  ContactsApp
//
//  Created by Sachin Rao on 20/01/22.
//

import Foundation
import UIKit

protocol HomeCoordinatorDelegate: AnyObject {}

extension HomeCoordinatorDelegate {}

class HomeCoordinator: BaseCoordinator {
  // MARK: - Properties

  typealias Dependency = ViewControllerProviderInjectable & HomeViewModelInjectable
  let navigationController: UINavigationController?
  weak var homeCoordinatorDelegate: HomeCoordinatorDelegate?
  private weak var homeViewController: HomeViewController?
  private let dependency: Dependency
  private let viewControllerProvider: ViewControllerProvider

  // MARK: - Coordinator life cycle

  init(navigationController: UINavigationController?, dependency: Dependency) {
    self.navigationController = navigationController
    self.dependency = dependency
    self.viewControllerProvider = dependency.viewControllerProvider
  }

  override func start() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self, let navigationController = self.navigationController else {
        return
      }
      self.makeLoginViewController()
      if let homeVC = self.homeViewController {
        navigationController.pushViewController(homeVC, animated: true)
      }
    }
  }

  private final func makeLoginViewController() {
    let homeViewController = viewControllerProvider.provideHomeViewController()
    var viewModel = dependency.homeViewModel
    viewModel.coordinatorDelegate = self
    viewModel.viewModelToControllerDelegate = homeViewController
    homeViewController.homeViewModel = viewModel
    self.homeViewController = homeViewController
  }
}

extension HomeCoordinator: HomeViewModelCoordinatorDelegate {}
