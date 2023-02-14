//
//  BaseStatsTableViewCell.swift
//  pokedex
//
//  Created by yxgg on 04/02/23.
//

import UIKit

class BaseStatsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleStatLabel: UILabel!
    @IBOutlet weak var scoreStatLabel: UILabel!
    @IBOutlet weak var barStatProgressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureViews(statistic: PokemonStats) {
        self.titleStatLabel.text = statistic.stat?.name?.capitalized
        self.scoreStatLabel.text = String(statistic.baseStat ?? 0)
        
        let resultStat = Float(statistic.baseStat ?? 0) / Float(255)
        barStatProgressView.progress = resultStat
        switch statistic.baseStat ?? 0 {
        case 0...50:
            barStatProgressView.tintColor = .systemRed
        case 51...100:
            barStatProgressView.tintColor = .systemYellow
        case 101...255:
            barStatProgressView.tintColor = .systemGreen
        default:
            break
        }
    }
}
