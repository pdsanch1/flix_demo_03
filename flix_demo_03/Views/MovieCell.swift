//
//  MovieCell.swift
//  flix_demo_03
//
//  Created by Pedro Daniel Sanchez on 9/8/18.
//  Copyright © 2018 Pedro Daniel Sanchez. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.magenta
            selectedBackgroundView = backgroundView
            posterImageView.af_setImage(
            withURL: movie.posterUrl!) //,
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
