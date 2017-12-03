//
//  DataStoring.swift
//  Claudio
//
//  Created by Michael Pace on 12/3/17.
//  Copyright © 2017 Michael Pace. All rights reserved.
//

import Foundation

/// TODO
protocol DataStoring {

    // TODO: Start here. Define a protocol which will serve as a contract for any database solution.

    func write(_ block: () -> Void)

}
