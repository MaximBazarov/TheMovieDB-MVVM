//
//  RootCoordinator.swift
//  TheMovieDB
//
//  Created by Maksim Bazarov on 08.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import UIKit


/// Root Coordinator
/// The coordinator responsible for coordinating the screen flow.
/// In this case, it only creates the screens and presents them in the tab bar.
final class RootCoordinator {
    
    private let api = TheMovieDBAPI(session: URLSession.shared)
    private let suggestionsService = SuggestionsService(
        capacity: 10,
        storage: StringsListFileStorage(name: "suggestions.json")
    )
    
    
    weak var window: UIWindow!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    
    // MARK: Presentation
    
    
    /// Presents the tab bar
    func presentMainScreen() {
        guard let window = window else { return }
        window.rootViewController = makeTabBarViewController()
        window.makeKeyAndVisible()
    }
    
    
    // MARK: View Controllers Assemblies
    
    
    /// Makes a tab bar with the popular movies and the search screen
    ///
    /// - Returns: tab bar as a UIViewController
    private func makeTabBarViewController() -> UIViewController {
        let tabBarViewController = UITabBarController()
        tabBarViewController.viewControllers = [
            makePopularScreen(),
            makeSearchScreen()
        ]
        
        
        return tabBarViewController
    }
    
    
    /// Builds a popular movie screen with all the dependencies
    ///
    /// - Returns: Ready to use popular movies screen as UIViewController
    private func makePopularScreen() -> UIViewController {
        
        // reusing of the MoviesListViewController
        let popularViewController: MoviesListViewController = {
            let vc = MoviesListViewController.instantiate()
            vc.title = "Popular"
            vc.tabBarItem.image = UIImage(named: "popcorn-outline-ic")
            vc.tabBarItem.selectedImage = UIImage(named: "popcorn-filled-ic")
            return vc
        }()
        
       
        let detailsScreen = MovieDetailsViewController.instantiate()
        let popularMoviesModel = PopularMoviesModel(api: api)
        let popularMoviesViewModel =  MoviesListViewModel(model: popularMoviesModel)
        popularViewController.viewModel = popularMoviesViewModel
        
        let navigation = popularViewController.wrappedInNavigationController()
        
        popularMoviesViewModel.onSelectMovie = { [weak navigation] movie in
            detailsScreen.movie = movie
            navigation?.pushViewController(detailsScreen, animated: true)
        }
        
        return navigation
    }
    
    
    
    /// Builds a search screen with all the dependencies
    ///
    /// - Returns: Ready to use search screen as UIViewController
    private func makeSearchScreen() -> UIViewController {
        
        // Building search results controller
        let searchResultsViewController: MoviesListViewController = {
            // reusing of the MoviesListViewController
            let vc = MoviesListViewController.instantiate()
            vc.title = "Search"
            vc.tabBarItem.image = UIImage(named: "magnifying_glass-ic")
            vc.tabBarItem.selectedImage = UIImage(named: "magnifying_glass-thick-ic")
            return vc
        }()
        let searchResultsModel = SearchModel(api: api, suggestionsService: suggestionsService)
        let searchResultsViewModel = MoviesListViewModel(model: searchResultsModel)
        searchResultsViewController.viewModel = searchResultsViewModel

        // Setup on select movie callback
        let navigation = searchResultsViewController.wrappedInNavigationController()
        let detailsScreen = MovieDetailsViewController.instantiate()
        searchResultsViewModel.onSelectMovie = { [weak navigation] movie in
            detailsScreen.movie = movie
            navigation?.pushViewController(detailsScreen, animated: true)
        }

        // Building Search Screen
        let searchViewModel = SearchViewModel(
            suggestionsService: suggestionsService,
            searchModel: searchResultsModel
        )

        let searchViewController = SearchViewController.instantiate(
            withViewModel: searchViewModel,
            asChildOf: searchResultsViewController
        )
       
        searchResultsViewController.navigationItem.titleView = searchViewController.searchBar

        return navigation
    }
    
}

private extension UIViewController {
    
    
    /// Wraps the view controller in navigation controller and
    /// copies the title and tab bar item
    ///
    /// - Returns: UINavigationController
    func wrappedInNavigationController() -> UINavigationController {
        let nc = UINavigationController(rootViewController: self)
        nc.title = self.title
        nc.tabBarItem = self.tabBarItem
        return nc
    }
    
}
