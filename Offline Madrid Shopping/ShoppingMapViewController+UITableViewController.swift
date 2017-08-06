//
//  ShoppingMapViewController+UITableViewController.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 6/8/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit
import Foundation

extension ShoppingMapViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: TableView Data Source
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ShopCell
        
        let shop = self.fetchedResultsController.object(at: indexPath)
        cell.loadData(shop: shop)
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shop = self.fetchedResultsController.object(at: indexPath)
        goToShopDetail(shop: shop)
    }
}
