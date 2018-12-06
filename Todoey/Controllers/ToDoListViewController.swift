//
//  ViewController.swift
//  Todoey
//
//  Created by Summer Crow on 20/11/2018.
//  Copyright © 2018 ghourab. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)

       
    }

    //MARK: - TABLEVIEW DATASOURCE METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
      
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    //MARK: - TABLEVIEW DELEGATE METHOD
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - ADD NEW ITEMS
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
    var textfield = UITextField()
    
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
        let saveAction = UIAlertAction(title: "Add Item", style: .default){
            action in
        
        guard let itemToAdd = textfield.text else {
            return
        }
        
        let newItem = Item(context: self.context)
            newItem.title = itemToAdd
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
        
            self.itemArray.append(newItem)
        
        self.saveItems()
            
        }
        
    let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    alert.addTextField{
        alertTextfield in
        alertTextfield.placeholder = "Create New Item"
        textfield = alertTextfield
        }
        
    
        
    self.present(alert, animated: true)
    }
    
    //MARK: - Model Manipulation Method
    func saveItems(){
        
        do {
           try context.save()
        } catch {
            print("error saving context: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
       
        //let request: NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        
            if let additionalPredicate = predicate {
                
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
            } else {
                request.predicate = categoryPredicate
            }
        
      
        do{
            itemArray = try context.fetch(request)
            
        } catch {
            print("error loading items: \(error)")
        }
        tableView.reloadData()
    }

    
}

//MARK:- SEARCH BAR METHODS

extension ToDoListViewController: UISearchBarDelegate {
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
   
    
   // let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, parentPredicate])
    
    //request.predicate = compoundPredicate
    
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
   loadItems(with: request, predicate: predicate)
    
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
