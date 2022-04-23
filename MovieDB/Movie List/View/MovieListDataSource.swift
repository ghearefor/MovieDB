//
//  MovieListDataSource.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import UIKit

class MovieListDataSource: NSObject, UITableViewDataSource {
    
    private let movies: [MovieList]
    private var controller: UIViewController
    
    init(movies: [MovieList], parent: UIViewController) {
        self.movies = movies
        self.controller = parent
        super.init()
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        
        cell.bind(list: movies, parent: controller)
        
        return cell
    }
    
}
