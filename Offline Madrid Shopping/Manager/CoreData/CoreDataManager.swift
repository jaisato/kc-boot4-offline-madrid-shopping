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
    
    // One container per store for the whole app. This used to build a new
    // NSPersistentContainer on every call, and CoreDataManager() is created in
    // several places, so the shops were inserted in one context, their images
    // written into objects owned by that (by then released) context, and the
    // saves went to yet other, empty contexts: the downloaded images never
    // reached the store and the "offline" data was only the placeholders.
    // Every caller runs on the main thread, so a plain static cache is enough.
    private static var containers: [String: NSPersistentContainer] = [:]
    
    public func persistentContainer(dbName: String) -> NSPersistentContainer {
        if let container = CoreDataManager.containers[dbName] {
            return container
        }
        
        let container = NSPersistentContainer(name: dbName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        CoreDataManager.containers[dbName] = container
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
