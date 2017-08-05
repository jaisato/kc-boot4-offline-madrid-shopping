//
//  SaveAllShopsInteractor.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 26/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import Foundation
import CoreData

public class SaveAllShopsInteractor {
    private let _manager: ShopAPIManager
    
    public init(manager: ShopAPIManager) {
        _manager = manager
    }
    
    public convenience init() {
        self.init(manager: ShopAPIManagerCoreDataImpl(coreDataManager: CoreDataManager()))
    }
    
    public func execute(from shopJsonArray: ShopJsonArray, completion: @escaping ([Shop]) -> Void, onError: @escaping ErrorClosure) {
        _manager.saveAllShop(shopJsonArray: shopJsonArray, completion: { (shops: [Shop]) in
            assert(Thread.current === Thread.main)
            completion(shops)
        }) { (error: Error) in
            onError(error)
        }
    }
}
