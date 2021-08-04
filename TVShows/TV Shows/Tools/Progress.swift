//
//  Progress.swift
//  TV Shows
//
//  Created by FOI on 31.07.2021..
//

import UIKit
import SVProgressHUD

extension ProgressReporting where Self: UIViewController {

    func showLoading() {
        showLoading(blocking: false)
    }

    func showLoading(blocking: Bool) {
        // Remove previously added so we don't need to take care about
        // multiple async calls to show loading
        SVProgressHUD.setDefaultMaskType(blocking ? .clear : .none)
        SVProgressHUD.dismiss()
        SVProgressHUD.show()
    }

    func hideLoading() {
        hideLoading(blocking: true)
    }

    func hideLoading(blocking: Bool) {
        _stopRefreshingIfNeeded()
        SVProgressHUD.dismiss()
    }

    func showSuccess() {
        // Do nothing for now
    }

    func showFailure(with title: String?, message: String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertView, animated: true, completion: nil)
    }

    func showFailure(with error: Error) {
        showFailure(with: nil, message: error.localizedDescription)
    }

    private func _stopRefreshingIfNeeded() {
        // Check if refresh control is refreshing before calling endRefreshing,
        // otherwise it will result in wierd glitch while scrolling and reloading
        if let refreshable = self as? Refreshable,
            refreshable.refreshControl.isRefreshing {
            refreshable.endRefreshing()
        }
    }
}
