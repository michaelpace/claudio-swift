//
//  RecordingListViewController.swift
//  Claudio
//
//  Created by Michael Pace on 12/1/17.
//  Copyright © 2017 Michael Pace. All rights reserved.
//

import UIKit

/// A view controller displaying a list of the user's recordings.
final class RecordingListViewController: UITableViewController {

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationItem()
        setUpTableView()
    }

}

// MARK: - Setup

private extension RecordingListViewController {

    func setUpNavigationItem() {
        navigationItem.title = "Claudio"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: self, action: #selector(userDidTap(recordBarButtonItem:)))
    }

    func setUpTableView() {
        tableView.hideEmptyCells()
    }

}

// MARK: - Actions

private extension RecordingListViewController {

    @objc func userDidTap(recordBarButtonItem: UIBarButtonItem) {
        print("TODO: Surface recording interface.")
    }

}
