//
//  CoreDataModel.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 17/10/18.
//  Copyright © 2018 Alan Victor Paulino de Oliveira. All rights reserved.
//

import Foundation
import CoreData


// MARK: - Core Data stack
class CoreDataModel{
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Citanki")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func fetch<T>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            let list = try persistentContainer.viewContext.fetch(request)
            return list
        } catch {
            print(error)
            return [T]()
        }
    }
    
    static func deleteObject(Object obj: NSManagedObject){
        let context = persistentContainer.viewContext
        context.delete(obj)
        do {
            try context.save()
            print("Context Saved")
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}

