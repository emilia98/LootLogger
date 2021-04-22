//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Emilia Nedyalkova on 11.04.21.
//

import UIKit

enum ItemType {
    case all, favorite
}

class ItemsViewController : UITableViewController {
    var itemStore: ItemStore!
    @IBOutlet var segmentedControl: UISegmentedControl!
    private var itemType = ItemType.all
    
    let segmentItems: [(name: String, itemType: ItemType)] = [
        ("All", .all),
        ("Favorites", .favorite)
    ]
    
    override func viewDidLoad() {
        for (seg, item) in segmentItems.enumerated() {
            segmentedControl.setTitle(item.name, forSegmentAt: seg)
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self,
                                   action: #selector(itemTypeChanged(_:)),
                                   for: .valueChanged)
    }
    
    @IBAction func addNewItem(_ sender: UIButton) {
        if itemType == .favorite {
            return
        }
        
        let newItem = itemStore.createItem()
        if let index = itemStore.getAllItems().firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        sender.setTitle(isEditing ? "Edit" : "Done", for: .normal)
        setEditing(!isEditing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        switch itemType {
        case .all:
            return itemStore.itemsCount
        case .favorite:
            return itemStore.favoriteItemsCount
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item: Item
        
        switch itemType {
        case .all:
            item = itemStore.getItem(indexPath.row)
        case .favorite:
            item = itemStore.getFavoriteItem(indexPath.row)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = (item.isFavorite ? "⭐️\t" : "") + item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item: Item
            switch itemType {
            case .all:
                item = itemStore.getItem(indexPath.row)
            case .favorite:
                item = itemStore.getFavoriteItem(indexPath.row)
            }
            
            itemStore.removeItem(item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        switch itemType {
        case .all:
            itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
        case .favorite:
            itemStore.moveFavoriteItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = itemStore.getAllItems()[indexPath.row]
        let actionTitle = item.isFavorite ? "Remove" : "Favorite"
        
        return UISwipeActionsConfiguration(actions: [
               UIContextualAction(style: .normal, title: actionTitle) {
                [weak self] _,_,_ in
                item.isFavorite.toggle()
                tableView.reloadRows(at: [indexPath], with: .automatic)
               }
        ])
    }
    
    @objc
    func itemTypeChanged(_ segControl: UISegmentedControl) {
        if segmentItems.indices ~= segControl.selectedSegmentIndex {
            itemType = itemType == .all ? .favorite : .all
            tableView.reloadData()
        }
    }
}
