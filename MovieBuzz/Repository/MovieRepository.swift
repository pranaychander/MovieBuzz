//
//  MovieRepository.swift
//  MovieBuzz
//
//  Created by pranay chander on 14/07/23.
//

import Foundation

final class MovieRepository {
    var movies: [Movie]? = nil
    
    init() {
        guard let jsonFile = Bundle.main.url(forResource: "moviesDB", withExtension: "json") else {
            return
        }
        
        guard let data = try? Data(contentsOf: jsonFile) else {
            return
        }
        guard let fetchedMovies = try? JSONDecoder().decode([Movie].self, from: data) else {
            return
        }
        movies = fetchedMovies.filter { $0.type == .movie }
    }
    
    func getItemsForCategory(for category: MovieDisplayCategories) -> [String] {
        switch category {
        case .year:
            let allYears = Set(movies?.compactMap { $0.year } ?? [])
            return Array(allYears)
        case .genre:
            let allMovieGenres = movies?.compactMap { $0.genre } ?? []
            let allGenres = allMovieGenres.flatMap { $0.components(separatedBy: ",")}
            let genres = allGenres.map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
            return Array(Set(genres))
        case .directors:
            let allMovieDirectors = movies?.compactMap { $0.director } ?? []
            let allDirectors = allMovieDirectors.flatMap { $0.components(separatedBy: ",")}
            let directors = allDirectors.map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
            return Array(Set(directors))
        case .actors:
            let allMoviwActors = movies?.compactMap { $0.actors } ?? []
            let allActors = allMoviwActors.flatMap { $0.components(separatedBy: ",")}
            let actors = allActors.map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
            return Array(Set(actors))
        }
    }
    
    func getMovies(for category: MovieDisplayCategories, subCategory: String) -> [Movie] {
        switch category {
        case .year:
            let movies = movies?.filter { $0.year == subCategory } ?? []
            return movies
        case .genre:
            let movies = movies?.filter { $0.genre.contains(subCategory) } ?? []
            return movies
        case .directors:
            let movies = movies?.filter { $0.director.contains(subCategory)} ?? []
            return movies
        case .actors:
            let movies = movies?.filter { $0.actors.contains(subCategory)} ?? []
            return movies
        }
    }
    
    func getMovies(for searchString: String) -> [Movie] {
        return movies?.filter{  $0.title.contains(searchString) || $0.genre.contains(searchString) || $0.director.contains(searchString) || $0.actors.contains(searchString) } ?? []
    }
}
