//
//  LoadShopImageInteractor.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 24/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit

public class LoadShopImageInteractor {
    private let _manager: ShopAPIManager
    
    public init(manager: ShopAPIManager) {
        _manager = manager
    }
    
    public convenience init() {
        self.init(manager: ShopAPIManagerURLSessionImpl())
    }
    
    public func execute(url: String, completion: @escaping (UIImage) -> Void, onError: @escaping ErrorClosure) {
        
        _manager.getShopImage(urlString: url, completion: { (image: UIImage) in
            assert(Thread.current === Thread.main)
            completion(image)
            
        }) { (error: Error) in
            onError(error)
        }
    }
}
