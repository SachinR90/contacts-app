//
//  ContactRepositoryProvider.swift
//  ContactsApp
//
//  Created by Sachin Rao on 21/01/22.
//

import Foundation
import Network
class ContactRepositoryProvider: ContactRepository {
  typealias Dependency =
    NetworkConnectivityInjectable
      & ContactLocalDataSourceInjectable
      & ContactRemoteDataSourceInjectable

  let localDataSource: ContactLocalDataSource
  let remoteDataSource: ContactRemoteDataSource
  let connectivity: Connectivity

  init(depedency: Dependency) {
    self.localDataSource = depedency.contactLocalDataSource
    self.remoteDataSource = depedency.contactRemoteDataSource
    self.connectivity = depedency.networkConnectivity
  }

  fileprivate func extractEntityFromList(_ result: Result<[ContactModel], Error>, _ completion: @escaping (Result<[ContactsEntity], Error>) -> Void) {
    switch result {
    case .success(let data):
      let results = data.map { ContactsEntity(from: $0) }
      completion(.success(results))
    case .failure(let error):
      completion(.failure(error))
    }
  }

  func fetchContacts(isLocal: Bool, completion: @escaping (Result<[ContactsEntity], Error>) -> Void) {
    if isLocal || connectivity.currentStatus.status != .connected {
      localDataSource.fetchAll { [weak self] result in
        guard let self = self else {
          return
        }
        self.extractEntityFromList(result, completion)
      }
    } else {
      remoteDataSource.fetchContact { [weak self] result in
        guard let self = self else {
          return
        }
        self.extractEntityFromList(result, completion)
      }
    }
  }

  func addContact(entity: ContactsEntity) {}
}
