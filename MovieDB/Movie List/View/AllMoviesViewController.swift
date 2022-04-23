//
//  AllMoviesViewController.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import UIKit

class AllMoviesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: BaseCollectionView!

    // MARK: - Var
    var category: MovieCategory = .popular
    lazy var viewModel: MovieListViewModel = {
        return MovieListViewModel(api: MovieAPI())
    }()

    // MARK: - Lifecycle
    init() {
        super.init(nibName: "AllMoviesViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        if category != .favorited {
            loadData(page: 1, isRefresh: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if category == .favorited {
            viewModel.allMovies = FavoritedMovies().retrieve()
            collectionView.reloadData()
        }
    }
    
    private func setupUI() {
        title = category.rawValue
        setNavbarTranslucent()
        view.backgroundColor = .black
        collectionView.register(MovieCollectionViewCell.nib, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.collectionViewDelegate = self
        collectionView.collectionViewDataSource = self
        
        if category != .favorited {
            addFavoriteButton()
        }
    }

    private func setupViewModel() {
        viewModel.onShowSuccess = {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.currentPage = self?.viewModel.currentPage ?? 0
                self?.collectionView.lastPage = self?.viewModel.lastPage ?? 0
                self?.collectionView.reloadData()
            }
        }
        viewModel.onUpdateLoadingStatus = { [weak self] in
            guard let _ = self?.viewModel.isLoading else {return}
        }
    }

    // MARK: - Actions
    fileprivate func loadData(page: Int, isRefresh: Bool) {
        if isRefresh {
            viewModel.allMovies.removeAll()
        }

        switch category {
        case .popular:
            viewModel.getMovieList(page: page, category: .popular)
        case .topRated:
            viewModel.getMovieList(page: page, category: .topRated)
        case .nowPlaying:
            viewModel.getMovieList(page: page, category: .nowPlaying)
        default:
            break
        }
    }
}

// MARK: - Collection View Delegate / Data Source
extension AllMoviesViewController: BaseCollectionViewDelegate, BaseCollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func refreshData() {
        if category != .favorited {
            loadData(page: 1, isRefresh: true)
        }
    }
    
    func loadMore(_ pageNumber: Int) {
        if category != .favorited {
            loadData(page: pageNumber, isRefresh: false)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                        MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        
        cell.bind(movie: viewModel.allMovies[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2-10, height: 350)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let vc = MovieDetailsViewController()
        vc.viewModel.movieId = viewModel.allMovies[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
