//
//  CategoryTableViewController.swift
//  Todoer
//
//  Created by George Ananda on 01/12/18.
//  Copyright © 2018 George Ananda. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()

    var categoriesArray: Results<Category>? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategories()
    }

    // MARK: - Add new category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { action in
            let newCategory = Category()
            newCategory.name = textField.text!

            self.save(category: newCategory)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "No Categories added yet"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray?[indexPath.row]
        }
    }
    
    // MARK: - Data manipulation methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category to context \(error)")
        }
        
        self.tableView.reloadData()
    }

    func loadCategories() {
        categoriesArray = realm.objects(Category.self)
    }
}
