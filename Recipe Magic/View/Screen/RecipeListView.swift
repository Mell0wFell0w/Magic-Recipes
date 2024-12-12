//
//  RecipeListView.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/11/24.
//

import SwiftUI

struct RecipeListView: View {

    // MARK: - Properties

    @Environment(RecipeViewModel.self) var viewModel

    let recipes: [Recipe]
    let description: String
    let willAppear: String
    let imageName: String
    let searchText: String
    let deviceContext: DeviceContext

    @Binding private var columnVisibility: NavigationSplitViewVisibility

    // MARK: - Initialization

    init(
        _ recipes: [Recipe],
        description: String = Constants.recipes,
        willAppear: String = "New recipes you create",
        imageName: String = "menucard.fill",
        searchText: String,
        deviceContext: DeviceContext,
        columnVisibility: Binding<NavigationSplitViewVisibility>
    ) {
        self.recipes = recipes
        self.description = description
        self.willAppear = willAppear
        self.imageName = imageName
        self.searchText = searchText
        self.deviceContext = deviceContext

        _columnVisibility = columnVisibility
    }

    // MARK: - Main body

    var body: some View {
        List {
            ForEach(searchResults) { recipe in
                NavigationLink {
                    destinationView(for: recipe)
                } label: {
                    Text(recipe.title)
                }
            }
            .onDelete(perform: deleteRecipes)
        }
        .overlay {
            if searchResults.isEmpty {
                ContentUnavailableView {
                    Label("No \(description)", systemImage: imageName)
                } description: {
                    Text("\(willAppear) will appear here.")
                }
            }
        }
    }

    // MARK: - View hierarchy

    private func destinationView(for recipe: Recipe) -> some View {
        GeometryReader { geometry in
            ScrollViewReader { scroller in
                VStack(spacing: 0) {
                    ScrollView {
                        // This little hack with the scrolling that targets
                        // this hidden rectangle is to scroll the new recipe
                        // to the top when the user selects a new recipe.
                        Rectangle()
                            .frame(width: 0, height: 0)
                            .id(Constants.scrollTargetId)

                        RecipeView(recipe: recipe, size: geometry.size)
                            .padding()
                            .onAppear {
                                updateVisibilityForDeviceContext()
                            }
                    }
                    .onChange(of: recipe) {
                        updateVisibilityForDeviceContext()
                        scroller.scrollTo(Constants.scrollTargetId)
                    }
                }
            }
        }
    }

    // MARK: - Private helpers

    private func deleteRecipes(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                viewModel.deleteRecipe(searchResults[index])
            }
        }
    }

    private var searchResults: [Recipe] {
        if searchText.isEmpty {
            recipes
        } else {
            recipes.filter { recipe in
                recipe.asSearchString.contains(searchText.lowercased())
            }
        }
    }

    private func updateVisibilityForDeviceContext() {
        // iPad landscape: doubleColumn
        // iPad portrait: detailOnly
        // iPhone Max landscape: detailOnly

        if deviceContext == .iPadLandscape {
            columnVisibility = .doubleColumn
        } else if deviceContext != .other {
            columnVisibility = .detailOnly
        }
    }

    // MARK: - Constants

    private struct Constants {
        static let recipes = "Recipes"
        static let scrollTargetId = 1
    }
}

// No preview for now
