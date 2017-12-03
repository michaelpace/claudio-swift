//
//  AudioRecorder.swift
//  Claudio
//
//  Created by Michael Pace on 12/1/17.
//  Copyright © 2017 Michael Pace. All rights reserved.
//

import Foundation
import AVFoundation

/// An object that provides methods for recording audio from the microphone.
final class AudioRecorder: NSObject {

    // MARK: - Private properties

    private var avAudioRecorder: AVAudioRecorder?
    private let avAudioRecorderSettings = [
        AVSampleRateKey: NSNumber(value: Float(44100.0)),
        AVFormatIDKey: NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
        AVNumberOfChannelsKey: NSNumber(value: 1),
        AVEncoderAudioQualityKey: NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]

    private let saveDirectory: URL

    // MARK: - Public properties

    /// Whether this `AudioRecorder` is currently recording.
    var isRecording: Bool {
        return avAudioRecorder?.isRecording ?? false
    }

    // MARK: - Initialization

    init(saveDirectory: URL = .userDocumentsDirectory) {
        self.saveDirectory = saveDirectory
    }
}

// MARK: - Internal API

extension AudioRecorder {

    /// Begins recording audio. Returns the path at which the audio will be saved.
    ///
    /// - Returns: The path at which the recorded audio will be saved.
    /// - note: If the user has not granted microphone permissions yet, calling this method will result in a system permission prompt appearing.
    @discardableResult func record() -> String {
        let path = String(describing: Date())
        let url = saveDirectory.appendingPathComponent(path)
        let newAVAudioRecorder = makeAVAudioRecorderWithURL(url)
        avAudioRecorder = newAVAudioRecorder

        AudioSession.shared.mode = .recording
        AudioSession.shared.setSessionActive(true)
        
        guard newAVAudioRecorder.record() else {
            Logger.log(.error, "Failed to record")
            fatalError()
        }

        Logger.log(.debug, "Recording to url: \(url)")

        return path
    }

    /// Stops any recording in progress.
    func stop() {
        Logger.log(.debug, "Stopping recording")
        avAudioRecorder?.stop()
        AudioSession.shared.setSessionActive(false)
    }

}

// MARK: - Private implementation

private extension AudioRecorder {

    func makeAVAudioRecorderWithURL(_ url: URL) -> AVAudioRecorder {
        do {
            let newAVAudioRecorder = try AVAudioRecorder(url: url, settings: avAudioRecorderSettings)
            newAVAudioRecorder.delegate = self

            if newAVAudioRecorder.prepareToRecord() {
                Logger.log(.debug, "Successfully prepared to record")
            } else {
                Logger.log(.debug, "Failed to prepare to record")
            }

            return newAVAudioRecorder
        } catch {
            assertionFailure("Failed to create a new `AVAudioRecorder`: \(error)")
            return AVAudioRecorder()
        }
    }

}

// MARK: - AVAudioRecorderDelegate

extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        Logger.log(.debug, "Recording finished")
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        guard let error = error else { return }
        Logger.log(.error, "Encode error did occur: \(error)")
    }
}
