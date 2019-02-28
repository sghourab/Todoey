//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Summer Crow on 04/12/2018.
//  Copyright © 2018 ghourab. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    // MARK: - Table view data source, to display all categories in our persistent container
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
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
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
    
        let saveAction = UIAlertAction(title: "Add", style: .default) {
            action in
            
        
            
        let newCategory = Category()
            
            newCategory.name = textfield.text!
            
            
        
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
        tableView.reloadData()
    
    }
    
}
