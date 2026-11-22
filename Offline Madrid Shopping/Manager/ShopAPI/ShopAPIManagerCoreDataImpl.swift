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
        // flatMap and not map: a shop that breaks a rule of the model is left
        // out (see validShop) instead of failing the save of all the others.
        let shops: [Shop] = shopJsonArray.flatMap({ (shopJson: ShopJson) -> Shop? in
            return self.validShop(from: shopJson, container: container)
        })
        
        self._manager.saveContext(context: container.viewContext)
        
        completion(shops)
    }
    
    public func saveShop(shopJson: ShopJson, completion: @escaping (Shop) -> Void, onError: @escaping ErrorClosure) {
        let container = self._manager.persistentContainer(dbName: self._manager.DB_NAME)
        guard let shop = self.validShop(from: shopJson, container: container) else {
            return onError(ShopAPIError.saveError("The shop does not satisfy the data model"))
        }
        self._manager.saveContext(context: container.viewContext)
        
        completion(shop)
    }
    
    /// The shop built from shopJson, or nil when it breaks a rule of the Core
    /// Data model, and then nothing of it is left in the context. The whole
    /// import is saved at once and saveContext ends in fatalError on any
    /// validation error, so one shop without a name (Shop.name has a minimum
    /// length of 1, and a missing one fell back to "") or with a negative id
    /// (minimum 0) crashed the app; with nothing saved, the next "Load Shops"
    /// downloaded the same data and crashed again.
    private func validShop(from shopJson: ShopJson, container: NSPersistentContainer) -> Shop? {
        let shop = self.createShop(from: shopJson, container: container)
        
        do {
            try shop.validateForInsert()
            return shop
        } catch {
            let id = (shopJson["id"] as? String) ?? "?"
            print("Skipping shop \(id): \(error.localizedDescription)")
            // The cascade delete rules take its location, images,
            // descriptions, opening hours and keywords with it.
            container.viewContext.delete(shop)
            return nil
        }
    }
    
    private func createShop(from shopJson: ShopJson, container: NSPersistentContainer) -> Shop {
        let shop = Shop(from: shopJson, context: container.viewContext)
        
        // Shop location (Coordinates)
        let location = ShopLocation(from: shopJson, context: container.viewContext)
        location.image = ShopImage.createShopLocationImage(location: location, context: container.viewContext)
        shop.location = location
        
        
        // Shop images. The model requires both (Shop.image and Shop.logo are
        // not optional), so a shop whose "img" or "logo_img" was missing or
        // null got neither and failed validation when the import was saved.
        // The placeholder is stored either way; an empty url only means there
        // is nothing to download (see LoadAllShopImagesInteractor).
        let imageUrl = (shopJson["img"] as? String) ?? ""
        if let image = UIImage(named: "shop-background"),
            let imageData = UIImageJPEGRepresentation(image, 1) as NSData? {
            shop.image = ShopImage(url: imageUrl, data: imageData, context: container.viewContext)
        }
        let logoUrl = (shopJson["logo_img"] as? String) ?? ""
        if let logo = UIImage(named: "shop-icon"),
            let logoData = UIImageJPEGRepresentation(logo, 1) as NSData? {
            shop.logo = ShopImage(url: logoUrl, data: logoData, context: container.viewContext)
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
