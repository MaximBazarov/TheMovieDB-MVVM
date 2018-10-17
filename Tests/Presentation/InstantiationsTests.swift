//
//  InstantiationsTests.swift
//  TheMovieDBTests
//
//  Created by Maksim Bazarov on 09.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import XCTest
@testable import TheMovieDB

class InstantiationsTests: XCTestCase {

   
    func testMovieDetailsViewControllerInstantiation() {
        let _ = MovieDetailsViewController.instantiate()
    }
    
    func testMoviesListViewControllerInstantiation() {
        let _ = MoviesListViewController.instantiate()
    }
        
}
