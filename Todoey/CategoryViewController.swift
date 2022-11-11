//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nirav Desai on 10/11/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let search = UISearchController()
    override func viewDidLoad() {
        super.viewDidLoad()
//        search.searchResultsUpdater = self
//        search.searchBar.delegate = self
        navigationItem.searchController = search
        navigationItem.searchController?.searchBar.backgroundColor = .white
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadsArray()
    }
    
    // MARK: ADD NEW CATEGORIES.
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
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
    // MARK: DATA MANIPULATION METHOD.
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
        catch {
            print("Error fetching data from context \(error)")
        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        // ternary operator.
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    // MARK: Tableview Delegate Method
    
    
    
}
