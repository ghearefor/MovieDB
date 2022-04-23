//
//  MovieDetailsViewController.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import Foundation
import UIKit

class MovieDetailsViewController: ViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var viewBanner: UIView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSeeAll: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    
    // MARK: - Var
    lazy var viewModel: MovieDetailsViewModel = {
        return MovieDetailsViewModel()
    }()
    var layout = UICollectionViewFlowLayout()

    // MARK: - Lifecycle
    init() {
        super.init(nibName: "MovieDetailsViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        viewModel.getMovieDetails()
    }
    
    private func setupUI() {
        title = "Movie Details"
        imgMovie.layer.cornerRadius = 8
        imgMovie.layer.masksToBounds = true
        imgMovie.contentMode = .scaleAspectFill
        
        collectionView.register(ReviewCollectionViewCell.nib, forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear

        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: collectionView.frame.width-100, height: 200)
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }
    
    private func setupViewModel() {
        viewModel.onShowSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.setupData()
                self?.viewModel.getMovieReviews(page: 1)
            }
        }
        viewModel.onSuccessGetReviews = { [self] in
            DispatchQueue.main.async {
                self.btnSeeAll.isHidden = self.viewModel.lastPage > 1 ? false : true
                self.layout.itemSize = CGSize(width: self.viewModel.reviews.count > 1 ? self.collectionView.frame.width-100 : self.collectionView.frame.width-16 , height: 200)
                self.collectionView.collectionViewLayout = self.layout
                self.collectionView.reloadData()
            }
        }
        viewModel.onUpdateLoadingStatus = { [weak self] in
            guard let _ = self?.viewModel.isLoading else {return}
        }
    }
    
    // MARK: - Setup Data
    private func setupData() {
        
        let movie = viewModel.movie

        lblMovieTitle.text = movie?.title
        lblDate.text = movie?.releaseDate
        lblOverview.text = movie?.overview
        lblRating.text = " \(movie?.voteAverage?.stringValue ?? "")"
        imgMovie.load(url: MovieAPI.endpoint.getImageOriginUrl(path: movie?.posterPath ?? "").path)
        imgBanner.load(url: MovieAPI.endpoint.getImageOriginUrl(path: movie?.backdropPath ?? "").path)
        
        // check if the movie already favorited
        let data = FavoritedMovies().retrieve()
        let isFavorited: Bool = data.contains { (model) -> Bool in
            model.id == movie?.id
        }
        
        if isFavorited {
            btnFavorite.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        } else {
            btnFavorite.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        }
    }
    
    // MARK: - Actions
    @IBAction func seeAllButtonTapped(sender: UIButton) {
        let movie = viewModel.movie

        // check if the movie already favorited
        let data = FavoritedMovies().retrieve()
        let isFavorited: Bool = data.contains { (model) -> Bool in
            model.id == movie?.id
        }
        
        if isFavorited {
            // unfavorited
            btnFavorite.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            FavoritedMovies().delete(movie?.id ?? 0)
        } else {
            // favorited
            btnFavorite.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            FavoritedMovies().save(movie: movie!, favorited: true)
        }
    }
}

// MARK: - Collection View Delegate / Data Source
extension MovieDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as! ReviewCollectionViewCell

        cell.bind(review: viewModel.reviews[indexPath.row])
        
        return cell
    }
}
