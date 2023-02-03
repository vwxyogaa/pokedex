//
//  MovesTableViewCell.swift
//  pokedex
//
//  Created by yxgg on 04/02/23.
//

import UIKit

class MovesTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureViews(name: String) {
        titleLabel.text = name
    }
}
