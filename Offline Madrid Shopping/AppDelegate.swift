//
//  AppDelegate.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coreDataManager: CoreDataManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.coreDataManager = CoreDataManager()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data config funcs

    func saveContext () {
        guard let coreDataManager = self.coreDataManager else { return }
        
        let container = coreDataManager.persistentContainer(dbName: coreDataManager.DB_NAME)
        coreDataManager.saveContext(context: container.viewContext)
    }
}

