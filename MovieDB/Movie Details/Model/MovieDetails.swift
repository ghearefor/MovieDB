//
//  MovieDetails.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import Foundation

struct MovieDetails: Codable {
    
    var title, releaseDate, overview, posterPath, backdropPath: String?
    var voteCount, id: Int?
    var voteAverage: AnyValue?

    enum CodingKeys: String, CodingKey {
        case title, overview, id
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
