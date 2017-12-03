//
//  AudioPlayer.swift
//  Claudio
//
//  Created by Michael Pace on 12/1/17.
//  Copyright © 2017 Michael Pace. All rights reserved.
//

import Foundation
import AVFoundation

/// A class which can play audio.
final class AudioPlayer: NSObject {

    // MARK: - Private properties

    private var avAudioPlayer: AVAudioPlayer?
    private let playbackDirectory: URL

    // MARK: - Public properties

    /// Whether this `AudioPlayer` is currently playing any audio.
    var isPlaying: Bool {
        return avAudioPlayer?.isPlaying ?? false
    }

    // MARK: - Initialization

    /// Initializes a new `AudioPlayer`.
    ///
    /// - Parameter playbackDirectory: A URL pointing to the directory in which to locate files for playback. Defaults to `.userDocumentsDirectory`.
    init(playbackDirectory: URL = .userDocumentsDirectory) {
        self.playbackDirectory = playbackDirectory
    }
}

// MARK: - Internal API

extension AudioPlayer {

    /// Plays the audio at the given path.
    ///
    /// - Parameter path: The path for which to play audio.
    func play(_ path: String) {
        let url = playbackDirectory.appendingPathComponent(path)
        Logger.log(.debug, "Playing url \(url)")

        // TODO: Figure out how to represent & persist playback source.
        AudioSession.shared.mode = .earpiecePlayback
        AudioSession.shared.setSessionActive(true)

        if avAudioPlayer?.url != url {
            avAudioPlayer = makeAVAudioPlayerWithURL(url)
        }

        avAudioPlayer?.play()
    }

    /// Pauses the currently playing audio. Call `play(_:)` again to resume playback.
    func togglePauseState() {
        if isPlaying {
            Logger.log(.debug, "Pausing playback")
            avAudioPlayer?.pause()
        } else {
            Logger.log(.debug, "Resuming playback")
            avAudioPlayer?.play()
        }
    }

    /// Stops playback.
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
