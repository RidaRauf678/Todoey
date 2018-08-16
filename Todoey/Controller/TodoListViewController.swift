//
//  ViewController.swift
//  Todoey
//
//  Created by Tianna Henry-Lewis on 2018-08-13..
//  Copyright © 2018 Tianna Henry-Lewis. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
    }
    
    //MARK: - Tableview Datasource Methods
    
        //TODO: Declare numberOfRowsInSection here:
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemArray.count
        }
    
        //TODO: Declare cellForRowAtIndex here:
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
            
            let item = itemArray[indexPath.row]
        
            cell.textLabel?.text = item.title
            
            //Ternary Operator ==>
            //value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
            
//          The line above does the same thing as the code below, but uses the Ternary Operator to complete the task
//                if item.done == true {
//                    cell.accessoryType = .checkmark
//                } else {
//                    cell.accessoryType = .none
//                }
        
            return cell
        }
    
    //MARK: - TableView Delegate Methods
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            
            tableView.reloadData()
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
   
    //MARK: - Add New Items
    
        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
            var textField = UITextField()
            
            //Pop-Up (UIAlert Controller) to show and have a text field to be able to write a to do list item and append it to the itemArray
            let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                //What will happen once th user clicks the add item button on the UIAlert
                //Add item user entered and add the item to the itemArray
                
                let newItem = Item()
                newItem.title = textField.text!
                
                self.itemArray.append(newItem)
                
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
                self.tableView.reloadData()
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create New Item"
                textField = alertTextField
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        }
    
    
}

