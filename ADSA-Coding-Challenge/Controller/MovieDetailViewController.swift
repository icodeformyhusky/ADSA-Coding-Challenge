//
//  MovieDetailViewController.swift
//  ADSA-Coding-Challenge
//
//  Created by Julio Lopez on 4/10/17.
//  Copyright © 2017 Julio Lopez. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieDetailImageView: UIImageView!
    @IBOutlet weak var movieDetailTitleLabel: UILabel!
    @IBOutlet weak var movieDetailReleaseDateLabel: UILabel!
    @IBOutlet weak var movieDetailSummaryTextView: UITextView!
    @IBOutlet weak var movieDetailRatingLabel: UILabel!
    
    var movieSummaryString = ""
    var movieTitleString = ""
    var releaseDateString = ""
    var averageVotesString = ""
    var moviePosterUrlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieDetailTitleLabel.text = movieTitleString
        movieDetailSummaryTextView.text = "Summary: \(movieSummaryString)"
        movieDetailReleaseDateLabel.text = "Release date: \(releaseDateString)"
        movieDetailRatingLabel.text = "Login to see rating"
        
        if !self.moviePosterUrlString.isEmpty {
            let imageUrl = "\(Configuration.urls.movieImagesBaseUrl)\(self.moviePosterUrlString)"
            Alamofire.request(imageUrl).responseImage {
                response in
                if let image = response.result.value {
                    self.movieDetailImageView.image = image
                }
            }
        } else {
            self.movieDetailImageView.image = UIImage(named: "Movie_Placeholder")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
}
