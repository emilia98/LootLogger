//
//  ItemStore.swift
//  LootLogger
//
//  Created by Emilia Nedyalkova on 15.04.21.
//

import UIKit

class ItemStore {
    var allItems = [
        [Item](),
        [Item]()
    ]
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        let section = newItem.valueInDollars >= 50 ? 0 : 1
        allItems[section].append(newItem)
        return newItem
    }
    
    func removeItem(_ item: Item, _ section: Int) {
        allItems[section].removeAll { $0 == item }
    }
    
    func moveItem(from fromIndex: IndexPath, to toIndex: IndexPath) {
        if fromIndex.section != toIndex.section || fromIndex.row == toIndex.row {
            return
        }
        
        let section = fromIndex.section
        move(section: section, fromPos: fromIndex.row, toPos: toIndex.row)
    }
    
    private func move(section: Int, fromPos: Int, toPos: Int) {
        let (start, end, step) = toPos > fromPos ? (fromPos, toPos - 1, 1) : (fromPos, toPos + 1, -1)
        let elementToMove = allItems[section][fromPos]
        
        for i in stride(from: start, through: end, by: step) {
            allItems[section][i] = allItems[section][i + step]
        }
        
        allItems[section][toPos] = elementToMove
    }
}
