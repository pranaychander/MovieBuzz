//
//  MovieHelpers.swift
//  MovieBuzz
//
//  Created by pranay chander on 15/07/23.
//

import Foundation

enum MovieDisplayCategories: String, CaseIterable {
    case year, genre, directors, actors
}

enum DisplayMode {
    case categoryList, categorySelectionList, MovieList, SearchList, EmptySearch
}
