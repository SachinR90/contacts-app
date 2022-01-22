//
//  ContactRepository.swift
//  ContactsApp
//
//  Created by Sachin Rao on 21/01/22.
//

import Foundation
protocol ContactRepository {
  func fetchContacts(isLocal: Bool, completion: @escaping (Result<[ContactsEntity], Error>) -> Void)
  func addContact(entity: ContactsEntity)
}
