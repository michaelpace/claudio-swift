//
//  Recording.swift
//  Claudio
//
//  Created by Michael Pace on 12/3/17.
//  Copyright © 2017 Michael Pace. All rights reserved.
//

import Foundation
import RealmSwift

/// Model object representing an audio recording.
final class Recording: Object {

    // MARK: - Properties

    /// The recording's primary key.
    @objc dynamic var identifier = ""

    /// The URL to the recording's directory. Defaults to `URL.userDocumentsDirectory.absoluteString`.
    @objc dynamic var directory = URL.userDocumentsDirectory.absoluteString

    /// The recording's path on disk.
    @objc dynamic var path = ""

    override static func primaryKey() -> String? {
        return Key.identifier.rawValue
    }

}

// MARK: - Convenience properties

extension Recording {

    /// A `URL` representation of the recording's directory.
    var directoryURL: URL {
        if let url = URL(string: directory) {
            return url
        } else {
            Logger.log(.error, "Error creating a URL from directory: \(directory)")
            return URL(fileURLWithPath: "")
        }
    }

}

// MARK: - Nested types

extension Recording {

    /// Encapsulates keys for `Recording` properties.
    enum Key: String {
        case identifier = "identifier"
    }

}
