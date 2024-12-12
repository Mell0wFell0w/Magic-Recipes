//
//  Instructions+Render.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/10/24.
//

import Foundation
// Needed to import the markdown package for this https://github.com/gonzalezreal/swift-markdown-ui.git
extension Instructions {
    var ingredientsMarkdown: String {
        return ingredients.isEmpty ? "" : standardIngredientsMarkdown
    }
    // For markdown purposes to make some nice looking tables
    private var standardIngredientsMarkdown: String {
        var table = "| **Quantity** | **Ingredient** |\n"

        table += "| ---: | :--- |\n"

        for ingredient in ingredients.sorted(by: sequenceSort) {
            table += "|\(ingredient.quantityText)|\(ingredient.ingredientText)|\n"
        }

        return table
    }
}
