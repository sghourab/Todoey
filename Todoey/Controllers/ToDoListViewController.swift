//
//  ViewController.swift
//  Todoey
//
//  Created by Summer Crow on 20/11/2018.
//  Copyright © 2018 ghourab. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    var toDoItems: Results<Item>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)
        tableView.separatorStyle = .none
        
        
        
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        
        guard let navBarHexCode = selectedCategory?.categoryCellBackgroundHex else { fatalError() }
        updateNavBarAppearance(withhexCode: navBarHexCode)
        
     
       
//
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBarAppearance(withhexCode: "00A6FF")
    
    }
    
    //MARK:- NAVIGATION BAR UI APPEARANCE FUNCTION
    
    func updateNavBarAppearance(withhexCode colorHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        
                guard let navTintColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
                navBar.barTintColor = navTintColor
        
                navBar.tintColor = ContrastColorOf(navTintColor, returnFlat: true)
        
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navTintColor, returnFlat: true)]
        
                searchBar.barTintColor = navTintColor
        
        
    }
        
    
    //MARK: - TABLEVIEW DATASOURCE METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
        
            let baseBackgroundColor = UIColor(hexString: selectedCategory!.categoryCellBackgroundHex)
            
            let totalNumberOfCells = toDoItems!.count
            let percentageToDarken = (CGFloat(indexPath.row) / (CGFloat(totalNumberOfCells ))) * 0.25
           
            
           
            cell.backgroundColor = baseBackgroundColor?.darken(byPercentage: CGFloat(percentageToDarken))
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:cell.backgroundColor!, isFlat: true)
            cell.textLabel?.text = item.title
            
            
            
            
            
            
        
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
      
        } else {
        cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //MARK: - TABLEVIEW DELEGATE METHOD
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
                }
            }
        
            tableView.reloadData()
        
        
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- DELETE DATA MODEL BY SWIPE
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.toDoItems?[indexPath.row] {
            do {try self.realm.write {
                self.realm.delete(itemForDeletion)
                }
            } catch {
                print("error deleting item by swipe action: \(error)")
            }
        }
    }
    //MARK: - ADD NEW ITEMS
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
    var textfield = UITextField()
    
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
        let saveAction = UIAlertAction(title: "Add Item", style: .default){
            action in
        
        
            if let currentCategory = self.selectedCategory {
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textfield.text!
                    newItem.dateCreated = Date()
//                    let backgroundCellColor = UIColor(hexString: self.selectedCategory?.categoryCellBackgroundHex ?? "00A6FF")
//                    newItem.itemCellBackgroundHex = backgroundCellColor?.lighten(byPercentage: 20.0)
                    currentCategory.items.append(newItem)
                    
                }
            } catch {
                print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
//            newItem.parentCategory = self.selectedCategory
//
//            self.itemArray.append(newItem)
        
      
            
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
   
    
    func loadItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

    }
    
}

//MARK:- SEARCH BAR METHODS

extension ToDoListViewController: UISearchBarDelegate {
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    
    tableView.reloadData()
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
