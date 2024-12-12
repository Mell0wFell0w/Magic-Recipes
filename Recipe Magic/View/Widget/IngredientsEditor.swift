//
//  IngredientsEditor.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/11/24.
//

import SwiftUI
import MarkdownUI

struct IngredientsEditor: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Binding var ingredients: [IngredientStruct]

    private var sortedIngredients: [IngredientStruct] {
        ingredients.sorted { $0.sequence < $1.sequence }
    }

    var body: some View {
        Section {
            List {
                ForEach(sortedIngredients) { ingredient in
                    let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) ?? 0
                    let sequence = sortedIngredients.firstIndex(where: { $0.id == ingredient.id }) ?? 0
                    let quantityText = ingredient.ingredient.quantityText
                    let ingredientText = """
                            \(quantityText)\
                            \(quantityText.isEmpty ? "" : " ")\
                            \(ingredient.ingredient.ingredientText)
                            """

                    Divider()

                    EditableSection(
                        sequence: sequence,
                        maxIndex: ingredients.count - 1,
                        header: "Ingredient \(sequence + 1)",
                        withEditButton: true,
                        isEditing: ingredientText.isEmpty,
                        moveUp: moveUp,
                        moveDown: moveDown,
                        deleteItem: deleteItem
                    ) {
                        if horizontalSizeClass == .compact {
                            compactIngredientForm(for: index)
                        } else {
                            regularIngredientForm(for: index)
                        }
                    } displayContent: {
                        Markdown(ingredientText)
                    }
                }

                HStack {
                    Button {
                        withAnimation {
                            ingredients.append(IngredientStruct(sequence: ingredients.count + 1))
                        }
                    } label: {
                        Label("Add Ingredient", systemImage: "plus.circle")
                            .foregroundStyle(Color.accentColor)
                            .padding(.vertical, Constants.addButtonPadding)
                    }
                    Spacer()
                }
            }
        }
    }

    // MARK: - View hierarchy

    @ViewBuilder
    private func compactIngredientForm(for index: Int) -> some View {
        // In a compact horizontal size class we have less width to work with,
        // so fewer fields are placed on the same row.
        HStack {
            RecipeTextField("Qualifier", text: $ingredients[index].qualifier)
            RecipeTextField("Quantity", text: $ingredients[index].quantity)
        }
        RecipeTextField("Name", text: $ingredients[index].name, axis: .vertical)
    }

    @ViewBuilder
    private func regularIngredientForm(for index: Int) -> some View {
        // In a regular horizontal size class we have more width to work with,
        // so more fields are placed on the same row (Baker's % and Ratio).
        HStack {
            RecipeTextField("Qualifier", text: $ingredients[index].qualifier)
            RecipeTextField("Quantity", text: $ingredients[index].quantity)
        }
        RecipeTextField("Name", text: $ingredients[index].name, axis: .vertical)
    }

    // MARK: - Private helpers

    private func deleteItem(sequence: Int) {
        if let index = ingredient(matching: sequence) {
            ingredients.remove(at: index)
        }
    }

    private func ingredient(matching sequence: Int) -> Int? {
        ingredients.firstIndex(where: { $0.id == sortedIngredients[sequence].id })
    }

    private func moveDown(sequence: Int) {
        if sequence < ingredients.count - 1 {
            if let currentIndex = ingredient(matching: sequence),
               let nextIndex = ingredient(matching: sequence + 1) {
                ingredients.swapAt(currentIndex, nextIndex)
                ingredients[currentIndex].sequence = sequence
                ingredients[nextIndex].sequence = sequence + 1
            }
        }
    }

    private func moveUp(sequence: Int) {
        if sequence > 0 {
            if let currentIndex = ingredient(matching: sequence),
               let previousIndex = ingredient(matching: sequence - 1) {
                ingredients.swapAt(currentIndex, previousIndex)
                ingredients[currentIndex].sequence = sequence + 1
                ingredients[previousIndex].sequence = sequence
            }
        }
    }

    private struct Constants {
        static let addButtonPadding = 4.0
    }
}

#Preview {
    NavigationStack {
        IngredientsEditor(ingredients: .constant([IngredientStruct(), IngredientStruct()]))
            .navigationTitle("Ingredients Editor")
    }
}
