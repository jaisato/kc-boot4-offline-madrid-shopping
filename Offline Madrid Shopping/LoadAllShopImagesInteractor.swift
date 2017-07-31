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
    
    private var numberOfImages: Int = 0
    private var numberOfLogos: Int = 0
    
    public init(interactor: LoadShopImageInteractor, coreDataManager: CoreDataManager) {
        _loadShopImageInteractor = interactor
        _coreDataManager = coreDataManager
        _container = _coreDataManager.persistentContainer(dbName: _coreDataManager.DB_NAME)
    }
    
    public func execute(from shopArray: [Shop], completion: @escaping (Void) -> Void, onError: @escaping ErrorClosure) {
        for shop in shopArray {
            loadShopImage(shop: shop, shopsNumber: shopArray.count, completion, onError)
            loadShopLogo(shop: shop, shopsNumber: shopArray.count, completion, onError)
        }
    }
    
    private func loadShopImage(shop: Shop, shopsNumber: Int, _ completion: @escaping (Void) -> Void, _ onError: @escaping ErrorClosure) {
        guard let imageUrl = shop.image?.url else { return }
        
        _loadShopImageInteractor.execute(url: imageUrl, completion: { (image: UIImage) in
            shop.image?.data = UIImagePNGRepresentation(image) as NSData?
            
            self.numberOfImages = self.numberOfImages + 1
            self._coreDataManager.saveContext(context: self._container.viewContext)
            
            if self.numberOfImages == shopsNumber && self.numberOfLogos == shopsNumber {
                completion()
            }
        }, onError: { (error: Error) in
            onError(error)
        })
    }
    
    func loadShopLogo(shop: Shop, shopsNumber: Int, _ completion: @escaping (Void) -> Void, _ onError: @escaping ErrorClosure) {
        guard let logoUrl = shop.logo?.url else { return }
        
        _loadShopImageInteractor.execute(url: logoUrl, completion: { (image: UIImage) in
            shop.logo?.data = UIImagePNGRepresentation(image) as NSData?
            
            self.numberOfLogos = self.numberOfLogos + 1
            self._coreDataManager.saveContext(context: self._container.viewContext)
            
            if self.numberOfImages == shopsNumber && self.numberOfLogos == shopsNumber {
                completion()
            }
        }, onError: { (error: Error) in
            onError(error)
        })
    }
}
