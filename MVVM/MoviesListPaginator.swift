//
//  MoviesListModel.swift
//  TheMovieDB
//
//  Created by Maksim Bazarov on 08.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import Foundation

enum PaginatedMoviesListState {
    case loading
    case movies([Movie])
    case fatalError(String)
    case pageError(String)
}



/// Movies list paginator is a model collects all the movies handles errors and provides an observable state.
class MoviesListPaginator {
    
    var state = Observable(PaginatedMoviesListState.movies([]))
    
    var lastPage: Int {
        return lock.sync { return self._lastPage }
    }
    
    private var movies: [Int: [Movie]] = [:] { // page : movie
        didSet {
            state.value = .movies(flattened(movies))
        }
    }
    
    private let lock = DispatchQueue(label: "com.PaginatedMoviesListModel.dispatchQueue")
    private var _lastPage: Int = 0
    
    // Adds movies list into the page
    // and calls the callback with flattened movies list
    func add(movies moviesToAdd: [Movie], toPage page: Int) {
        lock.async { [weak self] in
            guard let self = self else { return }
            var newMovies = self.movies
            newMovies[page] = moviesToAdd
            self._lastPage = max(self._lastPage, page)
            self.movies = newMovies
        }
    }
    
    func clear() {
        lock.async { [weak self] in
            guard let self = self else { return }
            self.movies = [:]
            self._lastPage = 0
        }
        
    }
    
    func handleAPIError(_ error: TheMovieDBAPI.APIError) {
        switch error {
        case .parsingError(_), .curruptedData, .emptyResult:
            // we have nothing to do with error here
            // if anything has went wrong user can't do anything with it
            // so just report some problem
            state.value = .pageError("There are no more pages")
            
        case .networkError(let error):
            // this means that we have some global error so we should allert
            state.value = .fatalError(error.localizedDescription)
        case .badQuery(let query):
            let searchFor = query.isEmpty ? "the empty query" : "\"\(query)\""
            state.value = .fatalError("You can't search for \(searchFor) ")
        }
        
    }
    
    private func flattened(_ movies: [Int: [Movie]]) -> [Movie] {
        var result = [Movie]()
        for index in movies.keys.sorted() {
            guard let pageMovies = movies[index] else { continue }
            result += pageMovies
        }
        return result
    }

}


