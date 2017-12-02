//
//  AudioPlayer.swift
//  Claudio
//
//  Created by Michael Pace on 12/1/17.
//  Copyright © 2017 Michael Pace. All rights reserved.
//

import Foundation
import AVFoundation

/// TODO
final class AudioPlayer: NSObject {

    // MARK: - Private properties

    private var avAudioPlayer: AVAudioPlayer?
    private let saveDirectory: URL

    // MARK: - Public properties

    /// TODO
    var isPlaying: Bool {
        return avAudioPlayer?.isPlaying ?? false
    }

    // MARK: - Initialization

    init(saveDirectory: URL = .userDocumentsDirectory) {
        self.saveDirectory = saveDirectory
    }
}

// MARK: - Internal API

extension AudioPlayer {

    /// TODO
    ///
    /// - Parameter path: TODO
    func play(_ path: String) {
        let url = saveDirectory.appendingPathComponent(path)
        Logger.log(.debug, "Playing url \(url)")
        
        AudioSession.shared.mode = .earpiecePlayback
        AudioSession.shared.setSessionActive(true)

        if avAudioPlayer?.url != url {
            avAudioPlayer = makeAVAudioPlayerWithURL(url)
        }

        avAudioPlayer?.play()
    }

    /// TODO
    func pause() {
        Logger.log(.debug, "Pausing playback")
        avAudioPlayer?.pause()
    }

    /// TODO
    func stop() {
        Logger.log(.debug, "Stopping playback")

        avAudioPlayer?.stop()
        AudioSession.shared.setSessionActive(false)
        avAudioPlayer?.currentTime = 0
    }

}

// MARK: - Private implementation

private extension AudioPlayer {

    func makeAVAudioPlayerWithURL(_ url: URL) -> AVAudioPlayer {
        do {
            let newAVAudioPlayer = try AVAudioPlayer(contentsOf: url)
            newAVAudioPlayer.delegate = self
            return newAVAudioPlayer
        } catch {
            fatalError("Error creating a new av audio player: \(error)")
        }
    }

}

// MARK: - AVAudioPlayerDelegate

extension AudioPlayer: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Logger.log(.debug, "Did finish playing")
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        guard let error = error else { return }
        Logger.log(.debug, "Decode error did occur: \(error)")
    }
    
}
