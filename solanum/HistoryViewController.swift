//
//  HistoryViewController.swift
//  solanum
//
//  Created by Cinq Technologies on 08/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit
import Foundation

class HistoryViewController: UITableViewController {
    
    var historyEntries:Array<Dictionary<String, Any>>?
    var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshData()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshData),
                                               name: NSNotification.Name(Strings.kWorkedNotification.rawValue),
                                               object: nil)
        
        self.dateFormatter.timeZone  = TimeZone.current
        self.dateFormatter.dateStyle = DateFormatter.Style.medium
        self.dateFormatter.timeStyle = DateFormatter.Style.short
        
        self.tableView.accessibilityLabel = "History List"
        self.tableView.isAccessibilityElement = true


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func refreshData() {
        self.historyEntries = UserDefaults.standard.object(forKey: Strings.kSettingsHistoryKey.rawValue) as? Array<Dictionary<String, Any>>
        self.tableView.reloadData()
    }
    
    // MARK: - Prepare for segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DetailsViewController {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)!
            if let row = self.historyEntries?[indexPath.row] {
                dest.details = row
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.historyEntries?.count {
            return count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "HistoryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        if let item = historyEntries?[indexPath.row] {
            let finishedAt:Date = item[Strings.kHistoryFinishTimeKey.rawValue] as! Date

            cell.textLabel?.text = item[Strings.kHistoryTaskNameKey.rawValue] as? String

            cell.detailTextLabel?.text = self.dateFormatter.string(from: finishedAt)
        }

        #if DEBUG
            cell.accessibilityLabel = "Section \(indexPath.section) Row \(indexPath.row)"
        #endif

        return cell

    }

 /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.historyEntries?.remove(at: indexPath.row)
        
        UserDefaults.standard.set(self.historyEntries, forKey: Strings.kSettingsHistoryKey.rawValue)
        UserDefaults.standard.synchronize()
        
        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }

    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
