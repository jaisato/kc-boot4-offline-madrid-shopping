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
    
    public init(interactor: LoadShopImageInteractor, coreDataManager: CoreDataManager) {
        _loadShopImageInteractor = interactor
        _coreDataManager = coreDataManager
        _container = _coreDataManager.persistentContainer(dbName: _coreDataManager.DB_NAME)
        _shops = []
    }
    
    public func execute(from shopArray: [Shop], completion: @escaping ([Shop]) -> Void, onError: @escaping ErrorClosure) {
        assert(Thread.current === Thread.main)
        
        print("Shops count: \(shopArray.count)")
        print("numberOfImages: \(self.numberOfImages)")
        print("numberOfLogos: \(self.numberOfLogos)")
        
        self._shops = shopArray
        for (index, _) in self._shops.enumerated() {
            self.loadShopImage(shopItem: index, shopsNumber: shopArray.count, completion, onError)
            self.loadShopLogo(shopItem: index, shopsNumber: shopArray.count, completion, onError)
        }
    }
    
    public func loadShopImage(shopItem: Int, shopsNumber: Int, _ completion: @escaping ([Shop]) -> Void, _ onError: @escaping ErrorClosure) {
        guard let shopImage: ShopImage = self._shops[shopItem].image, let _ = shopImage.url else { return }
        
        _loadShopImageInteractor.execute(shopImage: self._shops[shopItem].image!, completion: { (image: ShopImage) in
            assert(Thread.current === Thread.main)
            
            self._shops[shopItem].image!.data = image.data
            self._coreDataManager.saveContext(context: self._container.viewContext)
            
            self.numberOfImages = self.numberOfImages + 1
            print("numberOfImages: \(self.numberOfImages)")
            
            if self.numberOfImages == shopsNumber && self.numberOfLogos == shopsNumber {
                self._coreDataManager.saveContext(context: self._container.viewContext)
                completion(self._shops)
            }
        }, onError: { (error: Error) in
            self.numberOfImages = self.numberOfImages + 1
            print("\(error)")
            
            if self.numberOfImages == shopsNumber && self.numberOfLogos == shopsNumber {
                self._coreDataManager.saveContext(context: self._container.viewContext)
                completion(self._shops)
            }
        })
    }
    
    public func loadShopLogo(shopItem: Int, shopsNumber: Int, _ completion: @escaping ([Shop]) -> Void, _ onError: @escaping ErrorClosure) {
        guard let shopLogo: ShopImage = self._shops[shopItem].logo, let _ = shopLogo.url else { return }
        
        _loadShopImageInteractor.execute(shopImage: self._shops[shopItem].logo!, completion: { (image: ShopImage) in
            assert(Thread.current === Thread.main)
            
            self._shops[shopItem].logo!.data = image.data
            self._coreDataManager.saveContext(context: self._container.viewContext)
            
            self.numberOfLogos = self.numberOfLogos + 1
            print("numberOfLogos: \(self.numberOfLogos)")
            
            if self.numberOfImages == shopsNumber && self.numberOfLogos == shopsNumber {
                self._coreDataManager.saveContext(context: self._container.viewContext)
                completion(self._shops)
            }
        }, onError: { (error: Error) in
            self.numberOfLogos = self.numberOfLogos + 1
            print("\(error)")
            
            if self.numberOfImages == shopsNumber && self.numberOfLogos == shopsNumber {
                self._coreDataManager.saveContext(context: self._container.viewContext)
                completion(self._shops)
            }
        })
    }
}
