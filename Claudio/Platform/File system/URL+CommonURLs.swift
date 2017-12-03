//
//  URL+CommonURLs.swift
//  Claudio
//
//  Created by Michael Pace on 12/2/17.
//  Copyright © 2017 Michael Pace. All rights reserved.
//

import Foundation

/// An extension on `URL` which provides convenience methods and properties for dealing with common URLs.
extension URL {

    /// The URL to use for user documents.
    static var userDocumentsDirectory: URL {
        let possibleURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        guard let url = possibleURLs.first else {
            Logger.log(.error, "Error creating URL to documents directory.")
            assertionFailure()
            return URL(fileURLWithPath: "")
        }

        return url
    }

}
