//
//  SaveShopsInteractor.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 23/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import Foundation
import CoreData

public class SaveShopInteractor {
    private let _manager: ShopAPIManager
    
    public init(manager: ShopAPIManager) {
        _manager = manager
    }
    
    public convenience init() {
        self.init(manager: ShopAPIManagerCoreDataImpl(coreDataManager: CoreDataManager()))
    }
    
    public func execute(from shopJson: ShopJson, completion: @escaping (Shop) -> Void, onError: @escaping ErrorClosure) {
        _manager.saveShop(shopJson: shopJson, completion: { (shop: Shop) in
            assert(Thread.current === Thread.main)
            completion(shop)
        }) { (error: Error) in
            onError(error)
        }
    }
}
