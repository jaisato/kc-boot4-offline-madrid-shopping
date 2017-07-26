//
//  ShopAPIManager.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit

public typealias ErrorClosure = (Error) -> Void
public typealias GetShopsCompletionClosure = (ShopJsonArray) -> Void

public protocol ShopAPIManager {
    func getShops(completion: @escaping GetShopsCompletionClosure, onError: @escaping ErrorClosure)
    func getShops(completion: @escaping GetShopsCompletionClosure) throws
    func saveShop(shopJson: ShopJson, completion: @escaping (Shop) -> Void, onError: @escaping ErrorClosure)
    func saveAllShop(shopJsonArray: ShopJsonArray, completion: @escaping ([Shop]) -> Void, onError: @escaping ErrorClosure)
    func getShopImage(urlString: String, completion: @escaping (UIImage) -> Void, onError: @escaping ErrorClosure)
    func getAllShopImages(from shopArray: [Shop], completion: @escaping (UIImage) -> Void, onError: @escaping ErrorClosure)
    func getAllShopLogos(from shopArray: [Shop], completion: @escaping (UIImage) -> Void, onError: @escaping ErrorClosure)
}
