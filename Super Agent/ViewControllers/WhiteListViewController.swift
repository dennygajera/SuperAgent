//
//  WhiteListViewController.swift
//  Super Agent
//
//  Created by Алексей Воронов on 01.02.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import UIKit

class WhiteListViewController: UIViewController, UITableViewDataSource, DomainCellDelegate {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func deleteAction(id: Int) {
        var domains = BlockManager.shared.trustDomains
        domains.remove(at: id)
        BlockManager.shared.trustDomains = domains
        tableView.reloadData()
        BlockManager.shared.shouldReload = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BlockManager.shared.trustDomains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DomainCell
        cell.id = indexPath.row
        cell.title.text = BlockManager.shared.trustDomains[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
    @IBOutlet weak var domainField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        tableView.dataSource = self
        
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func addAction() {
        if domainField.text == nil { return }
        if domainField.text == "" { return }
        if !domainField.text!.contains(".") { self.alert(title: "error", message: "enter the domain in the format: domain.com"); return }
        var domains = BlockManager.shared.trustDomains
        domains.append(domainField.text!)
        BlockManager.shared.trustDomains = domains
        tableView.reloadData()
        domainField.text = ""
        
        BlockManager.shared.shouldReload = true
    }
    
    
    @IBAction func close() {
        self.navigationController?.popViewController(animated: true)
    }

}
