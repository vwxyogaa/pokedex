//
//  BaseStatsViewController.swift
//  pokedex
//
//  Created by yxgg on 03/02/23.
//

import UIKit

class BaseStatsViewController: UIViewController {
    @IBOutlet weak var baseStatsTableView: UITableView!
    
    var pokemonStats = [PokemonStats]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBaseStatsTableView()
    }
    
    private func configureBaseStatsTableView() {
        baseStatsTableView.register(UINib(nibName: "BaseStatsTableViewCell", bundle: nil), forCellReuseIdentifier: "BaseStatsTableViewCell")
        baseStatsTableView.dataSource = self
        baseStatsTableView.delegate = self
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension BaseStatsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonStats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BaseStatsTableViewCell", for: indexPath) as? BaseStatsTableViewCell else { return UITableViewCell() }
        cell.configureViews(statistic: pokemonStats[indexPath.row])
        return cell
    }
}
