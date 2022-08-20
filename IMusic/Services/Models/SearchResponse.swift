//
//  SearchResponse.swift
//  IMusic
//
//  Created by Andriy on 20.08.2022.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Trask]
}

struct Trask: Decodable {
    var trackName: String
    var artistName: String
    var collectionName: String
    var artworkUrl100: String?
    var previewUrl: String?
}
