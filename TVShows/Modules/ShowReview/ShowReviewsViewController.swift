//
//  ShowReviewsViewController.swift
//  TV Shows
//
//  Created by mbarosevic on 29.07.2021..
//

import Foundation
import UIKit
import SVProgressHUD

final class ShowReviewsViewController: UIViewController {
    
    @IBOutlet private weak var closeModalButton: UIBarButtonItem!
    @IBOutlet private weak var rating: RatingController!
    @IBOutlet private weak var submitReviewButton: UIButton!
    @IBOutlet private weak var commentTextView: UITextView!
    
    var selectedShow: Show?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction private func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func submitReview() {
        guard let comment = commentTextView.text, !comment.isEmpty, comment != "Enter your comment here..." else {
            self.showFailure(with: "Error", message: "Please write a comment")
            return
        }
        
        guard let ratingValue = rating, rating.starsRating != 0 else {
            self.showFailure(with: "Error", message: "Please rate the show with stars")
            return
        }
        
        guard let showId = selectedShow?.id else {
            self.showFailure(with: "Error", message: "Bad request")
            return
        }
        
        submitReview(for: showId, with: comment, with: String(ratingValue.starsRating))
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension ShowReviewsViewController {
    
    private func setupUI() {
        commentTextView.delegate = self
        submitReviewButton.applyCornerRadius(of: 21.5)
        commentTextView.layer.cornerRadius = 5
    }
    
    private func submitReview(for showId: String, with comment: String, with rating: String) {
        self.showLoading()
        APIManager.shared.submitReview(comment: comment, rating: rating, showId: showId,
            completion: { [weak self] dataResponse in
                guard let self = self else { return }
                self.hideLoading()
                switch dataResponse.result {
                case .success:
                    NotificationCenter.default.post(name: NSNotification.Name("NSNotif"), object: nil)
                case .failure(let error):
                    self.showFailure(with: error)
                }
            }
        )
    }
}

extension ShowReviewsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = .black
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
}

extension ShowReviewsViewController: ProgressReporting {
    
}

class RatingController: UIStackView {
    var starsRating = 0
    var starsEmptyPicName = "ic-star-deselected-large"
    var starsFilledPicName = "ic-star-selected-large"
    
    override func draw(_ rect: CGRect) {
        let starButtons = self.subviews.filter{$0 is UIButton}
        var starTag = 1
        for button in starButtons {
            if let button = button as? UIButton{
                button.setImage(UIImage(named: starsEmptyPicName), for: .normal)
                button.addTarget(self, action: #selector(self.pressed(sender:)), for: .touchUpInside)
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
    
    @objc func pressed(sender: UIButton) {
        setStarsRating(rating: sender.tag)
    }
}





