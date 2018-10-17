//
//  SearchViewModel.swift
//  TheMovieDB
//
//  Created by Maksim Bazarov on 09.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import Foundation

final class SearchViewModel {

    // Output
    var onSuggestionsUpdate: (() -> Void)?

    // MARK: - Implementation
    private let searchModel: SearchModel
    private var cancelSubscription: CancelSubscription?
    private var suggestions = [String]()

    init(
        suggestionsService: SuggestionsService,
        searchModel: SearchModel
        ) {
        self.searchModel = searchModel
        self.cancelSubscription = suggestionsService
            .suggestions.subscribe(on: .main) { [weak self] suggestions in
                guard let self = self else { return }
                self.suggestions = suggestions.filter{!$0.isEmpty}.reversed()
                self.onSuggestionsUpdate?()
        }
    }
    
    deinit { cancelSubscription?() }
    
    // MARK: - Suggestions data source
    func suggestion(at index: Int) -> String? {
        guard 0..<suggestions.count ~= index else { return nil }
        return suggestions[index]
    }
    
    var suggestionsCount: Int {
        return suggestions.count
    }
    
    func selectSuggestion(at index: Int) {
        guard let suggestion = suggestion(at: index) else { return }
        searchModel.search(query: suggestion)
    }

    func search(_ query: String) {
        searchModel.search(query: query)
    }

}


