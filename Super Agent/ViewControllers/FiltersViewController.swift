//
//  FiltersViewController.swift
//  Super Agent
//
//  Created by Алексей Воронов on 01.02.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var filter: FilterSource?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let freeFiltersCount =  Constants.filtersSources.filter({$0.free == true}).count
        if indexPath.row == 0 {
            return
        } else if indexPath.row == freeFiltersCount + 1 {
            return
        } else {
            if indexPath.row > freeFiltersCount + 1 {
                filter = Constants.filtersSources.filter({$0.free == false})[indexPath.row - freeFiltersCount - 2]
                if UserDefaults.standard.bool(forKey: "isBuyed") {
                    goToFilter()
                } else {
                    performSegue(withIdentifier: "subscribe", sender: nil)
                }
                
            } else {
                filter = Constants.filtersSources.filter({$0.free == true})[indexPath.row - 1]
                goToFilter()
            }
        }
    }
    
    func goToFilter() {
        performSegue(withIdentifier: "filter", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if filter != nil {
            if let filterVC = segue.destination as? FilterViewController {
                filterVC.filter = self.filter
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Constants.filtersSources.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let freeFiltersCount =  Constants.filtersSources.filter({$0.free == true}).count
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "title") as! TitleTableViewCell
            cell.titleLabel.text = "Free lists"
            return cell
        } else if indexPath.row == freeFiltersCount + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "title") as! TitleTableViewCell
//            cell.titleLabel.text = "Premium lists"
            return cell
        } else {
            //print(indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FilterTableViewCell
            if indexPath.row > freeFiltersCount + 1 {
                let filter = Constants.filtersSources.filter({$0.free == false})[indexPath.row - freeFiltersCount - 2]
                if filter.activate { cell.statusView.backgroundColor = .white } else { cell.statusView.backgroundColor = .clear }
                cell.titleLabel.text = filter.name
                cell.descriptionLabel.text = filter.description
            } else {
                let filter = Constants.filtersSources.filter({$0.free == true})[indexPath.row - 1]
                if filter.activate { cell.statusView.backgroundColor = .white } else { cell.statusView.backgroundColor = .clear }
                cell.titleLabel.text = filter.name
                cell.descriptionLabel.text = filter.description
            }
            return cell
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subscribeButton: UIButton!
    
    @IBAction func close() {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        
        if UserDefaults.standard.bool(forKey: "isBuyed") {
            self.subscribeButton.isHidden = true
        }
    }

}
