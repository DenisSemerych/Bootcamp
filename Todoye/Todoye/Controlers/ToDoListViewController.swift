//
//  ViewController.swift
//  Todoye
//
//  Created by Denis Semerych on 25.05.2018.
//  Copyright © 2018 Denis Semerych. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var toDoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
       

        title = selectedCategory?.name
        
        guard let color = selectedCategory?.hexColor else {fatalError()}
        
        updateNavBar(withColor: color)
        
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withColor: "1D9BF6")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {

            cell.textLabel?.text = item.title
        
            cell.backgroundColor = UIColor(hexString: selectedCategory?.hexColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat((toDoItems!.count)))

            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
                
            cell.accessoryType = item.done ? .checkmark : .none
        
        } else {
            
            cell.textLabel?.text = "No items added"
        }
        

        return cell
        
        
    }
    
    @IBAction func barButtonPresse(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new item to list", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add item", style: .default) { (action) in

            if textField.text != "" {

                if let curentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let item = Item()
                            item.title = textField.text!
                            curentCategory.items.append(item)
                            print(item.dateCreated)
                        }
                    } catch {
                        print("Error saving items \(error)")
                    }
                }
            
                self.tableView.reloadData()

            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    
                }
            } catch {
                print("\(error)")
            }
        }
        
        tableView.reloadData()

    }
    //MARK: - NavBar Method
    
    func updateNavBar(withColor color: String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("NavController doesn`t exist`s")}

        
            
            navBar.barTintColor = UIColor(hexString: color)
            
            searchBar.barTintColor = UIColor(hexString: color)
            
            navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: color), isFlat: true)
            
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: color), isFlat: true)]
        
    }
 

    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
   
    }
    
    override func updateModel(at indexPath: IndexPath) {
            do {
                try self.realm.write {
                    if let selectedItem = self.toDoItems?[indexPath.row] {
                        self.realm.delete(selectedItem)
                    }
                }
            } catch {
                print("Error deleting")
        }
    }
}

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


