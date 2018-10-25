//
//  SearchModel.swift
//  TheMovieDB
//
//  Created by Maksim Bazarov on 09.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import Foundation

final class SearchModel {
    
    private let moviesListPaginator = MoviesListPaginator()
    private let api: TheMovieDBAPI
    private var query = ""
    private var suggestionsService: SuggestionsService
    
    init(api: TheMovieDBAPI, suggestionsService: SuggestionsService) {
        self.suggestionsService = suggestionsService
        self.api = api
    }
    
    func search(query: String) {
        self.query = query
        moviesListPaginator.clear()
        load(page: 1)
    }
    
}

extension SearchModel: PaginatedMoviesListModel {
    
    var lastPage: Int {
        return moviesListPaginator.lastPage
    }
    
    var state: Observable<PaginatedMoviesListState> {
        return moviesListPaginator.state
    }
    
    func load(page: Int)  {
        guard !self.query.isEmpty else { return }
        let query = self.query
        api.search(query: query, page: page, success: {[moviesListPaginator, suggestionsService] response in
            moviesListPaginator.add(
                movies: response.results.map(TheMovieDBAPI.toMovie),
                toPage: page
            )
            suggestionsService.add(search: query)
            
            }, failure: { [moviesListPaginator] error in
                moviesListPaginator.handleAPIError(error)
        })
    }
}
