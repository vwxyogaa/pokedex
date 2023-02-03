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
    
    func configureViews(statistic: PokemonStats, baseStat: Int?) {
        self.titleStatLabel.text = statistic.stat?.name?.capitalized
        self.scoreStatLabel.text = String(statistic.baseStat ?? 0)
        
        let maxStat = (baseStat ?? 0) + 20
        let resultStat = Float(statistic.baseStat ?? 0) / Float(maxStat)
        barStatProgressView.progress = resultStat
        barStatProgressView.tintColor = resultStat > 0.6 ? .green : .red
    }
}
