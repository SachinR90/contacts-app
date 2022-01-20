//
//  HomeViewModel.swift
//  ContactsApp
//
//  Created by Sachin Rao on 20/01/22.
//

import Foundation
protocol HomeViewModelCoordinatorDelegate: AnyObject {}

protocol HomeViewModelToControllerDelegate: AnyObject {}

protocol HomeViewModelType {
  var coordinatorDelegate: HomeViewModelCoordinatorDelegate? { get set }
  var viewModelToControllerDelegate: HomeViewModelToControllerDelegate? { get set }
}

class HomeViewModel: HomeViewModelType {
  public weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?
  public weak var viewModelToControllerDelegate: HomeViewModelToControllerDelegate?
}
