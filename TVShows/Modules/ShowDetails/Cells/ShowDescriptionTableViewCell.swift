//
//  DescriptionTableViewCell.swift
//  TV Shows
//
//  Created by mbarosevic on 27.07.2021..
//

import UIKit

final class ShowDescriptionTableViewCell: UITableViewCell {


    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var showDescriptionTextView: UITextView!
    @IBOutlet weak var showReviewsLabel: UILabel!
    @IBOutlet weak var showStarsRating: RatingPredefinedController!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showTitleLabel.text = nil
        showImageView.image = nil
        showDescriptionTextView.text = nil
        showReviewsLabel.text = nil
    }
}

// MARK: - Configure

extension ShowDescriptionTableViewCell {

    func configure(with item: Show) {
        showTitleLabel.text = item.title
        showImageView.image = UIImage(named: "icImagePlaceholder")
        showDescriptionTextView.text = item.description

        if let averageRating = item.averageRating {
            showStarsRating.setStarsRating(rating: Int(round(averageRating)))
            showReviewsLabel.text = "\(item.numOfReviews) REVIEWS, \(averageRating) AVERAGE"
        }
    }
}

// MARK: - Private

private extension ShowDescriptionTableViewCell {

    func setupUI() {
        showDescriptionTextView.isUserInteractionEnabled = false
        showImageView.layer.cornerRadius = 20
        showImageView.layer.masksToBounds = true
    }
}

class RatingPredefinedController: UIStackView {
    var starsRating = 0
    var starsEmptyPicName = "ic-star-deselected-large"
    var starsFilledPicName = "ic-star-selected-large"
    
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
                }else{
                    button.setImage(UIImage(named: starsFilledPicName), for: .normal)
                }
            }
        }
    }
}
