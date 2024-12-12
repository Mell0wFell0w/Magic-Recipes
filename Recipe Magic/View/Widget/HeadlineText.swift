//
//  HeadlineText.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/11/24.
//

import SwiftUI

// This is a widget that primarily does some styling.  By using this view
// throughout the project, all instances will look the same and I can make
// my style changes here, in one spot.

struct HeadlineText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.headline)
            .padding(.top, Constants.headlineTopPadding)
            .padding(.bottom, Constants.headlineBottomPadding)
    }

    private struct Constants {
        static let headlineTopPadding = 8.0
        static let headlineBottomPadding = 3.0
    }
}

#Preview {
    HeadlineText("Ingredients")
}
