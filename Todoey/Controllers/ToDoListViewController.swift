//
//  ViewController.swift
//  Todoey
//
//  Created by Summer Crow on 20/11/2018.
//  Copyright © 2018 ghourab. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print(dataFilePath)
        let newItem = Item()
        newItem.title = "work"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "clean"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "mother"
        itemArray.append(newItem3)
        
        let newItem4 = Item()
        newItem4.title = "wife"
        itemArray.append(newItem4)

        loadItems()
    }

    //MARK - TABLEVIEW DATASOURCE METHODS
    
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
        
//
//
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
//
//
        return cell
    }
    
    //MARK - TABLEVIEW DELEGATE METHOD
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        
        
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
            let newItem = Item()
            newItem.title = itemToAdd
        
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
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error encoding itemArray: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
            if let dataFilePath = dataFilePath, let data = try? Data(contentsOf: dataFilePath) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item: \(error)")
            }
        }
            
    
    }
}

