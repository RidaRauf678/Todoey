//
//  ViewController.swift
//  Todoey
//
//  Created by Tianna Henry-Lewis on 2018-08-13..
//  Copyright © 2018 Tianna Henry-Lewis. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
            
//            context.delete(itemArray[indexPath.row])
//            itemArray.remove(at: indexPath.row)
            
            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            
            saveItems()
            
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
                
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
        
                self.itemArray.append(newItem)
                
                self.saveItems()
                
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create New Item"
                textField = alertTextField
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        }
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error Saving Context: \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, ])
//
//        request.predicate = compoundPredicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
    
        }
    
}



//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    
    func searchBar (_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        
        }
    }
}
