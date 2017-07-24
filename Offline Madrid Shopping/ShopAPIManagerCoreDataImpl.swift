//
//  ShopAPIManagerCoreDataImpl.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 23/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import CoreData
import UIKit

public class ShopAPIManagerCoreDataImpl: ShopAPIManager {
    private let DB_NAME = "Offline_Madrid_Shopping"
    private var _manager: CoreDataManager
    
    public init(coreDataManager: CoreDataManager) {
        _manager = coreDataManager
    }
    
    public func getShops(completion: @escaping GetShopsCompletionClosure, onError: @escaping ErrorClosure) {
        // TODO: implement
    }
    
    public func getShops(completion: @escaping GetShopsCompletionClosure) throws {
        // TODO: implement
    }
    
    public func saveShop(shopJson: ShopJson, completion: @escaping (Shop) -> Void, onError: @escaping ErrorClosure) {
        let container = _manager.persistentContainer(dbName: self.DB_NAME)
        
        DispatchQueue.main.async {
            let shop = self.createShop(from: shopJson)
            self._manager.saveContext(context: container.viewContext)
            
            completion(shop)
        }
    }
    
    private func createShop(from shopJson: ShopJson) -> Shop {
        let container = _manager.persistentContainer(dbName: self.DB_NAME)
        let shop = Shop(from: shopJson, context: container.viewContext)
        
        // Shop location (Coordinates)
        let location = ShopLocation(from: shopJson, context: container.viewContext)
        shop.location = location
        
        // Multivalue data (by language)
        let enDescription = ShopDescription(from: shopJson, language: Language.english, context: container.viewContext)
        let esDescription = ShopDescription(from: shopJson, language: Language.spanish, context: container.viewContext)
        shop.addToDescriptions(NSSet(array: [esDescription, enDescription]))
        
        let enOpeningHours = ShopOpeningHour(from: shopJson, language: Language.english, context: container.viewContext)
        let esOpeningHours = ShopOpeningHour(from: shopJson, language: Language.spanish, context: container.viewContext)
        shop.addToOpeningHours(NSSet(array: [esOpeningHours, enOpeningHours]))
        
        let enKeywords = ShopKeywords(from: shopJson, language: Language.english, context: container.viewContext)
        let esKeywords = ShopKeywords(from: shopJson, language: Language.spanish, context: container.viewContext)
        shop.addToKeywords(NSSet(array: [esKeywords, enKeywords]))
        
        return shop
    }
    
    public func getShopImage(urlString: String, completion: @escaping (UIImage) -> Void, onError: @escaping ErrorClosure) {
        // TODO: implement
    }
}
