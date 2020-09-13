//
//  HistoryViewController.swift
//  weatherGR
//
//  Created by Roman Varga on 10/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit
import CoreData

protocol HistoryRowPressedProtocolDelegate {
    func historyRowPressed(placeName: String)
}

class HistoryViewController: BasicViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var history: [NSManagedObject] = []
    var historyArray: [History] = []
    var historyPressedDelegate: HistoryRowPressedProtocolDelegate?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryTableViewCell
        cell.cityLabel.text = historyArray[indexPath.row].city
        cell.dateLabel.text = historyArray[indexPath.row].date
        
        
        self.getPlaceForecast(placeName: self.historyArray[indexPath.row].city) { (image) in
            DispatchQueue.main.sync {
                cell.currentForecastImageView.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        historyPressedDelegate?.historyRowPressed(placeName: historyArray[indexPath.row].city)
        self.tabBarController?.selectedIndex = 0
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
          
        do {
            history = try managedContext.fetch(fetchRequest)
            coreDataToUniqueArray()
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
    }
    
    func coreDataToUniqueArray() {
        historyArray.removeAll()
        for row in history {
            if let city = row.value(forKey: "text") as? String, let date = row.value(forKey: "date") as? String {
                historyArray.append(History(city: city, date: date))
            }
        }
        historyArray = Array(historyArray.removeDuplicates().prefix(20))
        self.tableView.reloadData()
    }
    
    func getPlaceForecast(placeName: String, completionHandler: @escaping(UIImage)->Void){
        var image = UIImage()
        NetworkManager().getActualWeather(placeName: placeName.folding(options: .diacriticInsensitive, locale: .current)){ (weather) in
            if let weatherForecast = weather.weather?.first?.main{
                image = UIImage(named: weatherForecast.getForecastIcon()) ?? UIImage()
                completionHandler(image)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.backgroundColor = UIColor.clear
        self.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Enter city...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.primaryColor])
        self.searchBar.searchTextField.backgroundColor = UIColor.lightNavyColor
        self.searchBar.searchTextField.textColor = UIColor.primaryColor

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
                    coreDataToUniqueArray()
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
