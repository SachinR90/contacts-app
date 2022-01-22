//
//  ContactUseCase.swift
//  ContactsApp
//
//  Created by Sachin Rao on 21/01/22.
//

import Foundation
class ContactUseCase {
  typealias Dependency = ContactRepositoryInjectable
  private let contactRepository: ContactRepository
  init(depedency: Dependency) {
    self.contactRepository = depedency.contactRepository
  }

  func fetchContacts(isLocal: Bool = false, completion: @escaping (Result<[ContactsEntity], Error>) -> Void) {
    contactRepository.fetchContacts(isLocal: isLocal, completion: completion)
  }
}
