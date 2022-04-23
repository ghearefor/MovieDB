//
//  MovieCollectionViewCell.swift
//  MovieDB
//
//  Created by MacBook on 21/04/22.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblSynopsis: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    // MARK: - Var
    static var identifier : String{
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblSynopsis.textColor = .white
        lblMovieTitle.textColor = .white
        lblReleaseDate.textColor = .white

        imgBanner.layer.cornerRadius = 8
        imgBanner.layer.masksToBounds = true
        imgBanner.contentMode = .scaleAspectFill
    }

    func bind(movie: MovieList) {
        lblMovieTitle.text = movie.title
        lblSynopsis.text = movie.overview
        lblReleaseDate.text = movie.releaseDate
        lblRating.text = "  \(movie.voteAverage?.stringValue ?? "")"
        
        let image = MovieAPI.endpoint.getImageOriginUrl(path: movie.posterPath ?? "").path
        imgBanner.load(url: image)
    }
}
