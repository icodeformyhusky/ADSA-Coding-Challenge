//
//  SearchDisplayController.swift
//  ADSA-Coding-Challenge
//
//  Created by Julio Lopez on 4/10/17.
//  Copyright © 2017 Julio Lopez. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class SearchDisplayController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!    
    @IBOutlet weak var tableView: UITableView!
    
    var movieObject = [[String: String]]()
    
    let threshold: CGFloat = 100.0
    var isLoadingMore = false
    var more = true
    var currentPageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: UITableView delegate + datasource methods
extension SearchDisplayController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.movieObject.isEmpty {
            return self.movieObject.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:MovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellIdentifier(), for: indexPath) as! MovieTableViewCell
        if !self.movieObject.isEmpty {
            cell.movieTitleLabel.text = self.movieObject[indexPath.row]["title"]
            
            if let val = self.movieObject[indexPath.row]["poster_path"] {
                if !val.isEmpty {
                    let imageUrl = "\(Configuration.urls.movieImagesBaseUrl)\(String(describing: self.movieObject[indexPath.row]["poster_path"]!))"
                    Alamofire.request(imageUrl).responseImage {
                        response in
                        if let image = response.result.value {
                            cell.movieImageView.image = image
                        }
                    }
                } else {
                    cell.movieImageView.image = UIImage(named: "Movie_Placeholder")
                }
            }
            
            return cell
        } else {
            cell.movieTitleLabel.text = ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        movieDetailsViewController.movieSummaryString = self.movieObject[indexPath.row]["overview"]!
        movieDetailsViewController.movieTitleString = self.movieObject[indexPath.row]["title"]!
        movieDetailsViewController.releaseDateString = self.movieObject[indexPath.row]["release_date"]!
        
        if let val = self.movieObject[indexPath.row]["poster_path"] {
            if !val.isEmpty {
                movieDetailsViewController.moviePosterUrlString = self.movieObject[indexPath.row]["poster_path"]!
            } else {
                movieDetailsViewController.moviePosterUrlString = ""
            }
        }
        
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieTableViewCell.cellHeight()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if !isLoadingMore && (maximumOffset - contentOffset <= threshold) {
            self.isLoadingMore = true
            DispatchQueue.main.async() {
                self.fetchMovieData(Configuration.urls.moviesBaseUrl + "search/movie", ["api_key": Configuration.apiKeys.theMovieDBKey, "language": "en_US", "page" : String(self.currentPageNumber), "include_adult" : "false", "query" : self.searchBar.text!])
                self.isLoadingMore = false
            }
        }
    }
    
}

//MARK: UISearchbar Delegate + searchbar related items
extension SearchDisplayController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.resetSearchBar()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !(self.searchBar.text?.isEmpty)! {
            self.fetchMovieData(Configuration.urls.moviesBaseUrl + "search/movie", ["api_key": Configuration.apiKeys.theMovieDBKey, "language": "en_US", "page" : String(self.currentPageNumber), "include_adult" : "false", "query" : self.searchBar.text!])
        }
        
        self.resetSearchBar()
    }
    
    func resetSearchBar() {
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
}

//MARK: Private methods
private extension SearchDisplayController {
    func setupViewController() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
        tableView.register(UINib(nibName: MovieTableViewCell.cellName(), bundle:  nil), forCellReuseIdentifier: MovieTableViewCell.cellIdentifier())
        
        //Navigation bar + search bar color configuration. Should it go somewhere else like in a master configuration file? Yeah, but time is of the essence right now.
        self.navigationController?.navigationBar.topItem?.title = "The Movie DB Search Thingy"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: Themes.ColorPalette.movieDBWhite]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        
        UISearchBar.appearance().barTintColor = Themes.ColorPalette.movieDBRed
        UISearchBar.appearance().tintColor = Themes.ColorPalette.movieDBRed
    }
    
    func fetchMovieData(_ url: String,_ params: Dictionary<String, String>) {
        if more {
            Alamofire.request(url, parameters: params)
                .responseJSON {
                    response in
                    switch response.result {
                    case .success(let value):
                        self.currentPageNumber += 1
                        var movies = [MovieModel.init(data: JSON(value))]
                        
                        for items in movies[0].movieList[0].movieDict {
                            self.movieObject.append(items)
                        }
                        
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
            }
        }
    }
}


