//
//  ShopAPIManagerURLSessionImpl.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import Foundation

public class ShopAPIManagerURLSessionImpl: ShopAPIManager {
    private let GET_SHOPS_URL = "http://madrid-shops.com/json_new/getShops.php"
    
    public func getShops(completion: @escaping GetShopsCompletionClosure, onError: ErrorClosure? = nil) throws {
        guard let url = URL(string: self.GET_SHOPS_URL) else {
            let apiError = ShopAPIError.invalidURL("Invalid url \( self.GET_SHOPS_URL )")
            
            if let error = onError {
                return error(apiError)
            }
            
            throw apiError
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error, let errorClosure = onError {
                return errorClosure(error)
            }
            
            guard let data = data else { return }
            
            do {
                let shopJsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! ShopJsonDict
                let shopJsonArray: ShopJsonArray = shopJsonDict["result"]!
                
                let shops: [Shop] = shopJsonArray.map({ (shopJson: ShopJson) -> Shop in
                    return Shop(from: shopJson)
                })
                
                completion(shops)
                
            } catch {
                print("Error in getShops: " + error.localizedDescription)
                
                if let errorClosure = onError {
                    errorClosure(error)
                }
            }
        }
        
        task.resume()
    }
}
