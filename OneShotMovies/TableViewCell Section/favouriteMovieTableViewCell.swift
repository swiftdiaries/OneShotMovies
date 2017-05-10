//
//  favouriteMovieTableViewCell.swift
//  OneShotMovies
//
//  Created by Adhita Selvaraj on 13/01/17.
//  Copyright © 2017 DreamCatcher. All rights reserved.
//

import UIKit

class favouriteMovieTableViewCell: UITableViewCell {

    @IBOutlet var moviePosterImage: UIImageView!
    
    @IBOutlet var movieTitleInTable: UILabel!
    
    @IBOutlet var movieRatingInTable: UILabel!
    
    @IBOutlet var movieStaticLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
