//
//  FilterViewController.swift
//  Super Agent
//
//  Created by Алексей Воронов on 01.02.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import UIKit
import AIFlatSwitch
import SPAlert

class FilterViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var AIswitch: AIFlatSwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activateButton: UIButton!
    
    
    
    var filter: FilterSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = filter?.name

        self.showInfo()
    }
    
    func showInfo() {
        if filter?.activate ?? false {
            AIswitch.setSelected(true, animated: true)
            activateButton.setTitle("Disable", for: .normal)
        } else {
            AIswitch.setSelected(false, animated: true)
            activateButton.setTitle("Enable", for: .normal)
        }
        
        descriptionLabel.text = """
        Status: \(filter!.activate ? "Activated" : "Disabled")

        Version: \(filter!.version)

        Updated: \(filter!.dateFormatter.string(from: filter!.updateDate ?? Date()))

        Description: \(filter!.description)
        """
    }
    

    @IBAction func update() {
        filter?.updateList() { error in
            DispatchQueue.main.async {
                if error != nil {
                    self.alert(title: "error", message: error!.localizedDescription)
                } else {
                    self.showInfo()
                    SPAlert.present(title: "Updated", preset: .done)
                }
            }
        }
    }
    
    @IBAction func activate() {
        filter!.activate = !filter!.activate
        self.showInfo()
        BlockManager.shared.shouldReload = true
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }

}
