//
//  RecipeSectionView.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/11/24.
//

import SwiftUI
import SwiftData
import MarkdownUI

struct RecipeSectionView: View {
    let instruction: Instructions

    var body: some View {
        if let header = instruction.header {
            HeadlineText(header)
        }

        if instruction.ingredients.count > 0 {
            Markdown {
                instruction.ingredientsMarkdown
            }
            .tableColumnHeaders(.hidden)
            .markdownBlockStyle(\.table) { configuration in
                configuration.label
                    .markdownTableBorderStyle(
                        TableBorderStyle(
                            .allBorders,
                            color: Color("IngredientsBorder"),
                            strokeStyle: .init(lineWidth: 1)
                        )
                    )
            }
            .markdownBlockStyle(\.tableCell) { configuration in
                configuration.label
                    .padding(.vertical, Constants.markdownVerticalPadding)
                    .padding(.horizontal, Constants.markdownHorizontalPadding)
                    .markdownMargin(
                        top: Constants.markdownMargin,
                        bottom: Constants.markdownMargin
                    )
            }
            .background(Color("IngredientsBackground"))
        }

        if let text = instruction.text {
            Markdown {
                text
            }
            .padding(.top, Constants.directionsTopPadding)
        }
    }

    private struct Constants {
        static let directionsTopPadding = 4.0
        static let markdownHorizontalPadding = 6.0
        static let markdownMargin = RelativeSize.em(0.25)
        static let markdownVerticalPadding = 2.0
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        VStack {
            RecipeSectionView(instruction: sampleRecipes[0].instructions[0])
            RecipeSectionView(instruction: sampleRecipes[0].instructions[1])
        }
    }
}

