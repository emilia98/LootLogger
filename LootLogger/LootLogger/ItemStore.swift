//
//  ItemStore.swift
//  LootLogger
//
//  Created by Emilia Nedyalkova on 15.04.21.
//

import UIKit

class ItemStore {
    private var allItems = [Item]()
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = allItems[fromIndex]
        allItems.remove(at: fromIndex)
        allItems.insert(movedItem, at: toIndex)
    }
    
    func moveFavoriteItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }

        var favoriteItems = getFavoriteItems()
        let movedItem = favoriteItems[fromIndex]
        favoriteItems.remove(at: fromIndex)
        favoriteItems.insert(movedItem, at: toIndex)
        
        var favIndex = 0
        for (index, item) in allItems.enumerated() {
            if item.isFavorite {
                allItems[index] = favoriteItems[favIndex]
                favIndex += 1
            }
        }
    }
    
    func getAllItems() -> [Item] {
        return allItems
    }
    
    func getFavoriteItems() -> [Item] {
        return allItems.filter { $0.isFavorite }
    }
    
    var itemsCount: Int {
        return getAllItems().count
    }
    
    var favoriteItemsCount: Int {
        return getFavoriteItems().count
    }
    
    func getItem(_ row: Int) -> Item {
        return allItems[row]
    }
    
    func getFavoriteItem(_ row: Int) -> Item {
        return getFavoriteItems()[row]
    }
}
