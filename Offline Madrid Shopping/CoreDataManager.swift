//
//  CoreDataManager.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 23/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import CoreData

public class CoreDataManager {
    public let DB_NAME = "Offline_Madrid_Shopping"
    
    public func persistentContainer(dbName: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: dbName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }
    
    public func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
