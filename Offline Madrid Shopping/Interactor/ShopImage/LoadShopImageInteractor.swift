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
    
    public init(manager: ShopAPIManager) {
        _manager = manager
    }
    
    public convenience init() {
        self.init(manager: ShopAPIManagerURLSessionImpl())
    }
    
    public func execute(shopImage: ShopImage, completion: @escaping (ShopImage) -> Void, onError: @escaping ErrorClosure) {
        // The image is captured per call rather than kept in an instance
        // property: one interactor is shared by every download, so with more
        // than one request in flight a stored property pointed at whichever
        // image was requested last and each result was written into it.
        guard let urlString = shopImage.url else {
            return onError(ShopAPIError.invalidURL("Shop image without url"))
        }
        
        _manager.getShopImage(urlString: urlString, completion: { (image: UIImage) in
            assert(Thread.current === Thread.main)
            
            shopImage.data = UIImageJPEGRepresentation(image, 1) as NSData?
            completion(shopImage)
            
        }) { (error: Error) in
            onError(error)
        }
    }
}
