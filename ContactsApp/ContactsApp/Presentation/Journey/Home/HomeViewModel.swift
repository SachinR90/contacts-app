//
//  HomeViewModel.swift
//  ContactsApp
//
//  Created by Sachin Rao on 20/01/22.
//

import Foundation
import UIKit
protocol HomeViewModelCoordinatorDelegate: AnyObject {}

protocol HomeViewModelToControllerDelegate: AnyObject {
  func refreshTable()
  func showErrorMessage(message: String)
}

protocol HomeViewModelType {
  var coordinatorDelegate: HomeViewModelCoordinatorDelegate? { get set }
  var viewModelToControllerDelegate: HomeViewModelToControllerDelegate? { get set }
  func numberOfRowsInSection(section: Int) -> Int
  func getIndexTitles() -> [String]?
  func getIndex(for sectionIndexTitle: String) -> Int?
  func fetchContact()
  func getItem(at index: IndexPath) -> ContactsEntity?
}

class HomeViewModel: HomeViewModelType {
  init(depedency: Dependency) {
    self.contactUseCase = depedency.contactUseCase
  }

  typealias Dependency = ContactUseCaseInjectable

  // MARK: - private variables

  private var contacts: [ContactsEntity] = []
  private var sectionIndexes: [String: [ContactsEntity]] {
    Dictionary(grouping: contacts) { $0.firstName.first!.uppercased() }
  }

  // MARK: - public variables

  let contactUseCase: ContactUseCase
  weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?
  weak var viewModelToControllerDelegate: HomeViewModelToControllerDelegate?

  // MARK: - Methods

  func getItem(at index: IndexPath) -> ContactsEntity? {
    guard !contacts.isEmpty, let entity = contacts[safeIndex: index.row] else {
      return nil
    }
    return entity
  }

  func fetchContact() {
    contactUseCase.fetchContacts(isLocal: true) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let data):
        self.contacts = data.sorted { $0.firstName.caseInsensitiveCompare($1.firstName) == .orderedAscending }
        self.viewModelToControllerDelegate?.refreshTable()
      case .failure(let error):
        print(error)
      }
    }
  }

  func getIndex(for sectionIndexTitle: String) -> Int? {
    sectionIndexes[sectionIndexTitle]?[safeIndex: 0].flatMap { contact in
      contacts.firstIndex(of: contact)
    }
  }

  func numberOfRowsInSection(section _: Int) -> Int {
    contacts.count
  }

  func getIndexTitles() -> [String]? {
    Array(sectionIndexes.keys).sorted()
  }
}
