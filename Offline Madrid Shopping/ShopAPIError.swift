//
//  ShopAPIError.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import Foundation

enum ShopAPIError: Error {
    case invalidURL(String)
    case downloadError(String)
    case jsonError(String)
    case saveError(String)
}
