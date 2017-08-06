//
//  ShoppingMapViewController+NSFetchedResultsControllerDelegate.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 6/8/17.
//  Copyright © 2017 JST. All rights reserved.
//

import Foundation
import CoreData

extension ShoppingMapViewController: NSFetchedResultsControllerDelegate {

    // MARK: - Fetched Results Controller delegate
    
    var fetchedResultsController: NSFetchedResultsController<Shop> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        _fetchedResultsController = NSFetchedResultsController(
            fetchRequest: Shop.fetchRequestOrderedByName(),
            managedObjectContext: self.context,
            sectionNameKeyPath: nil,
            cacheName: nil // no cache (test)
        )
        
        _fetchedResultsController?.delegate = self
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    func getContext(manager: CoreDataManager) -> NSManagedObjectContext {
        let container = manager.persistentContainer(dbName: manager.DB_NAME)
        return container.viewContext
    }
}
