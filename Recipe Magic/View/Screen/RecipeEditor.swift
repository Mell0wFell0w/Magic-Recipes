//
//  RecipeEditor.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/10/24.
//

import SwiftUI
import SwiftData

struct RecipeEditor: View {

    // MARK: - Properties

    let recipe: Recipe?

    @Environment(\.dismiss) private var dismiss
    @Environment(RecipeViewModel.self) private var viewModel

    @State private var title = ""
    @State private var subtitle = ""
    @State private var summary = ""
    @State private var course = Constants.unspecified
    @State private var courseOther = ""
    @State private var cuisine = Constants.unspecified
    @State private var cuisineOther = ""
    @State private var difficultyLevel = Constants.unspecified
    @State private var difficultyLevelOther = ""
    @State private var author = Constants.unspecified
    @State private var authorOther = ""
    @State private var duration = ""
    @State private var servings = ""
    @State private var calories = ""
    @State private var instructions = [InstructionsStruct]()
    @State private var notes = ""
    @State private var isFavorite = false

    // MARK: - View hierarchy

    var body: some View {
        NavigationStack {
            Form {
                mainRecipeSection
                instructionsList
                notesSection
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(editorTitle)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let recipe {
                    editIncoming(recipe)
                }
            }
        }
    }

    private var mainRecipeSection: some View {
        Section {
            TextField("Title", text: $title)
                .padding(0)
            TextField("Subtitle", text: $subtitle)
                .padding(0)
            TextField("Summary", text: $summary, axis: .vertical)
                .layoutPriority(1)
                .padding(0)
            ChoicePicker(
                choices: viewModel.courses,
                otherPrompt: "Enter course",
                labelPrompt: "Course",
                selection: $course,
                otherText: $courseOther
            )
            ChoicePicker(
                choices: viewModel.cuisines,
                otherPrompt: "Enter cuisine",
                labelPrompt: "Cuisine",
                selection: $cuisine,
                otherText: $cuisineOther
            )
            ChoicePicker(
                choices: viewModel.difficultyLevels,
                otherPrompt: "Enter difficulty level",
                labelPrompt: "Difficulty Level",
                selection: $difficultyLevel,
                otherText: $difficultyLevelOther
            )
            ChoicePicker(
                choices: viewModel.authors,
                otherPrompt: "Enter author",
                labelPrompt: "Author",
                selection: $author,
                otherText: $authorOther
            )
            TextField("Duration", text: $duration)
                .padding(0)
            TextField("Servings", text: $servings)
                .padding(0)
            TextField("Calories", text: $calories)
                .padding(0)
            Toggle("Favorite", isOn: $isFavorite)
        }
    }

    private var notesSection: some View {
        Section("Notes") {
            TextField("Notes", text: $notes, axis: .vertical)
        }
    }

    private var instructionsList: some View {
        Section("Instructions") {
            ForEach(instructions) { instruction in
                let index = instructions.firstIndex(where: { $0.id == instruction.id }) ?? 0

                VStack {
                    EditableSection(
                        sequence: index,
                        maxIndex: instructions.count - 1,
                        header: "Step \(index + 1)",
                        withEditButton: false,
                        isEditing: false
                    ) { index in
                        if index > 0 {
                            instructions.swapAt(index, index - 1)
                        }
                    } moveDown: { index in
                        if index < instructions.count - 1 {
                            instructions.swapAt(index, index + 1)
                        }
                    } deleteItem: { index in
                        instructions.remove(at: index)
                    } editingContent: {
                        EmptyView()
                    } displayContent: {
                        TextField("Section Header", text: $instructions[index].header)
                            .textFieldStyle(.roundedBorder)
                            .padding(0)
                        IngredientsEditor(ingredients: $instructions[index].ingredients)
                        TextField("Section Text", text: $instructions[index].text, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                    }

                    Divider()
                        .padding(.top, DividerConstants.topPadding)
                }
            }

            HStack {
                Button {
                    withAnimation {
                        instructions.append(InstructionsStruct(sequence: instructions.count + 1))
                    }
                } label: {
                    Label("Add Instructions Section", systemImage: "plus.circle")
                }
            }
        }
        .listRowSeparator(.hidden)
    }

    // MARK: - Private helpers

    private func editIncoming(_ recipe: Recipe) {
        title = recipe.title
        subtitle = recipe.subtitle
        summary = recipe.summary

        if viewModel.courses.contains(recipe.course) {
            course = recipe.course
            courseOther = ""
        } else {
            course = Constants.other
            courseOther = recipe.course
        }

        if viewModel.cuisines.contains(recipe.cuisine) {
            cuisine = recipe.cuisine
            cuisineOther = ""
        } else {
            cuisine = Constants.other
            cuisineOther = recipe.cuisine
        }

        if viewModel.difficultyLevels.contains(recipe.difficultyLevel) {
            difficultyLevel = recipe.difficultyLevel
            difficultyLevelOther = ""
        } else {
            difficultyLevel = Constants.other
            difficultyLevelOther = recipe.difficultyLevel
        }

        if viewModel.authors.contains(recipe.author) {
            author = recipe.author
            authorOther = ""
        } else {
            author = Constants.other
            authorOther = recipe.author
        }

        duration = recipe.duration
        servings = recipe.servings
        calories = recipe.calories
        notes = recipe.notes
        isFavorite = recipe.isFavorite

        instructions = []

        recipe.instructions.forEach { instr in
            var newInstr = InstructionsStruct(
                sequence: instr.sequence,
                ingredients: [],
                header: instr.header ?? "",
                text: instr.text ?? ""
            )
            
            instr.ingredients.forEach { ingredient in
                newInstr.ingredients.append(IngredientStruct(
                    name: ingredient.name,
                    quantity: "\(ingredient.quantity)",
                    qualifier: ingredient.qualifier ?? "",
                    sequence: ingredient.sequence,
                    unit: ingredient.unit
                ))
            }
            instructions.append(newInstr)
        }

        instructions.sort { $0.sequence < $1.sequence }
    }

    private var editorTitle: String {
        "\(recipe == nil ? "Add" : "Edit") Recipe"
    }

    private func fieldOrOther(field: String, other: String) -> String {
        field == Constants.other ? other : field
    }

    private func save() {

        viewModel.saveRecipe(
            recipe,
            title: title,
            subtitle: subtitle,
            summary: summary,
            course: fieldOrOther(field: course, other: courseOther),
            cuisine: fieldOrOther(field: cuisine, other: cuisineOther),
            difficultyLevel: fieldOrOther(field: difficultyLevel, other: difficultyLevelOther),
            author: fieldOrOther(field: author, other: authorOther),
            duration: duration,
            servings: servings,
            calories: calories,
            notes: notes,
            isFavorite: isFavorite,
            instructions: instructions
        )
    }

    // MARK: - Drawing constants

    private struct DividerConstants {
        static let topPadding = 12.0
    }
}


//#Preview("New Recipe") {
//    @Previewable @State var isPresented = true
//
//    return ModelContainerPreview(ModelContainer.sample) {
//        NavigationStack {
//            Button {
//                isPresented = true
//            } label: {
//                Text("New Recipe")
//            }
//            .sheet(isPresented: $isPresented) {
//                RecipeEditor(recipe: nil)
//                    .navigationTitle("New Recipe")
//            }
//        }
//    }
//}

//#Preview("Edit Recipe") {
//    @Previewable @State var isPresented = true
//
//    return ModelContainerPreview(ModelContainer.sample) {
//        NavigationStack {
//            Button {
//                isPresented = true
//            } label: {
//                Text("Edit Recipe")
//            }
//            .sheet(isPresented: $isPresented) {
//                RecipeEditor(recipe: sampleRecipes[0])
//                    .navigationTitle("Edit Recipe")
//            }
//        }
//    }
//}

