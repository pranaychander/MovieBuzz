//
//  MovieListViewModel.swift
//  MovieBuzz
//
//  Created by pranay chander on 14/07/23.
//

import Foundation
import Combine

final class MovieListViewModel {
    var searchString: String = ""
    @Published var movieList: [Movie] = []
    var selectedCategory: MovieDisplayCategories = .year
    let listCategories: [MovieDisplayCategories] = MovieDisplayCategories.allCases
    var categoriesSubList: [String] = []
    @Published var displayMode: DisplayMode = .categoryList
    
    var moviesRepo: MovieRepository = MovieRepository()
    
    func displaySearchResults() -> Bool {
        guard searchString.isEmpty else {
            return true
        }
        return false
    }
    
    func startSearching(for text: String) {
        searchString = text
        guard !text.isEmpty else {
            displayMode = .categoryList
            return
        }
        movieList = moviesRepo.getMovies(for: text)
        displayMode = movieList.isEmpty == true  ? .EmptySearch : .SearchList
    }
    
    func selectCategory(for category: MovieDisplayCategories) {
        selectedCategory = category
        categoriesSubList = moviesRepo.getItemsForCategory(for: category)
        displayMode = categoriesSubList.isEmpty == true  ? .EmptySearch : .categorySelectionList
    }
    
    func selectSubCategory(for subcategory: String) {
        movieList = moviesRepo.getMovies(for: selectedCategory, subCategory: subcategory)
        displayMode = categoriesSubList.isEmpty == true  ? .EmptySearch : .MovieList
    }
    
    func updateToPreviousView() {
        switch displayMode {
        case .categoryList:
            break
        case .categorySelectionList:
            displayMode = .categoryList
        case .MovieList:
            displayMode = .categorySelectionList
        case .SearchList:
            break
        case .EmptySearch:
            break
        }
    }
    
    func shouldDisplayBackButton() -> Bool {
        switch displayMode {
        case .categoryList, .SearchList, .EmptySearch:
            return false
        case .categorySelectionList, .MovieList :
            return true
        }
    }
    
    func getMovieCellViewModel(for index: Int) -> MovieCellViewModel {
        return MovieCellViewModel(movie: movieList[index])
    }
}
