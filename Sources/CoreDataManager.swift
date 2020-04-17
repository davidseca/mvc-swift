//
//  CoreDataManager.swift
//  MVCSwift
//
//  Created by David Seca on 17.04.20.
//  Copyright © 2020 David Seca. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataManager {

    private init() {}

    static let shared = CoreDataManager()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }


    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MVCSwift")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - CoreData Saving support
    private func save(completion: @escaping () -> Void) {
        if context.hasChanges {
            do {
                try context.save()
                completion()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - CoreData Fetching support
    func fetch<T: NSManagedObject>(_ type: T.Type, sortedBy sortDescriptors: [NSSortDescriptor]? = nil, completion: @escaping ([T]) -> Void) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        if let sortDescriptors = sortDescriptors {
            request.sortDescriptors = sortDescriptors
        }
        do {
            let objects = try context.fetch(request)
            completion(objects)
        } catch {
            print(error)
            completion([])
        }
    }

    // MARK: - CoreData Clearing support
    private func clear<T: NSManagedObject>(_ type: T.Type, completion: @escaping () -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            completion()
        } catch let error as NSError {
            print(error)
        }
    }

    // MARK: - CoreData Save and fetch
    func saveAndFetch<T: NSManagedObject>(_ type: T.Type, sortedBy sortDescriptors: [NSSortDescriptor]? = nil, completion: @escaping ([T]) -> Void) {
        self.clear(type) {
            self.save {
                self.fetch(type, sortedBy: sortDescriptors) { objects in
                    completion(objects)
                }
            }
        }
    }
}
