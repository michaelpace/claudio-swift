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

    // MARK: - Private properties

    private let recorder = AudioRecorder()
    private let player = AudioPlayer()
    private var mostRecentRecordingPath: String?

}

// MARK: - UIViewController

extension RecordingListViewController {

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
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(userDidTap(playBarButtonItem:))),
                                             UIBarButtonItem(title: "Source", style: .plain, target: self, action: #selector(userDidTap(togglePlaybackSourceBarButtonItem:)))]
    }

    func setUpTableView() {
        tableView.hideEmptyCells()
    }

}

// MARK: - Actions

private extension RecordingListViewController {

    @objc func userDidTap(recordBarButtonItem: UIBarButtonItem) {
        if recorder.isRecording {
            recorder.stop()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: self, action: #selector(userDidTap(recordBarButtonItem:)))
        } else {
            mostRecentRecordingPath = recorder.record()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(userDidTap(recordBarButtonItem:)))
        }
    }

    @objc func userDidTap(playBarButtonItem: UIBarButtonItem) {
        guard let recordingPath = mostRecentRecordingPath else { return }
        player.play(recordingPath)
    }

    @objc func userDidTap(togglePlaybackSourceBarButtonItem: UIBarButtonItem) {
        player.togglePlaybackMode()
    }

}
