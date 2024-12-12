//
//  RecipeModel.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/2/24.
//

import Foundation
import SwiftData

@Model
//final class is used for performance for the compiler, indicates that we won't use subclassing or inheritance
final class Recipe {
    var title: String
    var subtitle: String
    var summary: String
    var course: String
    var cuisine: String
    var difficultyLevel: String
    var author: String
    var duration: String
    var servings: String
    var calories: String
    @Relationship(deleteRule: .cascade) // So that if the recipe is deleted then the instructions are also deleted
    var instructions: [Instructions]
    var notes: String
    var isFavorite: Bool
    // Initialize a recipe instance with all the same variables in the same order
    init(title: String,
         subtitle: String,
         summary: String,
         course: String,
         cuisine: String,
         difficultyLevel: String,
         author: String,
         duration: String,
         servings: String,
         calories: String,
         instructions: [Instructions],
         notes: String,
         isFavorite: Bool = false) //isFavorite needs to be false by default
    {
        self.title = title
        self.subtitle = subtitle
        self.summary = summary
        self.course = course
        self.cuisine = cuisine
        self.difficultyLevel = difficultyLevel
        self.author = author
        self.duration = duration
        self.servings = servings
        self.calories = calories
        self.instructions = instructions
        self.notes = notes
        self.isFavorite = isFavorite
    }
}
// By extending we can add computed properties and helper methods that don't require stored properties
extension Recipe {
    // We can search from these
    var asSearchString: String {
        var result = "\(title) \(subtitle) \(summary) \(course) \(cuisine) \(difficultyLevel) \(author) \(duration) \(servings) \(calories) \(notes) "
        //Individualize the serach strings so we can search each instruction from the array
        instructions.forEach {
            result += $0.asSearchString
        }
        // Important so that we don't have to worry about case sensitivity when searching
        return result.lowercased()
    }
}
