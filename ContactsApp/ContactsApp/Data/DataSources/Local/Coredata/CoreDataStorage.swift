//
//  CoreDataStorage.swift
//  ContactsApp
//
//  Created by Sachin Rao on 20/01/22.
//

import CoreData
import Foundation
import UIKit
enum CoreDataError: Error {
  case cannotPerform
}

class CoreDataStorage: NSObject {
  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "CoreContactsCoredata")
    container.loadPersistentStores(completionHandler: { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  public lazy var readContext: NSManagedObjectContext = {
    let context = persistentContainer.viewContext
    return context
  }()

  public func writeContext() -> NSManagedObjectContext {
    let context = persistentContainer.newBackgroundContext()
    context.automaticallyMergesChangesFromParent = true
    context.parent = readContext
    return context
  }

  // MARK: - Core Data Saving support

  public func saveContext() {
    let context = writeContext()
    context.perform {
      do {
        try context.save()
      } catch let error as NSError {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }

  func clearStorage(forEntity entity: String) {
    let isInMemoryStore = persistentContainer.persistentStoreDescriptions.reduce(false) {
      $0 ? true : $1.type == NSInMemoryStoreType
    }

    let managedObjectContext = persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    // NSBatchDeleteRequest is not supported for in-memory stores
    if isInMemoryStore {
      do {
        let entities = try managedObjectContext.fetch(fetchRequest)
        for entity in entities {
          managedObjectContext.delete(entity as! NSManagedObject)
        }
      } catch let error as NSError {
        print(error)
      }
    } else {
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      do {
        try managedObjectContext.execute(batchDeleteRequest)
      } catch let error as NSError {
        print(error)
      }
    }
  }
}
