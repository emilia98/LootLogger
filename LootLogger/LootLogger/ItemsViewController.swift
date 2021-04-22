//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Emilia Nedyalkova on 11.04.21.
//

import UIKit

class ItemsViewController : UITableViewController {
    var itemStore: ItemStore!
    private var showEmptyMessage = true
    
    @IBAction func addNewItem(_ sender: UIButton) {
        let newItem = itemStore.createItem()
        
        if itemStore.allItems.count == 1 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        if let index = itemStore.allItems.firstIndex(of: newItem) {
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
        let itemsCount = itemStore.allItems.count
        
        if itemsCount == 1 && showEmptyMessage || itemsCount == 0 && !showEmptyMessage {
            showEmptyMessage = false
            return 0
        }
        return itemsCount == 0 ? 1 : itemsCount
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let itemsCount = itemStore.allItems.count
        
        if cell.backgroundView != nil {
            cell.textLabel?.isHidden = false
            cell.detailTextLabel?.isHidden = false
            cell.backgroundView = nil
        }
        
        if itemsCount > 0 {
            let item = itemStore.allItems[indexPath.row]
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        } else {
            cell.textLabel?.isHidden = true
            cell.detailTextLabel?.isHidden = true
            cell.backgroundView = setEmptyMessage(cell)
        }
        
        return cell
    }
    
    private func setEmptyMessage(_ cell: UITableViewCell) -> UILabel {
        let frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height)
        let messageLabel = UILabel(frame: frame)
        messageLabel.text = "No items"
        messageLabel.textColor = UIColor.black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return messageLabel
    }
    
    override func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        if itemStore.allItems.isEmpty {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            itemStore.removeItem(item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        if itemStore.allItems.isEmpty {
            showEmptyMessage = true
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}
