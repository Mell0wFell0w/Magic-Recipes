//
//  Instructions+Render.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/11/24.
//

import Foundation

extension Instructions {
    var ingredientsMarkdown: String {
        return ingredients.isEmpty ? "" : standardIngredientsMarkdown
    }

    // MARK: - Private helpers

    private var standardIngredientsMarkdown: String {
        var table = "| **Quantity** | **Ingredient** |\n"

        table += "| ---: | :--- |\n"

        for ingredient in ingredients.sorted(by: sequenceSort) {
            table += "|\(ingredient.quantityText)|\(ingredient.ingredientText)|\n"
        }

        return table
    }
}
