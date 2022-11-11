//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    // File path is used to store data for UserDefualts.
    
    // writing data to location where datafilePath is located
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Items.plist")
    // creating a new file to store data inside it.
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let search = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        navigationItem.searchController = search
        navigationItem.searchController?.searchBar.backgroundColor = .white
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadsArray()
    }
    
    // MARK: Tableview DataSourse Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // ternary operator.
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    // MARK: Tableview Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // it gives an animation of selection
        tableView.deselectRow(at: indexPath, animated: true)
        // added checkmark functionality to cell[row]
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        savedata()
    }
    // Add note for items
    
    @IBAction func AddNote(_ sender: UIBarButtonItem) {
        var txtfield = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add  Item", style: .default){ (action) in
            // what will happen when user clicks the add btn item on our UIAlert
            print(txtfield.text!)
            let newItem = Item(context: self.context)
            newItem.title = txtfield.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.savedata()
        }
        alert.addTextField(){ (alertTextfield) in
            alertTextfield.placeholder = "create new item"
            txtfield = alertTextfield
        }
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    func savedata(){
        //        let encoder = PropertyListEncoder()
        do{
            try context.save()
        }
        catch{
            print("Error Saving Item Array, \(error)")
        }
        self.tableView.reloadData()
    }
    func loadsArray(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        // make sure to specify data while requesting data <...>
        //this is neccesary.
            do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error fetching data from context \(error)")
        }
    }
}
//MARK: Search Bar Delegate.
// UISearchControllerDelegate - Presenting and dismissing the search controller

extension TodoListViewController: UISearchBarDelegate ,UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController)// will update on each letter.
        {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINs %@", searchController.searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
            loadsArray(with: request)
        print(searchController.searchBar.text!)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)// will edit when search btn pressed.
    {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINs %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do{
            itemArray = try context.fetch(request)
            
        }
        catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}
