//
//  String+Capitalize.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/10/24.
//

import Foundation

extension String {
    var capitalizingFirstLetter: String {
        prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter
    }
}

extension String.SubSequence {
    var capitalizingFirstLetter: String {
        prefix(1).capitalized + dropFirst()
    }
}
