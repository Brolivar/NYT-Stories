//
//  ApiResponses.swift
//  NYT-Stories
//
//  Created by Jose Bolivar on 23/6/21.
//

import Foundation

struct APIStoriesResponse: Decodable {
    let status: String?
    let numResults: Int?
    let section: String?
    let results: [Story]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case numResults = "num_results"
        case section = "section"
        case results = "results"
    }
}

