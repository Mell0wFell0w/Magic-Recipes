//
//  Double+Utility.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/11/24.
//

import Foundation

extension Double {
    func isApproximately(_ value: Double) -> Bool {
        abs(self - value) < Constants.margin
    }

    var isEffectivelyZero: Bool {
        self.isZero || isApproximately(0)
    }

    private struct Constants {
        static let margin: Double = 0.0001
    }
}
