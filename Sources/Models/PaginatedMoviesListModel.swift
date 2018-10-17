//
//  PaginatedMoviesListModel.swift
//  TheMovieDB
//
//  Created by Maksim Bazarov on 09.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import Foundation


/// Protocol for search and popular movies models since they both consist of paginated movies list
protocol PaginatedMoviesListModel {
    func load(page: Int)
    var state: Observable<PaginatedMoviesListState> { get }
    var lastPage: Int {get}
}
