//
//  Decimal+Utility.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/10/24.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        (self as NSDecimalNumber).doubleValue
    }

    func isApproximately(_ value: Decimal) -> Bool {
        abs(self - value) < Constants.margin
    }

    var isEffectivelyZero: Bool {
        self.isZero || isApproximately(0)
    }

    var orNil: Decimal? {
        self.isEffectivelyZero ? nil : self
    }

    private struct Constants {
        static let margin: Decimal = 0.0001
    }
}

extension Optional where Wrapped == Decimal {
    var formattedString: String {
        if let value = self {
            String(format: "%.1f", value.doubleValue)
        } else {
            ""
        }
    }
}
