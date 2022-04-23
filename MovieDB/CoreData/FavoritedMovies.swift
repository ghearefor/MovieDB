//
//  FavoritedMovies.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import UIKit
import CoreData

class FavoritedMovies {
    
    // MARK: - Save Data
    func save(movie: MovieDetails, favorited: Bool) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        let favoritedMovies = NSEntityDescription.entity(forEntityName: "FavoritedMoviesEntity", in: managedContext)
        
        // entity body
        let insert = NSManagedObject(entity: favoritedMovies!, insertInto: managedContext)
        insert.setValue(movie.id, forKey: "movieId")
        insert.setValue(movie.title, forKey: "title")
        insert.setValue(movie.releaseDate, forKey: "releaseDate")
        insert.setValue(movie.posterPath, forKey: "posterPath")
        insert.setValue(movie.overview, forKey: "overview")
        insert.setValue(movie.voteAverage?.stringValue, forKey: "voteAverage")
        insert.setValue(favorited, forKey: "favorited")
        
        do {
            try managedContext.save()
        } catch let err {
            print(err)
        }
    }
    
    // MARK: - Retrieve Data
    func retrieve() -> [MovieList] {
        
        var movies = [MovieList]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // fetch data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritedMoviesEntity")
        
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            result.forEach{ movie in
                movies.append(
                    MovieList(
                        title: movie.value(forKey: "title") as? String,
                        releaseDate: movie.value(forKey: "releaseDate") as? String,
                        overview: movie.value(forKey: "overview") as? String,
                        posterPath: movie.value(forKey: "posterPath") as? String,
                        id: movie.value(forKey: "movieId") as? Int,
                        voteAverage: movie.value(forKey: "voteAverage") as? AnyValue
                    )
                )
            }
        } catch let err {
            print(err)
        }
        
        return movies
    }

    // MARK: - Delete Data
    func delete(_ id: Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // fetch data to delete
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritedMoviesEntity")
        fetchRequest.predicate = NSPredicate(format: "movieId = %i", id)
        
        do {
            let dataToDelete = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            managedContext.delete(dataToDelete)
            
            try managedContext.save()
        } catch let err {
            print(err)
        }
    }
}
