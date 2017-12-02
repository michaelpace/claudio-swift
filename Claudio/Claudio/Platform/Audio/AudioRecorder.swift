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
    private let meterRefreshFrequencyMilliseconds: Double = 20
    private var highestLevel: Float = Float(-Int.max)
    private var lowestLevel: Float = Float(Int.max)

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

// MARK: - Public API

extension AudioRecorder {

    /// TODO
    ///
    /// - Returns: TODO
    @discardableResult func record() -> String {
        let path = "hi"
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

    /// TODO
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
                Logger.log(.debug, "successfully prepared to record")
            } else {
                Logger.log(.debug, "failed to prepare to record")
            }

            return newAVAudioRecorder
        } catch {
            fatalError()
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
