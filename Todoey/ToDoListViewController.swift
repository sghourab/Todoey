//
//  ViewController.swift
//  Todoey
//
//  Created by Summer Crow on 20/11/2018.
//  Copyright © 2018 ghourab. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray: [String] = ["work", "clean", "mother", "wife"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK - TABLEVIEW DATASOURCE METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK - TABLEVIEW DELEGATE METHOD
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
 //MARK - ADD NEW ITEMS
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
    var textfield = UITextField()
    
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Add Item", style: .default){
            action in
        
        guard let itemToAdd = textfield.text else {
            return
        }
            self.itemArray.append(itemToAdd)
            self.tableView.reloadData()
            
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
    
}

