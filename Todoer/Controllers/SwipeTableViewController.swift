//
//  SwipeTableViewController.swift
//  Todoer
//
//  Created by George Ananda on 02/12/18.
//  Copyright © 2018 George Ananda. All rights reserved.
//

import UIKit
import SwipeCellKit
import Chameleon

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80
        self.tableView.separatorStyle = .none
    }
    
    // MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "delete") { action, indexPath in
            
            self.updateModel(at: indexPath)
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        print("deleting cell")
    }
    
    // MARK: Nav bar setup methods
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist")}
        
        guard let tint = UIColor(hexString: colorHexCode) else { fatalError() }
        let contrastColor = ContrastColorOf(tint, returnFlat: true)
        
        let textColorAttribute = [NSAttributedString.Key.foregroundColor : contrastColor]
        
        navBar.barTintColor = tint
        navBar.tintColor = contrastColor
        navBar.largeTitleTextAttributes = textColorAttribute
        navBar.titleTextAttributes = textColorAttribute
    }

}
