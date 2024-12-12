//
//  Recipe_MagicApp.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/2/24.
//

import SwiftUI
import SwiftData

@main
struct Recipe_MagicApp: App {
    let container: ModelContainer
    let viewModel: RecipeViewModel

    var body: some Scene {
        WindowGroup {
            RecipeCatalogView()
        }
        .modelContainer(container)
        .environment(viewModel)
    }

    init() {
        do {
            container = try ModelContainer(for: Recipe.self)
        } catch {
            fatalError("""
                Failed to create ModelContainer for Recipe.  If you made a
                change to the Model, then uninstall the app and restart it
                from Xcode.
                """)
        }

        viewModel = RecipeViewModel(container.mainContext)
    }
}
