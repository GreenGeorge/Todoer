//
//  ViewController.swift
//  Todoer
//
//  Created by George Ananda on 28/11/18.
//  Copyright © 2018 George Ananda. All rights reserved.
//

import UIKit
import RealmSwift

class TodoTableViewController: UITableViewController {

    let realm = try! Realm()
    var todoItems: Results<Item>? {
        didSet {
            self.tableView.reloadData()
        }
    }

    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
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
                try realm.write {
                    item.done = !item.done
                }
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

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
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
