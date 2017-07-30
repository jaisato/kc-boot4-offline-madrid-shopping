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
    private var _manager: CoreDataManager
    
    public init(coreDataManager: CoreDataManager) {
        _manager = coreDataManager
    }
    
    public func getShops(completion: @escaping GetShopJsonArrayCompletionClosure, onError: @escaping ErrorClosure) {
        let error = ShopAPIError.saveError("Not implemented! Use getShops(completion: @escaping GetShopArrayCompletionClosure, onError: @escaping ErrorClosure)")
        onError(error)
    }
    
    public func getShops(completion: @escaping GetShopArrayCompletionClosure, onError: @escaping ErrorClosure) {
        let container = _manager.persistentContainer(dbName: _manager.DB_NAME)
        
        let fetchRequest: NSFetchRequest<Shop> = Shop.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            completion(result)
        } catch {
            onError(error)
        }
    }
    
    public func saveAllShop(shopJsonArray: ShopJsonArray, completion: @escaping ([Shop]) -> Void, onError: @escaping ErrorClosure) {
            let container = self._manager.persistentContainer(dbName: self._manager.DB_NAME)
            let shops: [Shop] = shopJsonArray.map({ (shopJson: ShopJson) -> Shop in
                return self.createShop(from: shopJson, container: container)
            })
            
            self._manager.saveContext(context: container.viewContext)
            
            completion(shops)
    }
    
    public func saveShop(shopJson: ShopJson, completion: @escaping (Shop) -> Void, onError: @escaping ErrorClosure) {
            let container = self._manager.persistentContainer(dbName: self._manager.DB_NAME)
            let shop = self.createShop(from: shopJson, container: container)
            self._manager.saveContext(context: container.viewContext)
            
            completion(shop)
    }
    
    private func createShop(from shopJson: ShopJson, container: NSPersistentContainer) -> Shop {
        let shop = Shop(from: shopJson, context: container.viewContext)
        
        // Shop location (Coordinates)
        let location = ShopLocation(from: shopJson, context: container.viewContext)
        shop.location = location
        
        // Shop images
        if let image = shopJson["img"] as? String {
            shop.image = ShopImage(url: image, context: container.viewContext)
        }
        if let logo = shopJson["logo_img"] as? String {
            shop.logo = ShopImage(url: logo, context: container.viewContext)
        }
        
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
    
    public func getAllShopImages(from shopArray: [Shop], completion: @escaping (UIImage) -> Void, onError: @escaping ErrorClosure) {
        let _ = shopArray.map { (shop: Shop) -> Void in
            if let imageUrl = shop.image?.url {
                self.getShopImage(urlString: imageUrl, completion: completion, onError: onError)
            }
        }
    }
    
    public func getAllShopLogos(from shopArray: [Shop], completion: @escaping (UIImage) -> Void, onError: @escaping ErrorClosure) {
        let _ = shopArray.map { (shop: Shop) -> Void in
            if let logoUrl = shop.logo?.url {
                self.getShopImage(urlString: logoUrl, completion: completion, onError: onError)
            }
        }
    }
}
