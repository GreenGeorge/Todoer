//
//  ViewController.swift
//  Todoer
//
//  Created by George Ananda on 28/11/18.
//  Copyright © 2018 George Ananda. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController {

    var itemsArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find George"
        itemsArray.append(newItem)
        
        if let items = defaults.array(forKey: "TodoItemsArray") as? [Item] {
            itemsArray = items
        }
    }
    
    // MARK: - Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemsArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDo Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            let newItem = Item()
            newItem.title = textField.text!
            self.itemsArray.append(newItem)
            self.defaults.set(self.itemsArray, forKey: "TodoItemsArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    


}

