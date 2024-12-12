//
//  RecipeTextField.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/11/24.
//

import SwiftUI

// This is a widget that primarily does some styling.  By using this view
// throughout the project, all instances will look the same and I can make
// my style changes here, in one spot.

struct RecipeTextField: View {
    let label: String
    let text: Binding<String>

    init(_ label: String, text: Binding<String>, axis: Axis = .horizontal) {
        self.label = label
        self.text = text
    }

    var body: some View {
        TextField(label, text: text)
            .textInputAutocapitalization(.never)
            .textFieldStyle(.roundedBorder)
            .padding(0)
    }
}

#Preview {
    RecipeTextField("Sample Field", text: .constant("Hello"))
        .padding()
}
