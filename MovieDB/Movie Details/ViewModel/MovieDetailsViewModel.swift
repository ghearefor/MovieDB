//
//  MovieDetailsViewModel.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import Foundation

class MovieDetailsViewModel {

    // MARK: - Var
    var onShowError: ((_ error: String) -> Void)?
    var onShowSuccess: (() -> Void)?
    var onSuccessGetReviews: (() -> Void)?
    var onUpdateLoadingStatus: (() -> Void)?
    var isLoading: Bool? {
        didSet {
            onUpdateLoadingStatus?()
        }
    }

    var lastPage = 1
    var currentPage = 1
    var movieId: Int = 0
    var movie: MovieDetails?
    var reviews: [MovieReviews] = []
    private let api: MovieAPI?

    init(api: MovieAPI = MovieAPI()) {
        self.api = api
    }

    // TODO: Implement view model methods
    // MARK: - API
    func getMovieDetails() {
        isLoading = true
        api?.getMovieDetails(movieId: movieId, completionHandler: { (response, error) in
            if let response = response {
                let jsonData = try! JSONSerialization.data(withJSONObject: response, options: [])
                let decoder = JSONDecoder()
                
                do {
                    let details = try decoder.decode(MovieDetails.self, from: jsonData)
                    self.movie = details
                } catch {
                    print(error)
                }
                self.onShowSuccess?()
            } else if let error = error {
                self.onShowError?(error.localizedDescription)
            }
        })
    }

    func getMovieReviews(page: Int) {
        isLoading = true
        api?.getMovieReviews(movieId: movieId, page: page, completionHandler: { (response, error) in
            if let response = response {
                
                self.lastPage = response.object(forKey: "total_pages") as! Int
                self.currentPage = response.object(forKey: "page") as! Int
                
                var listData = [AnyObject]()
                guard let data = response.object(forKey: "results") else {
                    return
                }
                listData = data as! [AnyObject]

                for i in 0..<listData.count {
                    let jsonData = try! JSONSerialization.data(withJSONObject: listData[i], options: [])
                    let decoder = JSONDecoder()
                    
                    do {
                        let review = try decoder.decode(MovieReviews.self, from: jsonData)
                        self.reviews.append(review)
                    } catch {
                        print(error)
                    }
                }
                self.onSuccessGetReviews?()
            } else if let error = error {
                self.onShowError?(error.localizedDescription)
            }
        })
    }
}
