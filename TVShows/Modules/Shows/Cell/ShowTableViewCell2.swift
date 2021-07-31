//
//  ShowTableViewCell.swift
//  TV Shows
//
//  Created by Filip Gulan on 21.07.2021..
//

import UIKit
import Kingfisher

class ShowTableViewCell2: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    //@IBOutlet private var ratingView: RatingView!
    @IBOutlet private var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //ratingView.configure(withStyle: .small)
        //ratingView.isEnabled = false
    }

    func configure(with show: Show) {
        titleLabel.text = show.title
        //ratingView.setRoundedRating(show.rating)
    }

//    func configure(with show: Show) {
//        titleLabel.text = show.title
//        ratingView.setRoundedRating(show.rating)
//
//        if let url = show.imageUrl {
//            let data = try? Data(contentsOf: url)
//            if let imageData = data {
//                let image = UIImage(data: imageData)
//                iconImageView.image = image
//            }
//        }
//    }

//    func configure(with show: Show) {
//        titleLabel.text = show.title
//        ratingView.setRoundedRating(show.rating)
//
//        DispatchQueue.global(qos: .userInteractive).async {
//            if let url = show.imageUrl {
//                let data = try? Data(contentsOf: url)
//                if let imageData = data {
//                    let image = UIImage(data: imageData)
//                    DispatchQueue.main.async {
//                        self.iconImageView.image = image
//                    }
//                }
//            }
//        }
//    }

//    func configure(with show: Show) {
//        titleLabel.text = show.title
//        ratingView.setRoundedRating(show.rating)
//        iconImageView.kf.setImage(with: show.imageUrl)
//    }
}
