//
//  MovieDetailsViewController.swift
//  TheMovieDB
//
//  Created by Maksim Bazarov on 08.10.18.
//  Copyright © 2018 Maksim Bazarov. All rights reserved.
//

import UIKit
import Nuke



/// This view controller is static, which means it only represents one state
/// and never changes

class MovieDetailsViewController: UIViewController {

    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var releaseYearLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            guard isViewLoaded, let movie = movie else { return }
            render(movie: movie)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            render(movie: movie)
        }
    }
    
    private func render(movie: Movie) {
        nameLabel.text = movie.name
        overviewLabel.text = movie.overview
        let year = Calendar.current.component(.year, from: movie.released)
        releaseYearLabel.text = String(year)
        
        if let imageURL = movie.poster {
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

extension MovieDetailsViewController {
    
    static func instantiate() -> MovieDetailsViewController {
        let vc = UIStoryboard(name: "MovieDetails", bundle: nil)
            .instantiateInitialViewController() as! MovieDetailsViewController
        return vc
    }
}

