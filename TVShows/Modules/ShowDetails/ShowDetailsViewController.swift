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

    @IBOutlet private weak var showDetailsTableView: UITableView!
    @IBOutlet private weak var writeReviewButton: UIButton!

    var selectedShow: Show?
    private var reviews = [Review]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didWriteAReview), name:NSNotification.Name("NSNotif"), object: nil)

        guard let show = selectedShow, selectedShow != nil else {
            self.showFailure(with: "Error", message: "Bad request")
            return
        }
        print(show)
        setupUI()
        getReviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationViewController = segue.destination as! UINavigationController
        let writeReviewViewController = navigationViewController.topViewController as! ShowReviewsViewController
        writeReviewViewController.selectedShow = selectedShow
    }
    
    @objc func didWriteAReview() {
        getShowAfterReview()
        getReviews()
    }
}

private extension ShowDetailsViewController {
    
    private func getShowAfterReview() {
        self.showLoading()
        APIManager.shared.fetchShow(for: selectedShow!.id,
            completion: { [weak self] dataResponse in
                guard let self = self else { return }
                self.hideLoading()
                switch dataResponse.result {
                case .success(let response):
                    // updated show (avg rating, num of comments)
                    self.selectedShow = response.show
                case .failure(let error):
                    self.showFailure(with: error)
                }
            }
        )
    }
    
    private func getReviews(){
        self.showLoading()
        APIManager.shared.fetchReviews(
            for: selectedShow!.id,
            completion: { [weak self] dataResponse in
                guard let self = self else { return }
                self.hideLoading()
                switch dataResponse.result {
                case .success(let response):
                    self.reviews.removeAll()
                    self.reviews = response.reviews
                    self.setupTableView()
                    self.showDetailsTableView.reloadData()
                case .failure(let error):
                    self.showFailure(with: error)
                }
            }
        )
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        } else {
            return reviews.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && indexPath.section == 0 {
            let cellDescription = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ShowDescriptionTableViewCell.self),
                for: indexPath
            ) as! ShowDescriptionTableViewCell
            cellDescription.configure(with: selectedShow!)
            
            return cellDescription
        } else {
            let cellReview = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ShowReviewTableViewCell.self),
                for: indexPath
            ) as! ShowReviewTableViewCell
            cellReview.configure(with: reviews[indexPath.row])

            return cellReview
        }
    }
}

// MARK: - Private
private extension ShowDetailsViewController {

    private func setupUI() {
        self.title = selectedShow?.title
        writeReviewButton.applyCornerRadius(of: 21.5)
    }
    
    private func setupTableView() {
        showDetailsTableView.estimatedRowHeight = 110
        showDetailsTableView.rowHeight = UITableView.automaticDimension

        showDetailsTableView.tableFooterView = UIView()

        showDetailsTableView.dataSource = self
    }
}

extension ShowDetailsViewController: ProgressReporting {
    
}



