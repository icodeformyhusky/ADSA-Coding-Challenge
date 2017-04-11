//
//  MovieModel.swift
//  ADSA-Coding-Challenge
//
//  Created by Julio Lopez on 4/10/17.
//  Copyright © 2017 Julio Lopez. All rights reserved.
//

import UIKit
import SwiftyJSON

class MovieModel: NSObject {
    
    struct movieModel {
        var movieDict = [[String : String]]()
        var totalResults: String
        var totalPages: String
        var more: Bool
    }
    
    var movieList: [movieModel] = [movieModel]()
    
    init(data: JSON) {
        if let responseObject = data.dictionary {
            if let results = responseObject["results"] {
                if let totalResults = responseObject["total_results"]?.rawValue {
                    if let totalPages = responseObject["total_pages"]?.rawValue {
                        var tempDictionary = Dictionary<String, String>()
                        var tempArray = [[String : String]]()
                        for items in results {
                            tempDictionary["poster_path"] = items.1["poster_path"].string
                            tempDictionary["title"] = items.1["title"].string
                            tempDictionary["release_date"] = items.1["release_date"].string
                            tempDictionary["overview"] = items.1["overview"].string
                            tempArray.append(tempDictionary)
                        }
                        
                        //Check if there are movies that match your search.
                        var more: Bool
                        if !results.isEmpty {
                            more = true
                        } else {
                            more = false
                        }
                        
                        movieList.append(movieModel(movieDict: tempArray, totalResults: "\(totalResults)", totalPages: "\(totalPages)", more: more))
                    }
                }
            }
        }
    }
}

