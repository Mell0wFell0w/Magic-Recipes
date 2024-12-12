//
//  String+Utility.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/10/24.
//

import Foundation

extension String {
    var decimal: Decimal {
        Decimal(string: self) ?? 0
    }

    var decimalOrNil: Decimal? {
        Decimal(string: self)?.orNil
    }

    var intOrNil: Int? {
        Int(self)?.orNil
    }

    var orNil: String? {
        self.isEmpty ? nil : self
    }

    var specified: String {
        self == Constants.unspecified ? "" : self
    }
}
