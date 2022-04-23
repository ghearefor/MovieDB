//
//  MovieTableViewCell.swift
//  MovieDB
//
//  Created by MacBook on 23/04/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Var
    static var identifier : String{
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    private var movieList: [MovieList] = []
    var parent: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.register(MovieCollectionViewCell.nib, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 190, height: 340)
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }

    func bind(list: [MovieList], parent: UIViewController) {
        movieList = list
        collectionView.reloadData()
        self.parent = parent
    }
}

// MARK: - Collection View Data Source & Delegate
extension MovieTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count > 4 ? 4 : movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        
        cell.bind(movie: movieList[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // go to details
        let vc = MovieDetailsViewController()
        vc.viewModel.movieId = movieList[indexPath.row].id ?? 0
        parent?.navigationController?.pushViewController(vc, animated: true)
        
    }
}
