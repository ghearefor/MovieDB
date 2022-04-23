//
//  ViewController+Extensions.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import UIKit

extension UIViewController {
    func addFavoriteButton() {
        let add = UIBarButtonItem(image: UIImage(systemName: "suit.heart.fill"), style: .done, target: self, action: #selector(goToMovieList))

        navigationItem.rightBarButtonItems = [add]
    }
    
    @objc func goToMovieList() {
        
        let vc = AllMoviesViewController()
        vc.category = .favorited
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func setNavbarTranslucent() {
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
    }
}
