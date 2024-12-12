//
//  InstructionModel.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/2/24.
//

import Foundation
import SwiftData

@Model
final class Instructions {
    var sequence: Int
    @Relationship(deleteRule: .cascade)
    var ingredients: [Ingredient]
    var header: String?
    var text: String?

    init(sequence: Int, ingredients: [Ingredient] = [], header: String? = nil, text: String? = nil) {
        self.sequence = sequence
        self.ingredients = ingredients
        self.header = header
        self.text = text
    }
}

extension Instructions: Sequenced {
}

extension Instructions {
    var asSearchString: String {
        var result = "\(header ?? "") \(text ?? "") "

        ingredients.forEach {
            result += $0.asSearchString
        }

        return result.lowercased()
    }
}

struct InstructionsStruct: Identifiable {
    var id = UUID()
    var sequence = 0
    var ingredients = [IngredientStruct]()
    var header = ""
    var text = ""
}
