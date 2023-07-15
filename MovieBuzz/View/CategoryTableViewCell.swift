//
//  CategoryTableViewCell.swift
//  MovieBuzz
//
//  Created by pranay chander on 14/07/23.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    static let identifier: String = "categoryCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
