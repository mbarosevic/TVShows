//
//  ReviewTableViewCell.swift
//  TV Shows
//
//  Created by mbarosevic on 27.07.2021..
//

import UIKit

final class ReviewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userCommentLabel: UILabel!
    @IBOutlet weak var userShowRating: RatingPredefinedController!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userEmailLabel.text = nil
        userCommentLabel.text = nil
    }
}

// MARK: - Configure

extension ReviewTableViewCell {

    func configure(with review: Review) {
        userEmailLabel.text = review.user.email
        userShowRating.setStarsRating(rating: Int(review.rating))
        userCommentLabel.text = review.comment
    }
}

// MARK: - Private

private extension ReviewTableViewCell {

    func setupUI() {
        //userImageView.layer.cornerRadius = 20
        //userImageView.layer.masksToBounds = true
        
        //reviewRatingImageView.layer.cornerRadius = 20
        //reviewRatingImageView.layer.masksToBounds = true
    }
}

