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
            // The error paths end in a UIAlertController, so they have to reach
            // the caller on the main queue just like the success path does.
            if let error = error {
                DispatchQueue.main.async { onError(error) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion([]) }
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                guard let shopJsonDict = jsonObject as? ShopJsonDict,
                    let shopJsonArray = shopJsonDict["result"] else {
                    let apiError = ShopAPIError.jsonError("Unexpected shops response format")
                    DispatchQueue.main.async { onError(apiError) }
                    return
                }

                DispatchQueue.main.async {
                    completion(shopJsonArray)
                }
            } catch {
                DispatchQueue.main.async { onError(error) }
            }
        }
        
        task.resume()
    }
    
    public func getShops(completion: @escaping GetShopArrayCompletionClosure, onError: @escaping ErrorClosure) {
        let error = ShopAPIError.saveError("TO DO: make models (Core Data) compatible!")
        onError(error)
    }
    
    public func getShopImage(urlString: String, completion: @escaping (UIImage) -> Void, onError: @escaping ErrorClosure) {
        print("Downloading image: \(urlString)")
        guard let url = URL(string: urlString) else {
            let apiError = ShopAPIError.invalidURL("Invalid image url \( urlString )")
            return onError(apiError)
        }
        
        // This used to be Data(contentsOf:) on the main thread: three blocking
        // downloads per shop, one after another, with the UI frozen for all of
        // them. Download asynchronously and hand the result back on the main
        // queue, which is what the interactors assert on.
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            let result: () -> Void
            if let error = error {
                result = { onError(ShopAPIError.downloadError("Error downloading shop image \(error)")) }
            } else if let data = data, let image = UIImage(data: data) {
                result = { completion(image) }
            } else {
                result = { onError(ShopAPIError.downloadError("Error creating image")) }
            }
            DispatchQueue.main.async(execute: result)
        }
        task.resume()
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
