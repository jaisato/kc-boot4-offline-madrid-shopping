//
//  LoadShopsInteractor.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import Foundation

public class LoadShopsInteractor {
    private let _manager: ShopAPIManager
    
    public init(manager: ShopAPIManager) {
        _manager = manager
    }
    
    public convenience init() {
        self.init(manager: ShopAPIManagerURLSessionImpl())
    }
    
    public func execute(completion: @escaping GetShopsCompletionClosure, onError: @escaping ErrorClosure) {
        _manager.getShops(completion: { (shops: ShopJsonArray) in
            assert(Thread.current === Thread.main)
            
            completion(shops)
        }) { (error: Error) in
            onError(error)
        }
    }
}
