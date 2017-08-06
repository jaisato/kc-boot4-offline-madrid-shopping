//
//  ShopAPIManagerURLSessionImpl.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit
import CoreData

public class ShopAPIManagerURLSessionImpl: ShopAPIManager {
    private let GET_SHOPS_URL = "http://madrid-shops.com/json_new/getShops.php"
    
    public func getShops(completion: @escaping GetShopJsonArrayCompletionClosure, onError: @escaping ErrorClosure) {
        guard let url = URL(string: self.GET_SHOPS_URL) else {
            let apiError = ShopAPIError.invalidURL("Invalid url \( self.GET_SHOPS_URL )")
            return onError(apiError)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                return onError(error)
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion([]) }
                return
            }
            
            do {
                let shopJsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! ShopJsonDict
                let shopJsonArray: ShopJsonArray = shopJsonDict["result"]!
                
                DispatchQueue.main.async {
                    completion(shopJsonArray)
                }
            } catch {
                onError(error)
            }
        }
        
        task.resume()
    }
    
    public func getShops(completion: @escaping GetShopArrayCompletionClosure, onError: @escaping ErrorClosure) {
        let error = ShopAPIError.saveError("TO DO: make models (Core Data) compatible!")
        onError(error)
    }
    
    public func getShopImage(urlString: String, completion: @escaping (UIImage) -> Void, onError: @escaping ErrorClosure) {
        // DispatchQueue.global().async {
        // DispatchQueue.global().sync {
            guard let url = URL(string: urlString) else {
                let apiError = ShopAPIError.invalidURL("Invalid image url \( urlString )")
                // DispatchQueue.main.sync {
                    onError(apiError)
                // }
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    // DispatchQueue.main.sync {
                        completion(image)
                    // }
                } else {
                    let apiError = ShopAPIError.downloadError("Error creating image")
                    // DispatchQueue.main.sync {
                        onError(apiError)
                    // }
                }
            } catch {
                let apiError = ShopAPIError.downloadError("Error downloading shop image \(error)")
                // DispatchQueue.main.sync {
                    onError(apiError)
                // }
            }
        // }
        
//        guard let url = URL(string: urlString) else {
//            let apiError = ShopAPIError.invalidURL("Invalid url \( urlString )")
//            onError(apiError)
//            return
//        }
//        
//        let session = URLSession.shared
//        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
//            if let error = error {
//                DispatchQueue.main.async { onError(error) }
//                return
//            }
//            
//            guard let imgData = data else {
//                let apiError = ShopAPIError.downloadError("NO image data")
//                DispatchQueue.main.async { onError(apiError) }
//                return
//            }
//            
//            DispatchQueue.main.async {
//                if let image = UIImage(data: imgData) {
//                    completion(image)
//                } else {
//                    let apiError = ShopAPIError.downloadError("Image creation error")
//                    onError(apiError)
//                }
//            }
//        }
//        
//        task.resume()
    }
    
    public func getAllShopImages(from shopArray: [Shop], completion: @escaping (UIImage) -> Void, onError: @escaping ErrorClosure) {
        
        let _ = shopArray.map { (shop: Shop) -> Void in
            if let imageUrl = shop.image?.url {
                self.getShopImage(urlString: imageUrl, completion: completion, onError: onError)
            }
        }
    }
    
    public func getAllShopLogos(from shopArray: [Shop], completion: @escaping (UIImage) -> Void, onError: @escaping ErrorClosure) {

        let _ = shopArray.map { (shop: Shop) -> Void in
            if let logoUrl = shop.logo?.url {
                self.getShopImage(urlString: logoUrl, completion: completion, onError: onError)
            }
        }
    }
    
    public func saveShop(shopJson: ShopJson, completion: @escaping (Shop) -> Void, onError: @escaping ErrorClosure) {
        let error = ShopAPIError.saveError("TO DO: implement on real server!")
        onError(error)
    }
    
    public func saveAllShop(shopJsonArray: ShopJsonArray, completion: @escaping ([Shop]) -> Void, onError: @escaping ErrorClosure) {
        let error = ShopAPIError.saveError("TO DO: implement on real server!")
        onError(error)
    }
}
