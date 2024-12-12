//
//  RecipeCatalogView.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/10/24.
//  Tweaked from Prof. Liddle's solution

import SwiftUI
import SwiftData
import MarkdownUI
import UIKit

struct RecipeCatalogView: View {

    // MARK: - Properties

    @Environment(RecipeViewModel.self) var viewModel // Our ViewModel is used via the Environment macro
    @Environment(\.horizontalSizeClass) var horizontalSizeClass // Track and adjust the device width for good ui
    @Environment(\.verticalSizeClass) var verticalSizeClass // Track and adjust the device width for good ui

    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    @State private var deviceContext = DeviceContext.other
    @State private var isEditing = false
    @State private var searchText = "" // So that we can filter the recipes dynamically

    // MARK: - Main body

    var body: some View {
        GeometryReader { geometry in
            NavigationSplitView(columnVisibility: $columnVisibility) {
                categoriesList
                    .navigationTitle(Constants.recipes)
            } content: {
                primaryNavigationView
                    .navigationTitle(Constants.recipes)
            } detail: {
                Text("Select a recipe")
            }
            .searchable(text: $searchText)
            .onChange(of: geometry.size.width) {
                // When the user rotates, we need to recompute the context
                computeDeviceContext(for: geometry.size)
            }
            .sheet(isPresented: $isEditing) {
                RecipeEditor(recipe: nil)
            }
            .task {
                computeDeviceContext(for: geometry.size)
                preventScreenTimeout()

                if viewModel.recipes.isEmpty {
                    initializeRecipes()
                }
            }
        }
        .onDisappear {
            allowScreenTimeout()
        }
    }

    // MARK: - View hierarchy

    private var categoriesList: some View {
        List {
            favoritesSection
            categoriesSection
        }
    }

    @ViewBuilder
    private var categoriesSection: some View {
        targetList(
            list: viewModel.courses,
            field: { $0.course },
            title: Constants.courses
        )
        targetList(
            list: viewModel.cuisines,
            field: { $0.cuisine },
            title: Constants.cuisines
        )
        targetList(
            list: viewModel.authors,
            field: { $0.author },
            title: Constants.authors
        )
        targetList(
            list: viewModel.difficultyLevels,
            field: { $0.difficultyLevel },
            title: Constants.difficultyLevel
        )
    }

    private var favoritesSection: some View {
        Section {
            NavigationLink {
                primaryNavigationView
                    .navigationTitle(Constants.recipes)
            } label: {
                Text(Constants.browseAllRecipes)
            }

            NavigationLink {
                RecipeListView(
                    viewModel.favorites,
                    description: Constants.favorites,
                    willAppear: "New favorites you mark",
                    searchText: searchText,
                    deviceContext: deviceContext,
                    columnVisibility: $columnVisibility
                )
                .navigationTitle(Constants.favorites)
                .toolbar {
                    mainToolbar
                }
            } label: {
                Text(Constants.favorites)
            }
        }
    }

    @ToolbarContentBuilder
    private var mainToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton()
        }
        ToolbarItem {
            Button(action: addRecipe) {
                Label("Add Recipe", systemImage: "plus")
            }
        }
    }

    private var primaryNavigationView: some View {
        RecipeListView(
            viewModel.recipes,
            searchText: searchText,
            deviceContext: deviceContext,
            columnVisibility: $columnVisibility
        )
        .toolbar {
            mainToolbar
        }
    }

    @ViewBuilder
    private func targetList(
        list: [String],
        field: @escaping (Recipe) -> String,
        title: String
    ) -> some View {
        if !list.isEmpty {
            Section(title) {
                ForEach(list, id: \.self) { item in
                    let lowercasedFilter = item.lowercased()

                    NavigationLink {
                        RecipeListView(
                            viewModel.recipes.filter { field($0).lowercased().contains(lowercasedFilter) },
                            searchText: searchText,
                            deviceContext: deviceContext,
                            columnVisibility: $columnVisibility
                        )
                        .navigationTitle(item)
                        .toolbar {
                            mainToolbar
                        }
                    } label: {
                        Text(item)
                    }
                }
            }
        }
    }

    // MARK: - Private helpers

    private func addRecipe() {
        isEditing = true
    }

    private func allowScreenTimeout() {
        UIApplication.shared.isIdleTimerDisabled = false
    }

    private func computeDeviceContext(for size: CGSize) {
        deviceContext = DeviceContext.context(for: size, horizontalSizeClass, verticalSizeClass)
    }

    private func initializeRecipes() {
        withAnimation {
            viewModel.replaceAllRecipes(sampleRecipes)
        }
    }

    private func preventScreenTimeout() {
        UIApplication.shared.isIdleTimerDisabled = true
    }

    // MARK: - Constants

    private struct Constants {
        static let authors = "Authors"
        static let browseAllRecipes = "Browse all"
        static let courses = "Courses"
        static let cuisines = "Cuisines"
        static let difficultyLevel = "Difficulty"
        static let favorites = "Favorites"
        static let recipes = "Magic Recipes"
        static let scrollTargetId = 1
    }
}

// Preview was problematic
//#Preview {
//    ModelContainerPreview(ModelContainer.sample) {
//        RecipeCatalogView()
//    }
//}
