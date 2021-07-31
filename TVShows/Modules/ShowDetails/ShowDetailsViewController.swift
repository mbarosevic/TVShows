//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by mbarosevic on 27.07.2021..
//

import Foundation
import UIKit
import SVProgressHUD

final class ShowDetailsViewController: UIViewController {

    @IBOutlet weak var showDetailsTableView: UITableView!
    @IBOutlet weak var writeReviewButton: UIButton!
    
    var selectedShow: Show?
    private var reviews = [Review]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ShowDetailsVC")
        guard let show = selectedShow, selectedShow != nil else {
            print("Error")
            return
        }
        print(show)
        getReviews()
        setupTableView()
        writeReviewButton.applyCornerRadius(of: 21.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationViewController = segue.destination as! UINavigationController
        let writeReviewViewController = navigationViewController.topViewController as! ShowReviewsViewController
        writeReviewViewController.selectedShow = selectedShow
    }
    
    func getReviews(){
        SVProgressHUD.show()
        APIManager.shared.fetchReviews(
            for: selectedShow!.id,
            completion: { [self] dataResponse in
                SVProgressHUD.dismiss()
                switch dataResponse.result {
                case .success(let response):
                    for review in response.reviews {
                        //shows.append(TVShowItem(name: show.title, image: nil))
                        reviews.append(Review(
                                        id: review.id,
                                        comment: review.comment,
                                        rating: review.rating,
                                        showId: review.showId,
                                        user: review.user))
                    }
                    showDetailsTableView.reloadData()
                case .failure(let error):
                    print("Error \(error)")
                }
            }
        )
    }
}

extension ShowDetailsViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 0
        } else {
            return reviews.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDescription = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DescriptionTableViewCell.self),
            for: indexPath
        ) as! DescriptionTableViewCell

        
        let cellReview = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ReviewTableViewCell.self),
            for: indexPath
        ) as! ReviewTableViewCell

        cellDescription.configure(with: selectedShow!)
        cellReview.configure(with: reviews[indexPath.row])
        
        if indexPath.row == 0 {
            return cellDescription
        } else {
            return cellReview
        }
    }
}

// MARK: - Private
private extension ShowDetailsViewController {

    func setupTableView() {
        print("SETTING UP TABLE VIEW")
        showDetailsTableView.estimatedRowHeight = 110
        showDetailsTableView.rowHeight = UITableView.automaticDimension

        showDetailsTableView.tableFooterView = UIView()

        showDetailsTableView.delegate = self
        showDetailsTableView.dataSource = self
    }
}


