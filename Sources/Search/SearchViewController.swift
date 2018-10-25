//
//  SearchViewController.swift
//  TheMovieDB
//
//  Created by Maksim Bazarov on 08.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: SearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onSuggestionsUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
}


// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        toggleView(isHidden: false)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        toggleView(isHidden: true)
        if let query = searchBar.text, !query.isEmpty {
            viewModel.search(query)
        }
        return true
        
    }
    
    func toggleView(isHidden hidden: Bool) {
        UIView.animate(withDuration: 0.24) {
            self.tableView.isHidden = hidden
            self.view.isHidden = hidden
        }
    }
}


// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.suggestionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Force unwrap because there is no good way to handle this mistakes
        let suggestion = viewModel.suggestion(at: indexPath.row)!
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell")!
        cell.textLabel?.text = suggestion
        return cell
    }
    
}


// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectSuggestion(at: indexPath.row)
        searchBar?.text = viewModel.suggestion(at: indexPath.row)
        searchBar?.endEditing(true)
    }
}


// MARK: - Instantiation
extension SearchViewController {
    
    /// Instntiates view controller and setups all the dependencies
    static func instantiate(
        withViewModel viewModel: SearchViewModel,
        asChildOf parent: UIViewController
        ) -> SearchViewController {
        let vc = UIStoryboard(name: "Search", bundle: nil)
            .instantiateInitialViewController() as! SearchViewController
        
        vc.viewModel = viewModel
        parent.addChild(vc)
        vc.didMove(toParent: parent)
        parent.view.addSubview(vc.view)
        parent.view.bringSubviewToFront(vc.view)
        vc.view.isHidden = true
        
        return vc
    }
}
