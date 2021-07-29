//
//  ShowReviewsViewController.swift
//  TV Shows
//
//  Created by mbarosevic on 29.07.2021..
//

import Foundation
import UIKit
import SVProgressHUD

class ShowReviewsViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var closeModalButton: UIBarButtonItem!
    @IBOutlet weak var rating: RatingController!
    @IBOutlet weak var submitReviewButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    
    var selectedShow: Show?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitReview(_ sender: Any) {
        guard let comment = commentTextView.text, !comment.isEmpty, comment != "Enter your comment here..." else {
            showAlertWith(message: "Please write a comment")
            return
        }
        
        guard let ratingValue = rating, rating.starsRating != 0 else {
            showAlertWith(message: "Please rate the show with stars")
            return
        }
        
        APIManager.shared.submitReview(
            with: ReviewParameters(comment: comment, rating: String(ratingValue.starsRating), show_id: selectedShow!.id),
            completion: { dataResponse in
                SVProgressHUD.dismiss()
                switch dataResponse.result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print("Error \(error)")
                }
            }
        )
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showAlertWith(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    
    private func setupUI() {
        commentTextView.delegate = self
        submitReviewButton.applyCornerRadius(of: 21.5)
        commentTextView.layer.cornerRadius = 5
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = .black
    }
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
                }else{
                    button.setImage(UIImage(named: starsFilledPicName), for: .normal)
                }
            }
        }
    }
    
    @objc func pressed(sender: UIButton) {
        setStarsRating(rating: sender.tag)
    }
}


