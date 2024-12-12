//
//  Int+Utility.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/10/24.
//

import Foundation

extension Int {
    var orNil: Int? {
        self == .zero ? nil : self
    }
}
