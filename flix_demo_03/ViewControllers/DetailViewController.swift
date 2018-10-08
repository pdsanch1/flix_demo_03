//
//  DetailViewController.swift
//  flix_demo_03
//
//  Created by Pedro Daniel Sanchez on 9/11/18.
//  Copyright © 2018 Pedro Daniel Sanchez. All rights reserved.
//

import UIKit
import AlamofireImage

enum MovieKeys {
    static let title = "title"
    static let backDropPath = "backdrop_path"
    static let posterPath = "poster_path"
}

class DetailViewController: UIViewController {

    @IBOutlet weak var backDropImageView: UIImageView!
    //@IBOutlet weak var backDropImageView: UIImageView!
    //@IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            titleLabel.text = movie.title
            releaseDateLabel.text = movie.releaseDate
            overviewLabel.text = movie.overview
            
           // let backdropPathString = movie[MovieKeys.backDropPath] as! String
            
            //let posterPathString = movie[MovieKeys.posterPath] as! String
            
            //let baseUrlString = "https://image.tmdb.org/t/p/w500"
            
            let backdropURL = movie.backdropPathString //URL(string: baseUrlString + backdropPathString)!
            self.backDropImageView.af_setImage(withURL: backdropURL!)
        
            let posterURL = movie.posterUrl //URL(string: baseUrlString + posterPathString)!
            self.posterImageView.af_setImage(withURL: posterURL!)
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
