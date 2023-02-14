//
//  MovesViewController.swift
//  pokedex
//
//  Created by yxgg on 03/02/23.
//

import UIKit

class MovesViewController: UIViewController {
    @IBOutlet weak var movesTableView: UITableView!
    
    var pokemonMoves = [PokemonMoves]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMovesTableView()
    }
    
    private func configureMovesTableView() {
        movesTableView.register(UINib(nibName: "MovesTableViewCell", bundle: nil), forCellReuseIdentifier: "MovesTableViewCell")
        movesTableView.dataSource = self
        movesTableView.delegate = self
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MovesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonMoves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovesTableViewCell", for: indexPath) as? MovesTableViewCell else { return UITableViewCell() }
        let moves = pokemonMoves[indexPath.row]
        cell.configureViews(name: moves.move?.name?.capitalized ?? "")
        return cell
    }
}
