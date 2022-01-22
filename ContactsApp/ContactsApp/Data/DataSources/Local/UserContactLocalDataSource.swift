//
//  UserContactLocalDataSource.swift
//  ContactsApp
//
//  Created by Sachin Rao on 21/01/22.
//

import Foundation
class ContactLocalDataSource {
  typealias Dependecy = CoreDataStoreInjectable
  let coreDataSore: CoreDataStorage
  init(dependency: Dependecy) {
    self.coreDataSore = dependency.coreDataStore
  }

  func fetchCount(completion: @escaping (Result<Int, Error>) -> Void) {
    coreDataSore.readContext.perform { [weak self] in
      guard let self = self else {
        completion(.failure(CoreDataError.cannotPerform))
        return
      }
      do {
        let context = self.coreDataSore.readContext
        let request = CDContact.fetchRequest()
        let count = try context.count(for: request)
        completion(.success(count))
      } catch {
        completion(.failure(error))
      }
    }
  }

  func fetchAll(completion: @escaping (Result<[ContactModel], Error>) -> Void) {
    coreDataSore.readContext.perform { [weak self] in
      guard let self = self else {
        completion(.failure(CoreDataError.cannotPerform))
        return
      }
      do {
        let context = self.coreDataSore.readContext
        let request = CDContact.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        let cdResults = try context.fetch(request)
        let results = cdResults.compactMap { ContactModel(from: $0) }
        completion(.success(results))
      } catch {
        completion(.failure(error))
      }
    }
  }

  func saveContact(contact: ContactModel, completion: @escaping (Result<Bool, Error>) -> Void) {
    let context = coreDataSore.writeContext()
    context.perform {
      do {
        contact.toCDContact(context: context)
        if context.hasChanges {
          try context.save()
          completion(.success(true))
        } else {
          completion(.success(false))
        }
      } catch {
        completion(.failure(error))
      }
    }
  }
}
