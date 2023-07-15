//
//  MovieTableViewCell.swift
//  MovieBuzz
//
//  Created by pranay chander on 14/07/23.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieCell"
    
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var language: UILabel!
    
    var viewModel: MovieCellViewModel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        poster.layer.borderWidth = 2.0
        poster.layer.borderColor = UIColor.opaqueSeparator.cgColor
        
    }
    
    func setViewModel(viewModel: MovieCellViewModel) {
        self.viewModel = viewModel
        self.title.text = viewModel.movie.title
        self.year.text = viewModel.movie.year
        self.language.text = viewModel.movie.language
        Task {
            guard let data = await viewModel.getImageData() else { return }
            DispatchQueue.main.async { [weak self] in
                self?.poster.image = UIImage(data: data)
            }
        }
    }
}


