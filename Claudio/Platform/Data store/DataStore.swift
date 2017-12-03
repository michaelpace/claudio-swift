//
//  DataStore.swift
//  Claudio
//
//  Created by Michael Pace on 12/3/17.
//  Copyright © 2017 Michael Pace. All rights reserved.
//

import Foundation
import RealmSwift

/// A data store for storing model objects.
final class DataStore: DataStoring {

    func write(_ block: () -> Void) {
        do {
            try realm.write(block)
        } catch {
            Logger.log(.error, "Error performing a write block: \(error.localizedDescription)")
        }
    }

    func retrieveObjects<TypeToRetrieve: Object>(type: TypeToRetrieve.Type, filter: NSPredicate? = nil) -> [TypeToRetrieve] {
        let results: Results<TypeToRetrieve> = {
            if let filter = filter {
                return realm.objects(type).filter(filter)
            } else {
                return realm.objects(type)
            }
        }()

        return results.map { $0 }
    }

    func delete(_ model: Object) {
        write {
            realm.delete(model)
        }
    }

    func delete(_ models: [Object]) {
        write {
            realm.delete(models)
        }
    }

}

// MARK: - Private

private extension DataStore {

    var realm: Realm! {
        do {
            return try Realm()
        } catch {
            Logger.log(.error, "Error creating a `Realm` instance: \(error.localizedDescription)")
            return nil
        }
    }

}
