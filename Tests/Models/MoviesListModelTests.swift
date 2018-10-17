//
//  MoviesListModelTests.swift
//  TheMovieDBTests
//
//  Created by Maksim Bazarov on 08.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import XCTest
@testable import TheMovieDB

class MoviesListModelTests: XCTestCase {

    func testLoadNext_firstTimeValidData_shouldReturn20Movies() {
        let exp = expectation(description: "Valid response")
        let sessionMock = URLSessionMock()
        sessionMock.completionData = JSONMocks.valid
        let apiMock = TheMovieDBAPI(session: sessionMock)
        let sut = PopularMoviesModel(api: apiMock)
        let _ = sut.state.subscribe { state in
            switch state {
            case .movies(let movies):
                if movies.count == 20 { exp.fulfill() }
            default: XCTFail("must be movies result")
            }
        }
        sut.load(page: 1)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    
    // MARK: Thread safety tests
    
    func testLoadNext_20TimesValidDataFromRandomThread_shouldReturnAllMoviesAndLastpageEquals20() {
        let exp = expectation(description: "Valid response")
        let sessionMock = URLSessionMock()
        sessionMock.completionData = JSONMocks.valid
        let apiMock = TheMovieDBAPI(session: sessionMock)
        let sut = PopularMoviesModel(api: apiMock)
        
        
        let _ = sut.state.subscribe { state in
            switch state {
            case .movies(let movies):
                if movies.count == 20*20, sut.lastPage == 20 { exp.fulfill() }
            default: XCTFail("must be movies result")
            }
        }
       
        DispatchQueue.concurrentPerform(iterations: 20) { iteration in
            sut.load(page: iteration+1)
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
}
