//
//  MovieCellViewModel.swift
//  MovieBuzz
//
//  Created by pranay chander on 15/07/23.
//

import Foundation

struct MovieCellViewModel {
    let movie: Movie
    
    func getImageData() async ->  Data? {
        let data = try? await MovieBuzzAPIClient.shared.downloadImage(url: movie.poster)
        return data
    }
    
    func getCastAndCrew() -> String {
        return movie.actors + ", " + movie.director
    }
}
