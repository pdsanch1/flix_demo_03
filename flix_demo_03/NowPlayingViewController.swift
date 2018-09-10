//
//  NowPlayingViewController.swift
//  flix_demo_03
//
//  Created by Pedro Daniel Sanchez on 9/8/18.
//  Copyright © 2018 Pedro Daniel Sanchez. All rights reserved.
//

import UIKit
import AlamofireImage
import Foundation

class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    
    var filteredData: [[String: Any]] = []
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        fetchMovies()
        tableView.dataSource = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater=self
        searchController.dimsBackgroundDuringPresentation=false
        
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.showsCancelButton = true
        searchController?.searchBar.delegate = self
        
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView  = searchController.searchBar
        definesPresentationContext=true
    }
    
    func  searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.showsCancelButton = false
        fetchMovies()
        // You could also change the position, frame etc of the searchBar
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    func fetchMovies() {
        
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        //}
       // alertController.addAction(cancelAction)
        let RETRYAction = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            // handle response here.
            return
        }
        // add the OK action to the alert controller
        alertController.addAction(RETRYAction)
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10) // 10 seconds
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            // Network requests are async in a different queue thread
            // than the main thread, which is handling user input
            if let error = error {
                print(error.localizedDescription)
                alertController.title="Cannot fech Movies"
                alertController.message=error.localizedDescription
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true) {
                }
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
                self.activityIndicator.stopAnimating()
                self.movies = movies
                self.filteredData = self.movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
                //                for movie in movies {
                //                    let title = movie["title"] as! String
                //                    print(title)
                //                }
                
            }
        }
        task.resume()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count //movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
       
        let movie = filteredData[indexPath.row]

        let title = movie["title"] as! String
        
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        let posterPathString = movie["poster_path"] as! String
        
//        let placeholderImage = UIImage(named: "placedholder")
//        
//        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
//            size: cell.posterImageView.frame.size,
//            radius: 30.0)
//        
        
        let baseUrlString = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseUrlString + posterPathString)!
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.magenta
        cell.selectedBackgroundView = backgroundView
        
        cell.posterImageView.af_setImage(
            withURL: posterURL) //,
            //placeholderImage: placeholderImage) //,
            //filter: filter)
        
        return cell
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        //print(self.movieTitles)
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? filteredData : filteredData.filter({
                (movieRecord: [String: Any]) -> Bool in
                return (movieRecord["title"] as! String).range(of: searchText, options: .caseInsensitive) != nil
            })

           
            
            tableView.reloadData()
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
