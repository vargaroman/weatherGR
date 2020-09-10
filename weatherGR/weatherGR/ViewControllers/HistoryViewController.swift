//
//  HistoryViewController.swift
//  weatherGR
//
//  Created by Roman Varga on 10/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit
import CoreData
class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var history: [NSManagedObject] = []
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"
        // Do any additional setup after loading the view.
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
