//
//  MovieTableViewCell.swift
//  ADSA-Coding-Challenge
//
//  Created by Julio Lopez on 4/10/17.
//  Copyright © 2017 Julio Lopez. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    static let cellId = "MovieTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func cellIdentifier() -> String {
        return cellId
    }
    
    class func cellName() -> String {
        return cellId
    }
    
    class func cellHeight() -> CGFloat {
        return 65.0
    }
}
