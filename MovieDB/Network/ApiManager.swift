//
//  ApiManager.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import Foundation
import UIKit

class ApiManager {
    
    func call(_ endpoint: String, method: HTTPMethod, completion: @escaping (AnyObject?, MovieError?) -> Void) -> Void {
        
        var request = URLRequest(url: URL(string: endPointBuilder(endpoint))!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        
        let sessionTask = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            
            if let requestError = error {
                completion(nil, MovieError.failedRequest(description: requestError.localizedDescription))
                return
            }
            
            if let data = data {
                let result = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                completion (result as AnyObject, nil)
            } else {
                completion(nil, MovieError.invalidResponseModel)
            }
        }
        
        sessionTask.resume()
    }
}

extension ApiManager {
    private func endPointBuilder(_ path: String) -> String {
        return "https://api.themoviedb.org/3/movie/" + path
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
