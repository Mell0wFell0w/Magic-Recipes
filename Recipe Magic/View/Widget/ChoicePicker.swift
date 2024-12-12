//
//  ChoicePicker.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/11/24.
//

import SwiftUI

// This is a picker that adds two options: "unspecified" and "other".  When
// the user chooses unspecified, it's equivalent to nil (no choice).  When
// the user chooses other, we display a text field where they can enter the
// text they'd like to choose (i.e. creating a choice not in the list).

// NOTE: I saw several students implement their own multi-selection picker.
// A quick search of swiftpackageindex.com found a MultiPicker library there:
// https://swiftpackageindex.com/toastersocks/MultiPicker
// Rather than re-invent this particular wheel, I'd try to use this library
// or another one like it if feasible.

struct ChoicePicker: View {
    let choices: [String]
    let unspecifiedChoice = Constants.unspecified
    let otherChoice = Constants.other
    let otherPrompt: String
    let labelPrompt: String

    @Binding var selection: String
    @Binding var otherText: String

    init(choices: [String], otherPrompt: String, labelPrompt: String,
         selection: Binding<String>, otherText: Binding<String>) {

        var fullList = choices

        fullList.append(unspecifiedChoice)
        fullList.append(otherChoice)

        self.choices = fullList
        self.otherPrompt = otherPrompt
        self.labelPrompt = labelPrompt

        // This is how we assign a Binding.  We assign to the property wrapper
        // itself, not the wrapped value.  The property wrapper is indicated by
        // the underscore in front of the property name.
        _selection = selection
        _otherText = otherText
    }

    var body: some View {
        VStack {
            Picker(labelPrompt, selection: $selection) {
                ForEach(choices, id: \.self) { choice in
                    Text(choice)
                }
            }

            if selection == otherChoice {
                TextField(otherPrompt, text: $otherText)
            }
        }
    }
}

#Preview {
    Form {
        ChoicePicker(
            choices: ["One", "Two", "Three"],
            otherPrompt: "Enter Other",
            labelPrompt: "Picker",
            selection: .constant(Constants.other),
            otherText: .constant(Constants.other)
        )
    }
}

