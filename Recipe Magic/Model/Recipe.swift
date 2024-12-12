//
//  RecipeModel.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/2/24.
//

import Foundation
import SwiftData

@Model
//Why put final here?
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
    @Relationship(deleteRule: .cascade)
    var instructions: [Instructions]
    var notes: String
    var isFavorite: Bool

    init(title: String, subtitle: String, summary: String, course: String, cuisine: String, difficultyLevel: String, author: String, duration: String, servings: String, calories: String, instructions: [Instructions], notes: String, isFavorite: Bool = false) {
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

extension Recipe {
    // These are the fields we'll search when the user types in the .searchable
    // text field (to filter the list according to the user's search terms).
    var asSearchString: String {
        var result = "\(title) \(subtitle) \(summary) \(course) \(cuisine) \(difficultyLevel) \(author) \(duration) \(servings) \(calories) \(notes) "

        instructions.forEach {
            result += $0.asSearchString
        }

        return result.lowercased()
    }
}
