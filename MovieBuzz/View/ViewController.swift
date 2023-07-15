//
//  ViewController.swift
//  MovieBuzz
//
//  Created by pranay chander on 14/07/23.
//

import UIKit
import Combine
import SwiftUI

class ViewController: UIViewController {
    var viewModel = MovieListViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    private var searchController: UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies by title/actor/genre/year"
        return searchController
    }
    
    var anyCancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObservers()
    }
    
    private func setupObservers(){
        viewModel
            .$displayMode
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.tableView.reloadData()
                self?.setupNavigationBackButton()
            }
            .store(in: &anyCancellable)
        
        viewModel
            .$movieList
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &anyCancellable)
    }
    
    private func setupUI() {
        navigationItem.title = "MovieBuzz"
        setupSearchBar()
        setupTableView()
    }
    
    private func setupNavigationBackButton() {
        self.navigationItem.leftBarButtonItem = viewModel.shouldDisplayBackButton() ? UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped)) : nil
    }
    
    private func setupSearchBar() {
        self.navigationItem.searchController = searchController
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: String(describing: CategoryTableViewCell.self), bundle: nil), forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.register(UINib(nibName: String(describing: MovieTableViewCell.self), bundle: nil), forCellReuseIdentifier: MovieTableViewCell.identifier)
    }
    
    @objc func backButtonTapped() {
        viewModel.updateToPreviousView()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.displayMode {
        case .categoryList:
            return viewModel.listCategories.count
        case .categorySelectionList:
            return viewModel.categoriesSubList.count
        case .MovieList, .SearchList:
            return viewModel.movieList.count
        case .EmptySearch:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.displayMode {
        case .categoryList:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
                return UITableViewCell()
            }
            cell.title.text = viewModel.listCategories[indexPath.row].rawValue.capitalized
            cell.accessoryType = .disclosureIndicator
            return cell
        case .categorySelectionList:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
                return UITableViewCell()
            }
            cell.title.text = viewModel.categoriesSubList[indexPath.row].capitalized
            cell.accessoryType = .disclosureIndicator
            return cell
        case .MovieList, .SearchList:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
                return UITableViewCell()
            }
            
            cell.setViewModel(viewModel: viewModel.getMovieCellViewModel(for: indexPath.row))
            cell.accessoryType = .disclosureIndicator
            return cell
        case .EmptySearch:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
                return UITableViewCell()
            }
            cell.title.text = "No Results"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.displayMode {
        case .categoryList:
            viewModel.selectCategory(for: viewModel.listCategories[indexPath.row])
        case .categorySelectionList:
            viewModel.selectSubCategory(for: viewModel.categoriesSubList[indexPath.row])
        case .SearchList, .MovieList:
            let viewModel = viewModel.getMovieCellViewModel(for: indexPath.row)
            let view = MovieeDetailView(vm: viewModel)
            let detailViewController = UIHostingController(rootView: view)
            self.present(detailViewController, animated: true)
        case .EmptySearch:
            break
        }
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.startSearching(for: searchController.searchBar.text ?? "")
    }
}
