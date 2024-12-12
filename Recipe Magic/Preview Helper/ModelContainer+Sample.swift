//
//  ModelContainer+Sample.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/11/24.
//

import SwiftData

extension ModelContainer {
    static var sample: () throws -> ModelContainer = {
        let schema = Schema([Recipe.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])

        Task { @MainActor in
            sampleRecipes.forEach { container.mainContext.insert($0) }
        }

        return container
    }
}
