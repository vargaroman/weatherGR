//
//  HistoryViewController.swift
//  weatherGR
//
//  Created by Roman Varga on 10/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit
import CoreData
class HistoryViewController: BasicViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var history: [NSManagedObject] = []
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryTableViewCell
        cell.cityLabel.text = history[indexPath.row].value(forKey: "text") as? String
        cell.dateLabel.text = history[indexPath.row].value(forKey: "date") as? String
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCoreData()
    }
    
    func fetchCoreData() {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
          }
        let managedContext =
            appDelegate.persistentContainer.viewContext
          
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "SearchHistory")
          
        do {
            history = try managedContext.fetch(fetchRequest)
            self.tableView.reloadData()
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
          }
        if let filter = searchBar.text {
            if filter == ""{
                fetchCoreData()
            } else {
                let managedContext =
                appDelegate.persistentContainer.viewContext
              
                let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: "SearchHistory")
                let predicate = NSPredicate(format: "text CONTAINS[c] %@", filter)
                fetchRequest.predicate = predicate
                do {
                    history = try managedContext.fetch(fetchRequest)
                    self.tableView.reloadData()
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                  }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
