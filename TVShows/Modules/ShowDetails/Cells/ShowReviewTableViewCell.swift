//
//  ReviewTableViewCell.swift
//  TV Shows
//
//  Created by mbarosevic on 27.07.2021..
//

import UIKit
import Kingfisher

final class ShowReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userCommentLabel: UILabel!
    @IBOutlet weak var userShowRating: RatingSmallPredefinedController!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
        userEmailLabel.text = nil
        userCommentLabel.text = nil
    }
}

// MARK: - Configure

extension ShowReviewTableViewCell {

    func configure(with review: Review) {
        userImageView.image = UIImage(named: "ic-profile-placeholder")
        if let userImage = review.user.imageUrl {
            userImageView.kf.setImage(
                with:
                    URL(
                        string: userImage),
                placeholder:
                    UIImage(
                        named: "ic-profile-placeholder")
            )
        }
        userEmailLabel.text = review.user.email
        userShowRating.setStarsRating(rating: Int(review.rating))
        userCommentLabel.text = review.comment
    }
}

// MARK: - Private

private extension ShowReviewTableViewCell {

    func setupUI() {
        userImageView.layer.cornerRadius = 20
        userImageView.layer.masksToBounds = true
    }
}

class RatingSmallPredefinedController: UIStackView {
    var starsRating = 0
    var starsEmptyPicName = "ic-star-deselected"
    var starsFilledPicName = "ic-star-selected"
    
    override func draw(_ rect: CGRect) {
        let starButtons = self.subviews.filter{$0 is UIButton}
        var starTag = 1
        for button in starButtons {
            if let button = button as? UIButton{
                button.setImage(UIImage(named: starsEmptyPicName), for: .normal)
                button.tag = starTag
                starTag = starTag + 1
            }
        }
       setStarsRating(rating:starsRating)
    }
    
    func setStarsRating(rating:Int){
        self.starsRating = rating
        let stackSubViews = self.subviews.filter{$0 is UIButton}
        for subView in stackSubViews {
            if let button = subView as? UIButton{
                if button.tag > starsRating {
                    button.setImage(UIImage(named: starsEmptyPicName), for: .normal)
                } else {
                    button.setImage(UIImage(named: starsFilledPicName), for: .normal)
                }
            }
        }
    }
}
