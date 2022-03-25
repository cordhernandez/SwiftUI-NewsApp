//
//  NewsSource.swift
//  NewsApp
//
//  Created by Cordero Hernandez on 3/24/22.
//

import Foundation

struct NewsSourceResponse: Decodable {
    let sources: [NewsSource]
}

struct NewsSource: Decodable {
    let id: String
    let name: String
    let description: String
}
