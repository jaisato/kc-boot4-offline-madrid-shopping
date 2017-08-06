//
//  LoadAllShopImagesInteractor.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 26/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit
import CoreData

public class LoadAllShopImagesInteractor {
    private let _loadShopImageInteractor: LoadShopImageInteractor
    private let _coreDataManager: CoreDataManager
    private let _container: NSPersistentContainer
    private var _shops: [Shop]
    
    private var numberOfImages: Int = 0
    private var numberOfLogos: Int = 0
    private var numberOfMapImages: Int = 0
    
    public init(interactor: LoadShopImageInteractor, coreDataManager: CoreDataManager) {
        _loadShopImageInteractor = interactor
        _coreDataManager = coreDataManager
        _container = _coreDataManager.persistentContainer(dbName: _coreDataManager.DB_NAME)
        _shops = []
    }
    
    public func execute(from shopArray: [Shop], completion: @escaping ([Shop]) -> Void, onError: @escaping ErrorClosure) {
        assert(Thread.current === Thread.main)
        
        print("Shops count: \(shopArray.count)")
        
        self._shops = shopArray
        for (index, _) in self._shops.enumerated() {
            self.loadShopImage(shopItem: index, shopsNumber: shopArray.count, completion, onError)
            self.loadShopLogo(shopItem: index, shopsNumber: shopArray.count, completion, onError)
            self.loadShopMapImage(shopItem: index, shopsNumber: shopArray.count, completion, onError)
        }
    }
    
    // Load and save Shop Images
    public func loadShopImage(shopItem: Int, shopsNumber: Int, _ completion: @escaping ([Shop]) -> Void, _ onError: @escaping ErrorClosure) {
        guard let shopImage: ShopImage = self._shops[shopItem].image, let _ = shopImage.url else { return }
        
        _loadShopImageInteractor.execute(shopImage: self._shops[shopItem].image!, completion: { (image: ShopImage) in
            assert(Thread.current === Thread.main)
            
            self._shops[shopItem].image!.data = image.data
            self._coreDataManager.saveContext(context: self._container.viewContext)
            
            self.numberOfImages = self.numberOfImages + 1
            print("numberOfImages: \(self.numberOfImages) of \(shopsNumber)")
            
            self.doCompletion(completion, shopsCount: shopsNumber)
        }, onError: { (error: Error) in
            self.numberOfImages = self.numberOfImages + 1
            print("\(error)")
            
            self.doCompletion(completion, shopsCount: shopsNumber)
        })
    }
    
    // Load and save Shop Logos
    public func loadShopLogo(shopItem: Int, shopsNumber: Int, _ completion: @escaping ([Shop]) -> Void, _ onError: @escaping ErrorClosure) {
        guard let shopLogo: ShopImage = self._shops[shopItem].logo, let _ = shopLogo.url else { return }
        
        _loadShopImageInteractor.execute(shopImage: self._shops[shopItem].logo!, completion: { (image: ShopImage) in
            assert(Thread.current === Thread.main)
            
            self._shops[shopItem].logo!.data = image.data
            self._coreDataManager.saveContext(context: self._container.viewContext)
            
            self.numberOfLogos = self.numberOfLogos + 1
            print("numberOfLogos: \(self.numberOfLogos) of \(shopsNumber)")
            
            self.doCompletion(completion, shopsCount: shopsNumber)
        }, onError: { (error: Error) in
            self.numberOfLogos = self.numberOfLogos + 1
            print("\(error)")
            
            self.doCompletion(completion, shopsCount: shopsNumber)
        })
    }
    
    // Load and save Shop Map Images
    public func loadShopMapImage(shopItem: Int, shopsNumber: Int, _ completion: @escaping ([Shop]) -> Void, _ onError: @escaping ErrorClosure) {
        guard let shopLocation = self._shops[shopItem].location,
            let shopMapImage: ShopImage = shopLocation.image,
            let _ = shopMapImage.url else { return }
        
        _loadShopImageInteractor.execute(shopImage: shopMapImage, completion: { (image: ShopImage) in
            assert(Thread.current === Thread.main)
            
            self._shops[shopItem].location?.image?.data = image.data
            self._coreDataManager.saveContext(context: self._container.viewContext)
            
            self.numberOfMapImages = self.numberOfMapImages + 1
            print("numberOfMapImages: \(self.numberOfMapImages) of \(shopsNumber)")
            
            self.doCompletion(completion, shopsCount: shopsNumber)
        }, onError: { (error: Error) in
            self.numberOfMapImages = self.numberOfMapImages + 1
            print("\(error)")
            
            self.doCompletion(completion, shopsCount: shopsNumber)
        })
    }
    
    // Do completion if applicable
    func doCompletion(_ completion: @escaping ([Shop]) -> Void, shopsCount: Int) {
        if self.numberOfImages == shopsCount
            && self.numberOfLogos == shopsCount
            && self.numberOfMapImages == shopsCount {
            
            self._coreDataManager.saveContext(context: self._container.viewContext)
            completion(self._shops)
        }
    }
}
