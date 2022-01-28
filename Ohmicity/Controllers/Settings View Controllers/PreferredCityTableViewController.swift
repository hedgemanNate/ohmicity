//
//  PreferredCityTableViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/6/21.
//

import UIKit

class PreferredCityTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func updateViews() {
        guard let preferredCity = currentUserController.currentUser?.preferredCity else { return }
        guard let index = settingsController.preferredCitiesArray.firstIndex(of: preferredCity) else {return}
        let indexPath = IndexPath(row: index, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settingsController.preferredCitiesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! PreferredCityTableViewCell
        
        cell.city = settingsController.preferredCitiesArray[indexPath.row]
        cell.selectionStyle = .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = settingsController.preferredCitiesArray[indexPath.row]
        currentUserController.preferredCity = city
    }

}
