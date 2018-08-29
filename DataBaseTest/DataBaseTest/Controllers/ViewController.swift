//
//  ViewController.swift
//  DataBaseTest
//
//  Created by Denis Semerych on 06.06.2018.
//  Copyright © 2018 Denis Semerych. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var transferList = [FootballPlayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transferList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "name", for: indexPath)
        
        let footballPlayer = transferList[indexPath.row]
        
        cell.textLabel?.text = footballPlayer.name
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToDetails", sender: self)

        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField: UITextField?
        
        let alert = UIAlertController(title: "Add football player to list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Start watching", style: .default) { (action) in
            
            if textField?.text != "" {
                
                let footballPlayer = FootballPlayer(context: self.context)
                
                footballPlayer.name = textField?.text
                
                self.transferList.append(footballPlayer)
                
                self.saveData()
                
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadData() {
        
        let request: NSFetchRequest<FootballPlayer> = FootballPlayer.fetchRequest()
        
        do {
            try transferList = context.fetch(request)
        } catch {
            print("Error")
        }
    }
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("Error \(error)")
        }
        
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDetails" {
            let destanationVC = segue.destination as! DetailsController
            
            if let index = tableView.indexPathForSelectedRow {
            
            let footballPlayer = transferList[index.row]
            
                destanationVC.ageFP = footballPlayer.age
                destanationVC.heightFP = footballPlayer.height
                destanationVC.positionFP = footballPlayer.position
                destanationVC.statsFP = footballPlayer.stats
                destanationVC.weightFP = footballPlayer.weight
            
            }
        }
        
    }
    
   
}

