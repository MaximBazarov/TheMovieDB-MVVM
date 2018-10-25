//
//  PopularMoviesModel.swift
//  TheMovieDB
//
//  Created by Maksim Bazarov on 09.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import Foundation

final class PopularMoviesModel {
    
    private let moviesListPaginator = MoviesListPaginator()
    private let api: TheMovieDBAPI
    
    init(api: TheMovieDBAPI) {
        self.api = api
    }
    
}


// MARK: - PaginatedMoviesListModel

extension PopularMoviesModel: PaginatedMoviesListModel {
    
    var lastPage: Int {
        return moviesListPaginator.lastPage
    }
    
    var state: Observable<PaginatedMoviesListState> {
        return moviesListPaginator.state
    }
    
    func load(page: Int)  {
        api.discover(page: page, success: {[moviesListPaginator] response in
            moviesListPaginator.add(
                movies: response.results.map(TheMovieDBAPI.toMovie),
                toPage: page
            )
            
            }, failure: { [moviesListPaginator] error in
                moviesListPaginator.handleAPIError(error)
        })
    }
}
