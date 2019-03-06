//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Summer Crow on 04/12/2018.
//  Copyright © 2018 ghourab. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.separatorStyle = .none
        
               
        
        
    }
    // MARK: - Table view data source, to display all categories in our persistent container
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        if let cellBackgroundColor = UIColor(hexString: categories?[indexPath.row].categoryCellBackgroundHex ?? "00A6FF") {
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].categoryCellBackgroundHex ?? "00A6FF")
        cell.textLabel?.textColor = ContrastColorOf(cellBackgroundColor, returnFlat: true)
        
        }
        
        return cell
    }
    //MARK: - Tableview Delegate Methods. What should happen when we click on one of the cell in the category table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
           destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    //MARK: - Data Manipulation Methods, save data and load data
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("error saving category context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self)
    }
    
    //MARK:- Delete Data Model by Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                        }
                            } catch {
                        print("error deleting category by swipe action: \(error)")
                    }
                }
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
    
        let saveAction = UIAlertAction(title: "Add", style: .default) {
            action in
            
        let cellBackgroundColorHexValue = UIColor.randomFlat.hexValue()
            
            
        let newCategory = Category()
            
            newCategory.name = textfield.text!
            newCategory.categoryCellBackgroundHex = cellBackgroundColorHexValue
            
            
        
            self.save(category: newCategory)
        
        }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
        alert.addAction(saveAction)
    
        alert.addAction(cancelAction)
        
        alert.addTextField {
            alertTextField in
            alertTextField.placeholder = "Create New Category"
            textfield = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        //tableView.reloadData()
    
    }
    
}

