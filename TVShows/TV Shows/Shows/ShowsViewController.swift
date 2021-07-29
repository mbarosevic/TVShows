//
//  HomeViewController.swift
//  TV Shows
//
//  Created by mbarosevic on 20.07.2021..
//

import Foundation
import UIKit
import SVProgressHUD

final class ShowsViewController: UIViewController {
    
    // MARK: - Private UI
    @IBOutlet private weak var tableView: UITableView!

    var selectedShow: Show?
    private var shows = [Show]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getShows()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Shows"
        navigationItem.backBarButtonItem = backItem
        guard let selectedShow = sender as? Show else { return  }
        let secondViewController = segue.destination as! ShowDetailsViewController
        secondViewController.selectedShow = selectedShow
    }
    
    func getShows() {
        SVProgressHUD.show()
        APIManager.shared.fetchShows(
            completion: { [self] dataResponse in
                SVProgressHUD.dismiss()
                switch dataResponse.result {
                case .success(let response):
                    // not prefered in iOS - for loop
                    // add forEach
                    // response.shows.forEach...
                    
                    // declarative function - map, flatMap and compactMap
                    // shows = response.shows.map ({ show -> Show in return Show((id:.., title:))
                    //})
                    for show in response.shows {
                        shows.append(Show(id: show.id, title: show.title, averageRating: show.averageRating, description: show.description, imageUrl: show.imageUrl, numOfReviews: show.numOfReviews))
                    }
                    tableView.reloadData()
                case .failure(let error):
                    print("Error \(error)")
                }
            }
        )
    }
}

// MARK: - UITableView
extension ShowsViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //let item = items[indexPath.row]
        
        let item = shows[indexPath.row]
        //print("Selected Item: \(item)")
        self.selectedShow = item
        
        self.performSegue(withIdentifier: "segueIdentifier", sender: item)
        print("performin segue for: \(item)")
    }
}

extension ShowsViewController: UITableViewDataSource {

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TVShowTableViewCell.self),
            for: indexPath
        ) as! TVShowTableViewCell

        //cell.configure(with: items[indexPath.row])
        cell.configure(with: shows[indexPath.row])


        return cell
    }
}

// MARK: - Private

private extension ShowsViewController {

    func setupTableView() {
        print("SETTING UP TABLE VIEW")
        
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension

        tableView.tableFooterView = UIView()

        tableView.delegate = self
        tableView.dataSource = self
    }
}

