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
    
    public func execute(from shopArray: [Shop], completion: @escaping (Void) -> Void, onError: @escaping ErrorClosure) {
        assert(Thread.current === Thread.main)
        
        self._shops = shopArray
        for (index, _) in self._shops.enumerated() {
            self.loadShopImage(shopItem: index, shopsNumber: shopArray.count, completion, onError)
            self.loadShopLogo(shopItem: index, shopsNumber: shopArray.count, completion, onError)
        }
    }
    
    public func loadShopImage(shopItem: Int, shopsNumber: Int, _ completion: @escaping (Void) -> Void, _ onError: @escaping ErrorClosure) {
        guard let shopImage: ShopImage = self._shops[shopItem].image, let _ = shopImage.url else { return }
        
        _loadShopImageInteractor.execute(shopImage: self._shops[shopItem].image!, completion: { (image: ShopImage) in
            assert(Thread.current === Thread.main)
            
            self._shops[shopItem].image = image
            
            self.numberOfImages = self.numberOfImages + 1
            self._coreDataManager.saveContext(context: self._container.viewContext)
            
            if self.numberOfImages == shopsNumber && self.numberOfLogos == shopsNumber {
                completion()
            }
        }, onError: { (error: Error) in
            self.numberOfImages = self.numberOfImages + 1
            print("\(error)")
        })
    }
    
    public func loadShopLogo(shopItem: Int, shopsNumber: Int, _ completion: @escaping (Void) -> Void, _ onError: @escaping ErrorClosure) {
        guard let shopLogo: ShopImage = self._shops[shopItem].logo, let _ = shopLogo.url else { return }
        
        _loadShopImageInteractor.execute(shopImage: self._shops[shopItem].logo!, completion: { (image: ShopImage) in
            assert(Thread.current === Thread.main)
            
            self._shops[shopItem].logo = image
            
            self.numberOfLogos = self.numberOfLogos + 1
            self._coreDataManager.saveContext(context: self._container.viewContext)
            
            if self.numberOfImages == shopsNumber && self.numberOfLogos == shopsNumber {
                completion()
            }
        }, onError: { (error: Error) in
            self.numberOfLogos = self.numberOfLogos + 1
            print("\(error)")
        })
    }
}
