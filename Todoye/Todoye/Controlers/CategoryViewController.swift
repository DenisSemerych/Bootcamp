//
//  CategoryViewController.swift
//  Todoye
//
//  Created by Denis Semerych on 05.06.2018.
//  Copyright © 2018 Denis Semerych. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {

    var categories: Results<Category>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                
       loadData()
        
        tableView.separatorStyle = .none

    }

    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
 
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No data yet"
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].hexColor)
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor, isFlat: true)

        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            if textField.text != "" {
                
                let category = Category()
                category.hexColor = UIColor.randomFlat().hexValue()
                category.name = textField.text!
                
                
                self.save(category: category)
                
            }
        }
            
            alert.addTextField(configurationHandler: { (alertTextField) in
                alertTextField.placeholder = "Create new item"
                textField = alertTextField
            })
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
        }

    
    //MARK: - Data Manupulation Methods
    func  save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
                print("add!")
                }
        } catch {
            print("Error \(error)")
        }
        
        tableView.reloadData()

    }
    func loadData() {
      categories = realm.objects(Category.self)
    }
    
    override func updateModel(at indexPath: IndexPath) {
                            do {
                                try self.realm.write {
                                    if let selectedCategory = self.categories?[indexPath.row] {
                                        self.realm.delete(selectedCategory)
                                    }
                                }
                            } catch {
                                print("Error deleting")
                            }
        }

}


