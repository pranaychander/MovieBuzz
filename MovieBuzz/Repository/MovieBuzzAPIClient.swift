//
//  MovieBuzzAPIClient.swift
//  MovieBuzz
//
//  Created by pranay chander on 15/07/23.
//

import Foundation

final class MovieBuzzAPIClient {
    private let cache = NSCache<NSString, NSData>()
    static let shared = MovieBuzzAPIClient()
    private init() {}
 
    func downloadImage(url: String) async throws -> Data? {
        let cacheID = NSString(string: url)
        if let cachedData = cache.object(forKey: cacheID) {
            return Data(cachedData)
        } else{
            if let url = URL(string: url) {
                let (data, _) = try await URLSession.shared.data(from: url)
                self.cache.setObject(data as NSData, forKey: cacheID)
                return data
            } else {
                // NetworkError is a custom error
                return nil
            }
        }
    }
}
