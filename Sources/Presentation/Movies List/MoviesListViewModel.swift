//
//  MoviesListViewModel.swift
//  TheMovieDB
//
//  Created by Maksim Bazarov on 08.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import UIKit

class MoviesListViewModel {
    
    // MARK: Interface
    
    enum State {
        case loading
        case empty
        case error(String)
        case movies
    }
    
    // Output
    let state: Observable<State>
    
    // Input
    var onSelectMovie: ((Movie) -> Void)?
    
    // MARK: - Implementation
    private let model: PaginatedMoviesListModel?
    private var cancelSubscription: CancelSubscription?
    private var movies: [Movie] {
        if case .movies(let movies)? = model?.state.value {
            return movies
        }
        return []
    }
    
    init(model: PaginatedMoviesListModel) {
        self.model = model
        self.state = Observable(State.movies)
        
        // binding
        self.cancelSubscription = model.state.subscribe(on: .main) { [weak self] state in
            guard let self = self else { return }
            switch state {                
            case .loading:
                self.state.value = .loading
            case .movies(let movies):
                if movies.count > 0 { self.state.value = .movies}
                else {self.state.value = .empty }
            case .pageError(_): break
                
            case .fatalError(let message):
                self.state.value = .error(message)
            }
        }
    }
    
    deinit {
        cancelSubscription?()
    }
    
    func movie(at index: Int) -> Movie? {
        guard 0..<movies.count ~= index else { return nil }
        return movies[index]
    }
    
    var moviesCount: Int {
        return movies.count
    }
    
    func selectMovie(at index: Int) {
        guard let movie = movie(at: index) else { return }
        onSelectMovie?(movie)
    }
    
    func loadNextPage() {
        guard let model = model else { return }
        model.load(page: model.lastPage + 1)
    }
}
