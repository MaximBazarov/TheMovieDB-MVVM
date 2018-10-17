//
//  SuggestionsModelTests.swift
//  TheMovieDBTests
//
//  Created by Maksim Bazarov on 08.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import XCTest
@testable import TheMovieDB

class SuggestionsModelTests: XCTestCase {
    
    class FakeListStorage: ListStorageInterface {
        func load(thenDispatchOn queue: DispatchQueue, onComplete: @escaping ([String]) -> Void) {
            onComplete(list)
        }
        
        var list = [String]()
        required init(name: String) {}
        
        func save(_ data: [String]) {}
    }

    func testAdd_searchQuery_mustBeAddedInSuggestions() {
        let fakeStorage = FakeListStorage(name: "test")
        let sut = SuggestionsService(capacity: 1, storage: fakeStorage)
        sut.add(search: "test")
    }

    func testAdd_Capacity1FullList_Persisted3_mustKeepOnlyLast1() {
        let fakeStorage = FakeListStorage(name: "test")
        fakeStorage.list = ["1", "2", "3"]
        let sut = SuggestionsService(capacity: 1, storage: fakeStorage)
        XCTAssertEqual(sut.suggestions.value, ["3"])
    }

    func testAdd_2SearchQueriesToFullList_mustKeepOnlyLast1Plus2Added() {
        let fakeStorage = FakeListStorage(name: "test")
        fakeStorage.list = ["1", "2", "3"]
        let sut = SuggestionsService(capacity: 3, storage: fakeStorage)
        sut.add(search: "4")
        sut.add(search: "5")
        XCTAssertEqual(sut.suggestions.value, ["3", "4" ,"5"])
    }

    func testAdd_3SearchQueriesToFullList_mustKeepOnlyLast3() {
        let fakeStorage = FakeListStorage(name: "test")
        fakeStorage.list = ["1", "2", "3"]
        let sut = SuggestionsService(capacity: 3, storage: fakeStorage)
        sut.add(search: "4")
        sut.add(search: "5")
        sut.add(search: "6")
        XCTAssertEqual(sut.suggestions.value, ["4", "5" ,"6"])
    }

    func testAdd_3SameSearchQueriesToFullList_mustKeepOnlyOneNew() {
        let fakeStorage = FakeListStorage(name: "test")
        fakeStorage.list = ["1", "2", "3"]
        let sut = SuggestionsService(capacity: 3, storage: fakeStorage)
        sut.add(search: "4")
        sut.add(search: "4")
        sut.add(search: "4")
        XCTAssertEqual(sut.suggestions.value, ["2", "3" ,"4"])
    }

}
