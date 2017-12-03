//
//  DataStoring.swift
//  Claudio
//
//  Created by Michael Pace on 12/3/17.
//  Copyright © 2017 Michael Pace. All rights reserved.
//

import Foundation
import RealmSwift

/// Describes a type which has methods to store, retrieve, and delete data models.
protocol DataStoring {

    /// Updates the contents of the data store per the changes in `block`.
    ///
    /// - Parameter block: A block that will be executed to update the data store.
    func write(_ block: () -> Void)

    /// Retrieves objects of the specified type, optionally filtered with `filter`.
    ///
    /// - Parameters:
    ///   - type: The type of the objects to retrieve.
    ///   - filter: An optional filter to use when retrieving models.
    /// - Returns: An array of objects of type `type` which match `filter` if it's not `nil`.
    func retrieveObjects<TypeToRetrieve: Object>(type: TypeToRetrieve.Type, filter: NSPredicate?) -> [TypeToRetrieve]

    /// Deletes the object from the data store.
    ///
    /// - Parameter model: The object to delete from the data store.
    func delete(_ model: Object)

    /// Deletes the objects from the data store.
    ///
    /// - Parameter models: The objects to delete from the data store.
    func delete(_ models: [Object])

}
