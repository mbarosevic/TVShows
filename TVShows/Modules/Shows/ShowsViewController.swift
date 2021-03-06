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
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name:NSNotification.Name("Logout"), object: nil)
        getShows()
        setNavigationItem()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Shows"
        navigationItem.backBarButtonItem = backItem
        guard let selectedShow = sender as? Show else { return  }
        let secondViewController = segue.destination as! ShowDetailsViewController
        secondViewController.selectedShow = selectedShow
    }
    

}

// MARK: - Private

private extension ShowsViewController {

    private func setNavigationItem() {
        let profileButton = UIBarButtonItem(
            image: UIImage(named: "ic-profile"),
            style: .plain,
            target: self,
            action: #selector(profileDetailsActionHandler)
        )
        profileButton.tintColor = hexStringToUIColor(hex: "#52368C")
        self.navigationItem.rightBarButtonItem = profileButton
    }
    
    private func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @objc func profileDetailsActionHandler() {
        print("Going to my account screen")
        
        let storyboard = UIStoryboard(name: "Account", bundle: .main)
        let accountViewController = storyboard.instantiateViewController(
            withIdentifier: String(describing: AccountViewController.self)) as! AccountViewController
        //self.present(accountViewController, animated: true, completion: nil)
        
        
        
        let navigationController = UINavigationController(rootViewController: accountViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func didLogout() {
        let storyboard = UIStoryboard(name: "Login", bundle: .main)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
        navigationController?.setViewControllers([loginViewController], animated: false)
    }
    
    private func setupTableView() {
        //tableView.estimatedRowHeight = 110
        //tableView.rowHeight = UITableView.automaticDimension

        //tableView.tableFooterView = UIView()

        tableView.delegate = self
        tableView.dataSource = self
    }
}

private extension ShowsViewController {
    
    private func getShows() {
        self.showLoading()
        APIManager.shared.fetchShows(
            completion: { [weak self] dataResponse in
                guard let self = self else { return }
                self.hideLoading()
                switch dataResponse.result {
                case .success(let response):
                    self.shows = response.shows
                    self.tableView.reloadData()
                case .failure(let error):
                    self.showFailure(with: error)
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
        self.selectedShow = item
        self.performSegue(withIdentifier: "segueIdentifier", sender: item)
    }
}

extension ShowsViewController: UITableViewDataSource {

    // MARK: - UITableViewDataSource
    //func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
    //}

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ShowTableViewCell.self),
            for: indexPath
        ) as! ShowTableViewCell

        //cell.configure(with: items[indexPath.row])
        cell.configure(with: shows[indexPath.row])


        return cell
    }
}

extension ShowsViewController: ProgressReporting {
    
}

