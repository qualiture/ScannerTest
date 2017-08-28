//
//  ScannerTestController.swift
//  ScannerTest
//
//  Created by Robin van het Hof on 20/04/2017.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

import SAPFiori

class ScannerTestController: UITableViewController, UISearchResultsUpdating {

    var searchController: FUISearchController?
    var scannedBarcodes: [String] = []
    var filteredBarcodes: [String] = []
    var isFiltered: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: "FUIObjectTableViewCell")

        searchController = FUISearchController(searchResultsController: nil)
        searchController!.searchResultsUpdater = self
        searchController!.searchBar.placeholderText = "Search The List"
        
        searchController!.searchBar.isBarcodeScannerEnabled = true
        searchController!.searchBar.barcodeScanner?.scanResultTransformer = { (scanString) -> String in
            self.scannedBarcodes.append(scanString)
            return scanString
        }
        
        tableView.tableHeaderView = searchController?.searchBar
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
        return isFiltered ? self.filteredBarcodes.count : self.scannedBarcodes.count
    }

    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchString = searchController.searchBar.text, !searchString.isEmpty else {
            self.isFiltered = false
            self.filteredBarcodes.removeAll()
            self.tableView.reloadData()
            return
        }
        
        self.isFiltered = true
        self.filteredBarcodes = scannedBarcodes.filter({
            return $0.localizedCaseInsensitiveContains(searchString)
        })
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FUIObjectTableViewCell", for: indexPath)
        guard let objectCell = cell as? FUIObjectTableViewCell else {
            return cell
        }
        objectCell.headlineText = isFiltered ? filteredBarcodes[indexPath.row] : scannedBarcodes[indexPath.row]
        objectCell.statusText = String(indexPath.row)
        
        return objectCell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
