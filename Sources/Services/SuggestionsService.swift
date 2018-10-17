//
//  SuggestionsService.swift
//  TheMovieDB
//
//  Created by Maksim Bazarov on 08.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import Foundation


/// Service which follows the logic of adding suggestions,
/// skipping not unique queries, and keeps capacity removing old queries.
final class SuggestionsService {
    
    private let storageName = "search-suggestions"
    private(set) var suggestions = Observable([String]())
    
    private let storage: ListStorageInterface
    
    
    init(capacity: Int, storage: ListStorageInterface) {
        self.suggestions.value = Array(repeating: "", count: capacity)
        self.storage = storage
        self.loadSuggestions()
    }
    
    func add(search query: String) {
        guard !suggestions.value.contains(query) else { return }
        var new = [query] + suggestions.value.reversed()
        if new.count > suggestions.value.count { _ = new.popLast() }
        new.reverse()
        suggestions.value = new
        storage.save(new)
    }
    
    private func loadSuggestions() {
        storage.load(thenDispatchOn: .main) { [weak self] list in
            guard let self = self else { return }
            let capacity = self.suggestions.value.count
            self.suggestions.value = Array(list.suffix(capacity))
        }
    }
    

}
