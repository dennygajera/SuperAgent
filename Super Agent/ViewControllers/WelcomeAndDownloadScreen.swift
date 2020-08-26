//
//  ViewController.swift
//  Super Agent
//
//  Created by Алексей Воронов on 30.01.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import UIKit

class WelcomeAndDownloadScreen: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    
    let filters = Constants.filtersSources
    var downloaded = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func mainAction() {
        print(BlockManager.shared.isFiltersDownloaded())
        if !downloaded {
            mainButton.loadingIndicator(show: true)
            
            DispatchQueue.global().async {
                for filter in self.filters {
                    self.descriptionLabel.changeText(text: "Downloading filter: \(filter.name)")
                    let semaphore = DispatchSemaphore(value: 0)
                    filter.updateList() { error in
                        if error == nil { semaphore.signal() } else {
                            self.alert(title: "Error", message: error?.localizedDescription ?? "")
                            semaphore.signal()
                        }
                    }
                    semaphore.wait()
                    sleep(1)
                }
                DispatchQueue.main.async {
                    self.finishDownload()
                }
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func finishDownload() {
        downloaded = true
        mainButton.setTitle("Continue", for: .normal)
        descriptionLabel.changeText(text: "Download complited")
        mainButton.loadingIndicator(show: false)
    }


}

