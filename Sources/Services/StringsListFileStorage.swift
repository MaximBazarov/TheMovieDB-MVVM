//
//  StringsListFileStorage.swift
//  TheMovieDB
//
//  Created by Maksim Bazarov on 08.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import Foundation

protocol ListStorageInterface {
    init(name: String)
    func save(_ data: [String])
    func load(thenDispatchOn queue: DispatchQueue, onComplete: @escaping ([String])->Void)
}


/// Simple storage for suggestions list
final class StringsListFileStorage {
    
    private let filename: String
    
    required init(name: String) {
        self.filename = name
    }
}

extension StringsListFileStorage: ListStorageInterface {
    
    private var fileURL: URL? {
        let dir = FileManager.SearchPathDirectory.cachesDirectory
        guard let url = FileManager.default.urls(for: dir, in: .userDomainMask).first else { return  nil }
        return url.appendingPathComponent(filename)
    }
    
    func save(_ data: [String]) {
        let encoder = JSONEncoder()
        guard let fileURL = fileURL else { return }
        DispatchQueue.global(qos: .background).async {
            guard let fileData = try? encoder.encode(data) else { return }
            FileManager.default.createFile(atPath: fileURL.path, contents: fileData, attributes: nil)
        }
    }
    
    func load(thenDispatchOn queue: DispatchQueue, onComplete: @escaping ([String])->Void) {
        guard let fileURL = fileURL else { return }
        DispatchQueue.global(qos: .background).async {
            guard let data = FileManager.default.contents(atPath: fileURL.path)
                , let list = try? JSONDecoder().decode([String].self, from: data)
                else { return }
            queue.async {
                onComplete(list)
            }
        }
    }
    
}
