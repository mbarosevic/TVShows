//
//  TVShowTableViewCell.swift
//  TV Shows
//
//  Created by mbarosevic on 27.07.2021..
//

import UIKit

final class TVShowTableViewCell: UITableViewCell {

    // MARK: - Private UI

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        titleLabel.text = nil
    }
}

// MARK: - Configure

extension TVShowTableViewCell {

    func configure(with item: Show) {
        //thumbnailImageView.image = item.imageUrl ?? UIImage(named: "icImagePlaceholder")
        thumbnailImageView.image = UIImage(named: "icImagePlaceholder")
        titleLabel.text = item.title
    }
}

// MARK: - Private

private extension TVShowTableViewCell {

    func setupUI() {
        thumbnailImageView.layer.cornerRadius = 20
        thumbnailImageView.layer.masksToBounds = true
    }
}
