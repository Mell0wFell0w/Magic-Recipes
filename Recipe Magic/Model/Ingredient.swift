//
//  IngredientModel.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/2/24.
//

import Foundation
import SwiftData

@Model
final class Ingredient {
    var name: String
    var quantity: Decimal
    var qualifier: String?
    var sequence: Int
    var unit: String
    
    // These have to be in the correct order for the extension and I should probably change it so that sequence is first but it is late and I don't want to refactor all that right now
    init(name: String, quantity: Decimal, qualifier: String? = nil, sequence: Int, unit: String) {
        self.name = name
        self.qualifier = qualifier
        self.quantity = quantity
        self.sequence = sequence
        self.unit = unit
    }
}

extension Ingredient: Sequenced {
}

extension Ingredient {
    // These are the fields in the ingredient that we'll use for search. We don't need unit here imo
    var asSearchString: String {
        """
        \(qualifier ?? "") \(quantity) \(name)
        """
            .lowercased()
    }
}

struct IngredientStruct: Identifiable {
    var id = UUID()
    var name = ""
    var quantity = ""
    var qualifier = ""
    var sequence = 0
    var unit = ""
}

extension IngredientStruct {
    var ingredient: Ingredient {
        Ingredient(
            name: name,
            quantity: quantity.decimal,
            qualifier: qualifier.orNil,
            sequence: sequence,
            unit: unit
        )
    }
}
