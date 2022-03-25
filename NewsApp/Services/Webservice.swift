//
//  Webservice.swift
//  NewsApp
//
//  Created by Mohammad Azam on 6/30/21
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidData
    case decodingError
}

class Webservice {
    
    static let shared = Webservice()
    private init() {}
    
    func fetchSources(url: URL?) async throws -> [NewsSource] {
        guard let url = url else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        let newsSourceResponse = try JSONDecoder().decode(NewsSourceResponse.self, from: data)
        return newsSourceResponse.sources
    }
    
    
    func fetchNewsAsync(by sourceId: String, url: URL?) async throws -> [NewsArticle] {
        return try await withCheckedThrowingContinuation { continuation in
            fetchNews(by: sourceId, url: url) { result in
                switch result {
                case let .success(newsArticle):
                    continuation.resume(returning: newsArticle)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // For practicing continuation, I'm pretending that the below function is being exposed by a third party SDK and I don't have access to modify it.
    private func fetchNews(by sourceId: String, url: URL?, completion: @escaping (Result<[NewsArticle], NetworkError>) -> Void) {
        
        guard let url = url else {
            completion(.failure(.badUrl))
            return
        }
            
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
            let newsArticleResponse = try? JSONDecoder().decode(NewsArticleResponse.self, from: data)
            completion(.success(newsArticleResponse?.articles ?? []))
            
        }.resume()
    }
}
