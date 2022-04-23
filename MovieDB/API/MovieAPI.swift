//
//  MovieAPI.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import Foundation

class MovieAPI {

    private let instance = ApiManager()

    // MARK: - Movie List
    func getMovieList(page: Int, category: MovieCategory, completionHandler:@escaping (AnyObject?, MovieError?) -> Void) -> Void {

        switch category {
        case .popular:
            instance.call(endpoint.getPopular(page: page).path, method: .get, completion: completionHandler)
        case .topRated:
            instance.call(endpoint.getTopRated(page: page).path, method: .get, completion: completionHandler)
        case .nowPlaying:
            instance.call(endpoint.getNowPlaying(page: page).path, method: .get, completion: completionHandler)
        default:
            break
        }

    }

    // MARK: - Movie Details
    func getMovieDetails(movieId: Int, completionHandler:@escaping (AnyObject?, MovieError?) -> Void) -> Void {
        instance.call(endpoint.getMovieDetail(movieId: movieId).path, method: .get, completion: completionHandler)
    }

    // MARK: - Movie Reviews
    func getMovieReviews(movieId: Int, page: Int, completionHandler:@escaping (AnyObject?, MovieError?) -> Void) -> Void {
        instance.call(endpoint.getMovieReviews(movieId: movieId, page: page).path, method: .get, completion: completionHandler)
    }
}

extension MovieAPI {
    // MARK: - Endpoint
    enum endpoint {
        case getImageOriginUrl(path: String)
        case getPopular(page: Int)
        case getTopRated(page: Int)
        case getNowPlaying(page: Int)
        case getMovieDetail(movieId: Int)
        case getMovieReviews(movieId: Int, page: Int)
        
        var APIKey: String {
            return "df2c1298655791bf476a177bcad5402b"
        }
        
        var path: String {
            switch self {
            case .getImageOriginUrl(let path):
                return "https://image.tmdb.org/t/p/w154\(path)"
            case .getPopular(let page):
                return "popular?api_key=\(APIKey)&page=\(page)"
            case .getTopRated(let page):
                return "top_rated?api_key=\(APIKey)&page=\(page)"
            case .getNowPlaying(let page):
                return "now_playing?api_key=\(APIKey)&page=\(page)"
            case .getMovieDetail(let movieId):
                return "\(movieId)?api_key=\(APIKey)&language=en-US"
            case .getMovieReviews(let movieId, let page):
                return "\(movieId)/reviews?api_key=\(APIKey)&language=en-US&page=\(page)"
            }
        }
    }
}

enum MovieCategory: String, CaseIterable {
    case popular = "Popular"
    case topRated = "Top Rated"
    case nowPlaying = "Now Playing"
    case favorited = "Favorited Movies"
}
