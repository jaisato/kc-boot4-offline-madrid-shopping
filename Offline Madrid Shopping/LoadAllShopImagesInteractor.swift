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
    
    public init(interactor: LoadShopImageInteractor, coreDataManager: CoreDataManager) {
        _loadShopImageInteractor = interactor
        _coreDataManager = coreDataManager
    }
    
    public func execute(from shopArray: [Shop], completion: @escaping (Void) -> Void, onError: @escaping ErrorClosure) {
        let container = _coreDataManager.persistentContainer(dbName: _coreDataManager.DB_NAME)
     
        let _ = shopArray.map({ (shop: Shop) -> Void in
            if let imageUrl = shop.image?.url {
                // Get shop image ...
                _loadShopImageInteractor.execute(url: imageUrl, completion: { (image: UIImage) in
                    shop.image = ShopImage(
                        url: imageUrl,
                        image: image,
                        context: container.viewContext
                    )
                    
                    self._coreDataManager.saveContext(context: container.viewContext)
                }, onError: { (error: Error) in
                    onError(error)
                })
            }
            
            if let logoUrl = shop.logo?.url {
                // Get shop logo ...
                _loadShopImageInteractor.execute(url: logoUrl, completion: { (image: UIImage) in
                    shop.logo = ShopImage(
                        url: logoUrl,
                        image: image,
                        context: container.viewContext
                    )
                    
                    self._coreDataManager.saveContext(context: container.viewContext)
                }, onError: { (error: Error) in
                    onError(error)
                })
            }
        })
    }
}
