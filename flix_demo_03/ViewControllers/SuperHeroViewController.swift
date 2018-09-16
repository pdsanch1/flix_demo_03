//
//  SuperHeroViewController.swift
//  flix_demo_03
//
//  Created by Pedro Daniel Sanchez on 9/15/18.
//  Copyright © 2018 Pedro Daniel Sanchez. All rights reserved.
//

import UIKit
import AlamofireImage

class SuperHeroViewController: UIViewController, UICollectionViewDataSource {

   // @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movies: [[String: Any]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        fetchMovies()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        if let posterPathString = movie["poster_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURLString + posterPathString)!
            cell.posterImageView.af_setImage(withURL: posterURL)
        }
        return cell
    }
    
    func fetchMovies() {
        
        //let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        // handle cancel response here. Doing nothing will dismiss the view.
        //}
        // alertController.addAction(cancelAction)
       // let RETRYAction = UIAlertAction(title: "Retry", style: .default) { (action) in
            //self.refreshControl.endRefreshing()
            //self.activityIndicator.stopAnimating()
            // handle response here.
       //     return
       // }
        // add the OK action to the alert controller
        //alertController.addAction(RETRYAction)
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10) // 10 seconds
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            // Network requests are async in a different queue thread
            // than the main thread, which is handling user input
            if let error = error {
                print(error.localizedDescription)
                //alertController.title="Cannot fech Movies"
                //alertController.message=error.localizedDescription
                //UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true) {
                //}
            } else if let data = data {
                var dataDictionary: [String: Any]?
                do {
                    try dataDictionary = JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch let parserError {
                    print(parserError.localizedDescription)
                    return
                }
                //print(dataDictionary!)
                let movies = dataDictionary!["results"] as! [[String: Any]]
                //self.activityIndicator.stopAnimating()
                self.movies = movies
                //self.filteredData = self.movies
                self.collectionView.reloadData()
                //self.refreshControl.endRefreshing()
                
                //                for movie in movies {
                //                    let title = movie["title"] as! String
                //                    print(title)
                //                }
                
            }
        }
        task.resume()
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
