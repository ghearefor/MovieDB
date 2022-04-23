//
//  MovieListViewModel.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import UIKit

class MovieListViewModel {

    // MARK: - Variable
    var onShowError: ((_ error: String) -> Void)?
    var onShowSuccess: (() -> Void)?
    var onUpdateLoadingStatus: (() -> Void)?
    var isLoading: Bool? {
        didSet {
            onUpdateLoadingStatus?()
        }
    }
    
    var lastPage = 1
    var currentPage = 1
    var popular: [MovieList] = []
    var topRated: [MovieList] = []
    var nowPlaying: [MovieList] = []
    var allMovies: [MovieList] = []
    private let api: MovieAPI?

    init(api: MovieAPI) {
        self.api = api
    }

    // TODO: Implement view model methods
    // MARK: - API
    func getMovieList(page: Int, category: MovieCategory) {
        isLoading = true
        api?.getMovieList(page: page, category: category, completionHandler: { (response, error) in
            self.isLoading = false
            if let response = response {
                
                self.lastPage = response.object(forKey: "total_pages") as! Int
                self.currentPage = response.object(forKey: "page") as! Int

                guard let data = response.object(forKey: "results") else {
                    return
                }
                let listData = data as! [AnyObject]

                for i in 0..<listData.count {
                    let jsonData = try! JSONSerialization.data(withJSONObject: listData[i], options: [])
                    let decoder = JSONDecoder()
                    
                    do {
                        let list = try decoder.decode(MovieList.self, from: jsonData)
                        print(list)

                        self.allMovies.append(list)
                        switch category {
                        case .popular:
                            self.popular.append(list)
                        case .topRated:
                            self.topRated.append(list)
                        case .nowPlaying:
                            self.nowPlaying.append(list)
                        default:
                            break
                        }
                        
                    } catch {
                        print(error)
                    }
                }
                self.onShowSuccess?()
                
            } else if let error = error {
                self.onShowError?(error.localizedDescription)
            }
        })
    }
}
