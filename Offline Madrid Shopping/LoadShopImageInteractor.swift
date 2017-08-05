//
//  LoadShopImageInteractor.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 24/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit
import CoreData

public class LoadShopImageInteractor {
    private let _manager: ShopAPIManager
    private var _shopImage: ShopImage? = nil
    
    public init(manager: ShopAPIManager) {
        _manager = manager
    }
    
    public convenience init() {
        self.init(manager: ShopAPIManagerURLSessionImpl())
    }
    
    public func execute(shopImage: ShopImage, completion: @escaping (ShopImage) -> Void, onError: @escaping ErrorClosure) {
        self._shopImage = shopImage
        
        _manager.getShopImage(urlString: self._shopImage!.url!, completion: { (image: UIImage) in
            assert(Thread.current === Thread.main)
            
            if let imageData = UIImageJPEGRepresentation(image, 1) as NSData? {
                self._shopImage!.data = imageData
            }

            completion(self._shopImage!)

        }) { (error: Error) in
            onError(error)
        }
    }
}
