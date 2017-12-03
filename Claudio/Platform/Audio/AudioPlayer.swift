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

    // MARK: - Internal properties

    /// Whether this `AudioPlayer` is currently playing any audio.
    var isPlaying: Bool {
        return avAudioPlayer?.isPlaying ?? false
    }

    /// The playback mode to use. Defaults to `.earpiece`.
    var playbackMode: AudioSession.Mode.Playback = .earpiece {
        didSet {
            audioSession.mode = .playback(playbackMode)
        }
    }

    // MARK: - Private properties

    private var avAudioPlayer: AVAudioPlayer?
    private let playbackDirectory: URL
    private let audioSession: AudioSession

    // MARK: - Initialization

    /// Initializes a new `AudioPlayer`.
    ///
    /// - Parameter playbackDirectory: A URL pointing to the directory in which to locate files for playback. Defaults to `.userDocumentsDirectory`.
    /// - Parameter audioSession: The audio session to use for playback. Defaults to `.shared`.
    init(playbackDirectory: URL = .userDocumentsDirectory, audioSession: AudioSession = .shared) {
        self.playbackDirectory = playbackDirectory
        self.audioSession = audioSession
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

        audioSession.mode = .playback(playbackMode)
        audioSession.setSessionActive(true)

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
        audioSession.setSessionActive(false)
        avAudioPlayer?.currentTime = 0
    }

    /// Toggles the `playbackMode` property between its valid values.
    func togglePlaybackMode() {
        playbackMode = (playbackMode == .earpiece) ? .speaker : .earpiece
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
            assertionFailure("Error creating a new `AVAudioPlayer`: \(error.localizedDescription)")
            return AVAudioPlayer()
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
        Logger.log(.debug, "Decode error did occur: \(error.localizedDescription)")
    }
    
}
