//
//  Movie.swift
//  
//
//  Created by Pedro Daniel Sanchez on 10/7/18.
//

import Foundation


//enum MovieKeys {
//    static let title = "title"
//    static let backDropPath = "backdrop_path"
//    static let posterPath = "poster_path"
//}


class Movie {
    var title: String
    var releaseDate: String
    var overview: String
    var posterUrl: URL?
    var backdropPathString: URL?

    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "No title"
        overview = dictionary["overview"]  as? String ?? "No Overview"
        releaseDate = dictionary["release_date"] as? String ?? "No Date"
        let baseUrlString = "https://image.tmdb.org/t/p/w500"
        // "posterPath" same as  MovieKeys.posterPath  in the enum at the top
        let purl = dictionary[MovieKeys.posterPath] as! String
        posterUrl = URL(string: baseUrlString + purl)
        // "backdrop_path" same as MovieKeys.backDropPath in the enum at the top
        let bdp = dictionary[MovieKeys.backDropPath] as! String
        backdropPathString = URL(string: baseUrlString + bdp)
    }
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        return movies
    }
}
