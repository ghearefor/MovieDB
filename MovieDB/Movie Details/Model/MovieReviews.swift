//
//  MovieReviews.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//


struct MovieReviews: Codable {
    
    var id, content, createdAt: String?
    var authorDetails: AuthorDetails?

    enum CodingKeys: String, CodingKey {
        case id, content
        case createdAt = "created_at"
        case authorDetails = "author_details"
    }
}

struct AuthorDetails: Codable {
    
    var author, avatarPath, username: String?
    var rating: AnyValue?

    enum CodingKeys: String, CodingKey {
        case author, rating, username
        case avatarPath = "avatar_path"
    }
}
