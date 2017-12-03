//
//  AudioSession.swift
//  Claudio
//
//  Created by Michael Pace on 12/1/17.
//  Copyright © 2017 Michael Pace. All rights reserved.
//

import Foundation
import AVFoundation

/// A class representing an audio session. Access the singleton instance via the static `shared` property.
final class AudioSession {

    // MARK: - Internal properties

    /// The singleton `AudioSession` instance for the application.
    static let shared = AudioSession()

    /// The mode to use for this session. Defaults to `.earpiecePlayback`.
    var mode: Mode = .playback(.earpiece) {
        didSet {
            do {
                try avAudioSession.setCategory(mode.category)
                try avAudioSession.overrideOutputAudioPort(mode.audioPort)
            } catch {
                Logger.log(.error, "Error setting output audio port to \(mode.audioPort) and category to \(mode.category): \(error.localizedDescription)")
            }
        }
    }

    /// Sets the session to be active or inactive.
    ///
    /// - Parameter active: Whether to set the session to active or inactive.
    /// - Returns: Whether setting the active state was successful. It can fail if another app has a higher priority than ours.
    /// - note: This function is an expensive synchronous operation. Be mindful of the thread on which it is called.
    @discardableResult func setSessionActive(_ active: Bool) -> Bool {
        do {
            try avAudioSession.setActive(active)
        } catch {
            Logger.log(.error, "Error setting audio session to \(active ? "active" : "inactive"): \(error.localizedDescription)")
            return false
        }

        return true
    }

    // MARK: - Private properties

    private let avAudioSession: AVAudioSession

    // MARK: - Initializers

    init(avAudioSession: AVAudioSession = .sharedInstance()) {
        self.avAudioSession = avAudioSession
    }

}

// MARK: - Nested types

extension AudioSession {

    /// Encapsulates possible audio modes for this session.
    enum Mode {

        /// A playback mode.
        case playback(_: Playback)

        /// A recording mode.
        case recording

        /// The port to use for this `Mode`.
        fileprivate var audioPort: AVAudioSessionPortOverride {
            switch self {
            case .recording:
                return .none

            case let .playback(playbackMode):
                switch playbackMode {
                case .earpiece:
                    return .none
                case .speaker:
                    return .speaker
                }
            }
        }

        /// The category string for this `Mode`. The category identifies the set of audio capabilities we request from the hardware.
        fileprivate var category: String {
            switch self {
            case .playback:
                return AVAudioSessionCategoryPlayAndRecord
            case .recording:
                return AVAudioSessionCategoryRecord
            }
        }

        /// Encapsulates possible playback modes of this session.
        enum Playback {

            /// A playback mode which routes audio through the phone's earpiece.
            case earpiece

            /// A playback mode which routes audio through the phone's speaker.
            case speaker
        }
    }

}
