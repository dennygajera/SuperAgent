//
//  DomainCell.swift
//  Super Agent
//
//  Created by Алексей Воронов on 01.02.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import UIKit

class DomainCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    var delegate: DomainCellDelegate?
    var id = 0
    
    @IBAction func deleteAction() {
        delegate?.deleteAction(id: id)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol DomainCellDelegate {
    func deleteAction(id: Int)
}
