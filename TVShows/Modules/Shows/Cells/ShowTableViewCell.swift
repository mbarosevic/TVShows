//
//  TVShowTableViewCell.swift
//  TV Shows
//
//  Created by mbarosevic on 27.07.2021..
//

import UIKit
import Kingfisher
final class ShowTableViewCell: UITableViewCell {

    // MARK: - Interface Builder Outlets
    @IBOutlet private weak var showImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        showImageView.image = nil
        titleLabel.text = nil
    }
    
    // MARK: - Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: 10,
                left: 0,
                bottom: 10,
                right: 0))
    }
}

// MARK: - Configure Table View Cell
extension ShowTableViewCell {

    func configure(with item: Show) {
        showImageView.kf.setImage(
            with: URL(string: item.imageUrl),
            placeholder: UIImage(named: "ic-show-placeholder-vertical")
        )
        titleLabel.text = item.title
    }
}

// MARK: - Setup User Interface
private extension ShowTableViewCell {

    func setupUI() {
        showImageView.layer.cornerRadius = 10
        showImageView.layer.masksToBounds = true
    }
}
