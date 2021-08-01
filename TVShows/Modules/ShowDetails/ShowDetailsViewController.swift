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
        NotificationCenter.default.addObserver(self, selector: #selector(didWriteAReview), name:NSNotification.Name("NSNotif"), object: nil)

        guard let show = selectedShow, selectedShow != nil else {
            print("Error")
            return
        }
        print(show)
        self.title = selectedShow?.title
        setupUI()
        getReviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: false)
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
    
    func getShowAfterReview() {
        APIManager.shared.fetchShow(for: selectedShow!.id,
            completion: { [weak self] dataResponse in
                guard let self = self else { return }
                //self.hideLoading()
                switch dataResponse.result {
                case .success(let response):
                    // updated show (avg rating, num of comments)
                    self.selectedShow = response.show
                case .failure(let error):
                    print(error)
                }
            }
        )
    }
    
    func getReviews(){
        SVProgressHUD.show()
        APIManager.shared.fetchReviews(
            for: selectedShow!.id,
            completion: { [self] dataResponse in
                SVProgressHUD.dismiss()
                switch dataResponse.result {
                case .success(let response):
                    reviews.removeAll()
                    reviews = response.reviews
                    setupTableView()
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
            return 1
        } else {
            return reviews.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDescription = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ShowDescriptionTableViewCell.self),
            for: indexPath
        ) as! ShowDescriptionTableViewCell

        
        let cellReview = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ShowReviewTableViewCell.self),
            for: indexPath
        ) as! ShowReviewTableViewCell
        
        cellDescription.configure(with: selectedShow!)
        cellReview.configure(with: reviews[indexPath.row])
        
        if indexPath.row == 0 && indexPath.section == 0 {
            return cellDescription
        } else {
            return cellReview
        }
    }
}

// MARK: - Private
private extension ShowDetailsViewController {

    func setupUI() {
        writeReviewButton.applyCornerRadius(of: 21.5)
    }
    
    func setupTableView() {
        showDetailsTableView.estimatedRowHeight = 110
        showDetailsTableView.rowHeight = UITableView.automaticDimension

        showDetailsTableView.tableFooterView = UIView()

        showDetailsTableView.delegate = self
        showDetailsTableView.dataSource = self
    }
}


