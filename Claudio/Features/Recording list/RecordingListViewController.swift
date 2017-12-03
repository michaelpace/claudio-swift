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
    private let dataStore = DataStore()

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
                                             UIBarButtonItem(title: "Source", style: .plain, target: self, action: #selector(userDidTap(togglePlaybackSourceBarButtonItem:))),
                                             UIBarButtonItem(title: "List", style: .plain, target: self, action: #selector(userDidTap(listBarButtonItem:)))]
    }

    func setUpTableView() {
        tableView.hideEmptyCells()
    }

}

// MARK: - Actions

private extension RecordingListViewController {

    @objc func userDidTap(recordBarButtonItem: UIBarButtonItem) {
        if recorder.isRecording {
            // TODO: Check if this is an expensive operation. If so, create convenience asynchronous way to stop recording audio, with a callback block once it has stopped.
            recorder.stop()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: self, action: #selector(userDidTap(recordBarButtonItem:)))
        } else {
            // TODO: Create convenience asynchronous way to record audio, with a callback block once the recording has begun.
            let path = recorder.record()
            mostRecentRecordingPath = path
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(userDidTap(recordBarButtonItem:)))

            let recording = Recording()
            // TODO: Create convenience way to make a `Recording` with the path as the identifier? Actually, it should just be a random hash that happens automatically.
            recording.identifier = path
            recording.path = path
            // TODO: Create convenience asynchronous way to create and write objects.
            dataStore.create(recording)
        }
    }

    @objc func userDidTap(playBarButtonItem: UIBarButtonItem) {
        guard let recordingPath = mostRecentRecordingPath else { return }
        // TODO: Check if this is an expensive operation. If so, create convenience asynchronous way to play audio, with a callback block once it has begun playing.
        player.play(recordingPath)
    }

    @objc func userDidTap(togglePlaybackSourceBarButtonItem: UIBarButtonItem) {
        player.togglePlaybackMode()
    }

    @objc func userDidTap(listBarButtonItem: UIBarButtonItem) {
        // TODO: Create convenience asynchronous way to retrieve objects.
        let recordings = dataStore.retrieveObjects(type: Recording.self)
        recordings.forEach { print($0.path) }
    }

}
