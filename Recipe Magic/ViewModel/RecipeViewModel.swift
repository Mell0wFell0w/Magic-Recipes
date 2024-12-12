//
//  RecipeViewModel.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/10/24.
//

import Foundation
import SwiftData

@Observable
class RecipeViewModel {

    // MARK: - Properties

    private var modelContext: ModelContext

    // MARK: - Initialization

    init(_ modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchData()
    }

    // MARK: - Model access

    private(set) var authors: [String] = []
    private(set) var courses: [String] = []
    private(set) var cuisines: [String] = []
    private(set) var difficultyLevels: [String] = []
    private(set) var favorites: [Recipe] = []
    private(set) var recipes: [Recipe] = []

    // MARK: - User intents

    func deleteRecipe(_ recipe: Recipe) {
        modelContext.delete(recipe)
        fetchData()
    }

    func replaceAllRecipes(_ recipes: [Recipe]) {
        deleteAllExistingRecipes()
        recipes.forEach { modelContext.insert($0) }
        fetchData()
    }

    func saveRecipe(
        _ recipe: Recipe?, title: String, subtitle: String, summary: String,
        course: String, cuisine: String, difficultyLevel: String, author: String,
        duration: String, servings: String, calories: String, notes: String,
        isFavorite: Bool, instructions: [InstructionsStruct]
    ) {
        if let recipe {
            editRecipe(
                recipe,
                title: title, subtitle: subtitle, summary: summary, course: course,
                cuisine: cuisine, difficultyLevel: difficultyLevel, author: author,
                duration: duration, servings: servings, calories: calories,
                notes: notes, isFavorite: isFavorite, instructions: instructions
            )
        } else {
            createRecipe(
                title: title, subtitle: subtitle, summary: summary, course: course,
                cuisine: cuisine, difficultyLevel: difficultyLevel, author: author,
                duration: duration, servings: servings, calories: calories,
                notes: notes, isFavorite: isFavorite, instructions: instructions
            )
        }

        fetchData()
    }

    func toggleFavorite(for recipe: Recipe) {
        recipe.isFavorite.toggle()
        fetchFavorites()
    }

    // MARK: - Private CRUD helpers

    private func createRecipe(
        title: String, subtitle: String, summary: String,
        course: String, cuisine: String, difficultyLevel: String, author: String,
        duration: String, servings: String, calories: String, notes: String,
        isFavorite: Bool, instructions: [InstructionsStruct]
    ) {
        let newRecipe = Recipe(
            title: title, subtitle: subtitle, summary: summary,
            course: course.specified, cuisine: cuisine.specified,
            difficultyLevel: difficultyLevel.specified,
            author: author.specified, duration: duration,
            servings: servings, calories: calories, instructions: [], notes: notes
        )

        modelContext.insert(newRecipe)

        insertSections(instructions, into: newRecipe)
    }

    private func deleteAllExistingRecipes() {
        do {
            try modelContext.delete(model: Recipe.self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func deleteSection(_ section: Instructions) {
        section.ingredients.forEach { ingredient in
            modelContext.delete(ingredient)
        }

        modelContext.delete(section)
    }

    private func editRecipe(
        _ recipe: Recipe, title: String, subtitle: String, summary: String,
        course: String, cuisine: String, difficultyLevel: String, author: String,
        duration: String, servings: String, calories: String, notes: String,
        isFavorite: Bool, instructions: [InstructionsStruct]
    ) {
        // edit the recipe
        recipe.title = title
        recipe.subtitle = subtitle
        recipe.summary = summary
        recipe.course = course.specified
        recipe.cuisine = cuisine.specified
        recipe.difficultyLevel = difficultyLevel.specified
        recipe.author = author.specified
        recipe.duration = duration
        recipe.servings = servings
        recipe.calories = calories
        recipe.notes = notes
        recipe.isFavorite = isFavorite

        recipe.instructions.forEach { instructions in
            deleteSection(instructions)
        }

        insertSections(instructions, into: recipe)
    }

    private func insertSections(_ instructions: [InstructionsStruct], into recipe: Recipe) {
        var sectionSequence = 1

        instructions.sorted(by: { $0.sequence < $1.sequence }).forEach { section in
            let newSection = Instructions(
                sequence: sectionSequence,
                ingredients: [],
                header: section.header.orNil,
                text: section.text.orNil
            )

            modelContext.insert(newSection)
            recipe.instructions.append(newSection)

            var ingredientSequence = 1

            section.ingredients.sorted(by: { $0.sequence < $1.sequence }).forEach { ingredient in
                let newIngredient = Ingredient(
                    name: ingredient.name,
                    quantity: ingredient.quantity.decimal,
                    qualifier: ingredient.qualifier.orNil,
                    sequence: ingredient.sequence,
                    unit: ingredient.unit
                )

                modelContext.insert(newIngredient)
                newSection.ingredients.append(newIngredient)
                ingredientSequence += 1
            }

            sectionSequence += 1
        }
    }

    // MARK: - Private query helpers

    private func extractAuthors() {
        authors = []

        recipes.forEach { recipe in
            if !recipe.author.isEmpty {
                let authorParts = recipe.author.split(separator: ", ")

                authorParts.forEach { author in
                    if !authors.contains(String(author)) {
                        authors.append(String(author))
                    }
                }
            }
        }

        authors.sort { $0 < $1 }
    }

    private func extractCourses() {
        courses = []

        recipes.forEach { recipe in
            if !recipe.course.isEmpty {
                let courseParts = recipe.course.split(separator: ", ")

                courseParts.forEach { course in
                    let titleCaseCourse = String(course).capitalized

                    if !courses.contains(titleCaseCourse) {
                        courses.append(titleCaseCourse)
                    }
                }
            }
        }

        courses.sort { $0 < $1 }
    }

    private func extractCuisines() {
        cuisines = []

        recipes.forEach { recipe in
            if !recipe.cuisine.isEmpty {
                let cuisineParts = recipe.cuisine.split(separator: ", ")

                cuisineParts.forEach { cuisine in
                    let titleCaseCuisine = String(cuisine).capitalized

                    if !cuisines.contains(titleCaseCuisine) {
                        cuisines.append(titleCaseCuisine)
                    }
                }
            }
        }

        cuisines.sort { $0 < $1 }
    }

    private func extractDifficultyLevels() {
        difficultyLevels = []

        recipes.forEach { recipe in
            if !difficultyLevels.contains(recipe.difficultyLevel) {
                difficultyLevels.append(recipe.difficultyLevel)
            }
        }

        difficultyLevels.sort { $0 < $1 }
    }

    private func fetchData() {
        // I saw some transient fetch issues where relaunching the app cleared
        // them up.  This call is in response to those issues, and seems to
        // clear up the issue.  I think it's a SwiftData autosave bug.
        try? modelContext.save()

        fetchRecipes()
        extractAuthors()
        extractCourses()
        extractCuisines()
        extractDifficultyLevels()
        fetchFavorites()
    }

    private func fetchFavorites() {
        do {
            let descriptor = FetchDescriptor<Recipe>(
                predicate: #Predicate { $0.isFavorite },
                sortBy: [SortDescriptor(\.title)]
            )

            favorites = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to load favorites")
        }
    }

    private func fetchRecipes() {
        do {
            let descriptor = FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.title)])

            recipes = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to load recipes")
        }
    }

    private func split(_ categories: String) -> [String] {
        categories.split(separator: ", ").map {
            $0.capitalizingFirstLetter
        }
    }
}
