//
//  ShopAPIManager.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import Foundation

public typealias ErrorClosure = (Error) -> Void
public typealias GetShopsCompletionClosure = ([Shop]) -> Void

public protocol ShopAPIManager {
    func getShops(completion: @escaping GetShopsCompletionClosure, onError: ErrorClosure?) throws
}
