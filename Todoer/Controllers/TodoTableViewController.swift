//
//  TodoTableViewController.swift
//  Todoer
//
//  Created by George Ananda on 28/11/18.
//  Copyright © 2018 George Ananda. All rights reserved.
//

import UIKit
import RealmSwift
import Chameleon

class TodoTableViewController: SwipeTableViewController {

    @IBOutlet weak var itemSearchBar: UISearchBar!
    
    let db = LocalDB.shared

    var todoItems: Results<Item>? {
        didSet { self.tableView.reloadData() }
    }

    var selectedCategory: Category? {
        didSet { loadItems() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colorHex = selectedCategory?.backgroundColor else { fatalError() }
        updateNavBar(withHexCode: colorHex)

        title = selectedCategory!.name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    // MARK: Nav bar setup methods
    override func updateNavBar(withHexCode colorHexCode: String) {
        super.updateNavBar(withHexCode: colorHexCode)

        guard let tint = UIColor(hexString: colorHexCode) else { fatalError() }
        itemSearchBar.barTintColor = tint
    }
    
    // MARK: - Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.backgroundColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(
                todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }

            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
    
    // MARK: - Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try self.db.updateItem(item, operation: { item in item.done = !item.done
                })
            } catch {
                print("Error saving done status \(error)")
            }
        }
        self.tableView.reloadData()
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDo Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { action in

            if let selectedCategory = self.selectedCategory {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                do {
                    try self.db.addItemToCategory(item: newItem, category: selectedCategory)
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model manipulation methods
    func loadItems() {
        self.todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try db.deleteItem(itemForDeletion)
            } catch {
                print("Error deleting item \(error)")
            }
        }
    }

}

// MARK: - Search bar methods
extension TodoTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
