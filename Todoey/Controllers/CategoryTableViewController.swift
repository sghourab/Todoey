//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Summer Crow on 04/12/2018.
//  Copyright © 2018 ghourab. All rights reserved.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let categoryContex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    // MARK: - Table view data source, to display all categories in our persistent container
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    //MARK: - Tableview Delegate Methods. What should happen when we click on one of the cell in the category table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
           destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    //MARK: - Data Manipulation Methods, save data and load data
    
    func saveCategories(){
        do {
            try categoryContex.save()
        }
        catch {
            print("error saving category context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(from request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArray = try categoryContex.fetch(request)
        } catch {
            print("error loading category context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
    
        let saveAction = UIAlertAction(title: "Add", style: .default) {
            action in
            
        
            
        let newCategory = Category(context: self.categoryContex)
            
            newCategory.name = textfield.text
            
            self.categoryArray.append(newCategory)
        
            self.saveCategories()
        
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
