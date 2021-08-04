//
//  ProgressReporting.swift
//  TV Shows
//
//  Created by FOI on 31.07.2021..
//

import UIKit

protocol ProgressReporting: AnyObject {
    func showLoading()
    func hideLoading()
    func showSuccess()
    func showLoading(blocking: Bool)
    func showFailure(with error: Error)
    func showFailure(with title: String?, message: String?)
}

extension ProgressReporting {
    func showSuccess() {}
    func showLoading(blocking: Bool) {}
    func showFailure(with error: Error) {}
    func showFailure(with title: String?, message: String?) {}
}

protocol Refreshable {
    var refreshControl: UIRefreshControl { get }
}

extension Refreshable {

    func endRefreshing() {
        refreshControl.endRefreshing()
    }

    func endRefreshingSafely() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}
