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
    @Relationship(deleteRule: .cascade) // Used so that all ingredient objects with the associated instruction instance are deleted
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

extension Instructions: Sequenced {} // Conforms to Sequenced in the Utility folder

extension Instructions {
    var asSearchString: String {
        var result = "\(header ?? "") \(text ?? "") " // We start with header and text and use empty strings if needed to avoid fatal errors
        
        ingredients.forEach {
            result += $0.asSearchString
        }
        
        return result.lowercased()
    }
}
// Used so we don't have to rely on the SwiftData @Model and it plays nicer with ForEach and Lists in SwiftUI
struct InstructionsStruct: Identifiable {
    var id = UUID()
    var sequence = 0
    var ingredients = [IngredientStruct]()
    var header = ""
    var text = ""
}
