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
    
   // var movies: [[String: Any]] = []
    var movies: [Movie] = []
    
    var refreshControl: UIRefreshControl!
    
    var filteredData: [Movie] = [] //[[String: Any]] = []
    
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
        

        MovieApiManager().popularMovies { (movies: [Movie]?, error: Error?) in
            if let movies = movies {
                self.movies = movies
                self.filteredData = self.movies
                self.tableView.reloadData()
            }
        }
        
//        MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
//            if let movies = movies {
//                self.movies = movies
//                self.filteredData = self.movies
//                self.tableView.reloadData()
//            }
//        }


        

//                self.tableView.reloadData()



                self.refreshControl.endRefreshing()

                self.activityIndicator.stopAnimating()
        
        
       // task.resume()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count //movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell

        cell.movie = movies[indexPath.row]
        
//        let movie = filteredData[indexPath.row]
//        cell.titleLabel.text = movie.title
//        cell.overviewLabel.text = movie.overview
//        let posterURL = movie.posterUrl //URL(string: baseUrlString + posterPathString)!

        //        cell.posterImageView.af_setImage(
//            withURL: posterURL!) //,
        
        return cell
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        //print(self.movieTitles)
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? filteredData : filteredData.filter({
                (movieRecord: Movie) -> Bool in
                return (movieRecord.title as! String).range(of: searchText, options: .caseInsensitive) != nil
            })

           
            
            tableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailViewComtroller = segue.destination as! DetailViewController
            detailViewComtroller.movie = movie
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
