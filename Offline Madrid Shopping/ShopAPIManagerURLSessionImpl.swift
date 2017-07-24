//
//  ShopAPIManagerURLSessionImpl.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit

public class ShopAPIManagerURLSessionImpl: ShopAPIManager {
    private let GET_SHOPS_URL = "http://madrid-shops.com/json_new/getShops.php"
    
    public func getShops(completion: @escaping GetShopsCompletionClosure, onError: @escaping ErrorClosure) {
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
    
    public func getShops(completion: @escaping GetShopsCompletionClosure) throws {
        var apiError: ShopAPIError? = nil
        
        guard let url = URL(string: self.GET_SHOPS_URL) else {
            apiError = ShopAPIError.invalidURL("Invalid url \( self.GET_SHOPS_URL )")
            throw apiError!
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                apiError = ShopAPIError.downloadError("Error downloading Shops: \( error )")
                return print("getShops: " + error.localizedDescription)
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
                apiError = ShopAPIError.jsonError("Error decoding json of Shops: \( error )")
                return print("getShops: " + error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    public func getShopImage(urlString: String, completion: @escaping (UIImage) -> Void, onError: @escaping ErrorClosure) {
        guard let url = URL(string: urlString) else {
            let apiError = ShopAPIError.invalidURL("Invalid url \( urlString )")
            return onError(apiError)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                return onError(error)
            }
            
            guard let data = data else {
                let apiError = ShopAPIError.downloadError("NO image data")
                return onError(apiError)
            }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        
        task.resume()
    }
    
    public func saveShop(shopJson: ShopJson, completion: @escaping (Shop) -> Void, onError: @escaping ErrorClosure) {
        let error = ShopAPIError.saveError("TO DO: implement on real server!")
        onError(error)
    }
}
