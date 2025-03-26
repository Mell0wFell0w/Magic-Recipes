//
//  DeviceContext.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/10/24.
//  Update

import SwiftUI

enum DeviceContext {
    case iPadLandscape, iPadPortrait, iPhoneMaxLandscape, other

    static func context(
        for size: CGSize,
        _ horizontalSizeClass: UserInterfaceSizeClass?,
        _ verticalSizeClass: UserInterfaceSizeClass?
    ) -> DeviceContext {
        if let horizontalSizeClass, horizontalSizeClass == .regular {
            if let verticalSizeClass, verticalSizeClass == .regular {
                size.width < size.height ? .iPadPortrait : .iPadLandscape
            } else {
                .iPhoneMaxLandscape
            }
        } else {
            .other
        }
    }
}
