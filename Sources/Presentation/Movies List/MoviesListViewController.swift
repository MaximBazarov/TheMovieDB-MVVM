//
//  MoviesListViewController.swift
//  TheMovieDB
//
//  Created by Maksim Bazarov on 08.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController {

    @IBOutlet weak var emptyDatasetLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MoviesListViewModel!
    private var cancelSubscription: CancelSubscription?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MovieCell.nib, forCellReuseIdentifier: MovieCell.identifier)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 198
        
        cancelSubscription = viewModel.state.subscribe(on: .main) { [weak self] state in
            self?.handle(state)
        }
        
        
        viewModel.loadNextPage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    
    /// Changes the representation regarding the view model state
    func handle(_ state: MoviesListViewModel.State) {
        switch state {
            
        case .loading, .empty:
            tableView.isHidden = true
            emptyDatasetLabel.isHidden = false

        case .error(let message):
            tableView.isHidden = false
            emptyDatasetLabel.isHidden = true

            let alert = UIAlertController(
                title: "ERROR",
                message: message,
                preferredStyle: .alert
            )
            present(alert, animated: true)
            
        case .movies:
            tableView.isHidden = false
            emptyDatasetLabel.isHidden = true
            tableView.reloadData()
        }
    }
    
    deinit {
        cancelSubscription?()
    }
}

extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.moviesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Force unwrap because there is no good way to handle this mistakes
        let movie = viewModel.movie(at: indexPath.row)!
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier) as! MovieCell
        cell.configure(with: movie)
        return cell
    }
    
    
}

extension MoviesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.moviesCount - 7 {
            viewModel.loadNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectMovie(at: indexPath.row)
    }
}


// MARK: - Instantiation
extension MoviesListViewController {
    
    /// Instntiates view controller and setups all the dependencies
    static func instantiate() -> MoviesListViewController {
        let vc = UIStoryboard(name: "MoviesList", bundle: nil)
            .instantiateInitialViewController() as! MoviesListViewController
        return vc
    }
}
