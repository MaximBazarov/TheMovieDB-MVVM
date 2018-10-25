//
//  MovieCell.swift
//  TheMovieDB
//
//  Created by Maksim Bazarov on 08.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import UIKit
import Nuke

class MovieCell: UITableViewCell {
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var releaseYearLabel: UILabel!
    
    static let identifier: String = "MovieCell"
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle(for: self))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        releaseYearLabel.layer.borderColor = UIColor(white: 151.0 / 255.0, alpha: 1.0).cgColor
        releaseYearLabel.layer.borderWidth = 0.5
        releaseYearLabel.layer.cornerRadius = 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        nameLabel.text = nil
        overviewLabel.text = nil
        releaseYearLabel.text = nil
    }
    
    func configure(with movie: Movie) {
        nameLabel.text = movie.name
        overviewLabel.text = movie.overview
        let year = Calendar.current.component(.year, from: movie.released)
        releaseYearLabel.text = String(year)
        
        if let imageURL = movie.poster {
            // Using Nuke lib here to save time writing my own
            Nuke.loadImage(
                with: imageURL,
                options: ImageLoadingOptions(
                    transition: .fadeIn(duration: 0.33)
                ),
                into: posterImageView
            )
        }
    }
}
