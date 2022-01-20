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

@objc class HomeCoordinator: BaseCoordinator {
  // MARK: - Properties

  typealias Dependency = ViewControllerProviderInjectable
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

  @objc override func start() {
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

  private func makeLoginViewController() {
    let homeViewController = self.viewControllerProvider.provideHomeViewController()
    let viewModel = HomeViewModel()
    viewModel.coordinatorDelegate = self
    viewModel.viewModelToControllerDelegate = homeViewController
    homeViewController.homeViewModelType = viewModel
    self.homeViewController = homeViewController
  }
}

extension HomeCoordinator: HomeViewModelCoordinatorDelegate {}
