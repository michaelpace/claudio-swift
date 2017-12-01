//
//  UITableView+Setup.swift
//  Claudio
//
//  Created by Michael Pace on 12/1/17.
//  Copyright © 2017 Michael Pace. All rights reserved.
//

import UIKit

/// Extension providing convenience methods to use when configuring a table view.
extension UITableView {

    /// Hides the empty cells at the bottom of the table view.
    func hideEmptyCells() {
        tableFooterView = UIView()
    }

}
