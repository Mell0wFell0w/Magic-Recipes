//
//  EditableSection.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/11/24.
//

import SwiftUI

// This is a custom widget to put a header on some content and include
// move-up, move-down, and delete buttons.  I felt this was an easier way to
// manage lists inside of lists.  Apple's built-in system works well for
// non-nested lists, but it's cumbersome with nested lists.  This is my
// solution.  The caller needs to supply information about the sequence
// this item lives in, and needs to provide the ability to do the appropriate
// editing/moving/deleting.

struct EditableSection<EditingContent: View, DisplayContent: View>: View {
    let sequence: Int
    let maxIndex: Int
    let header: String
    let withEditButton: Bool
    let isEditing: Bool
    let moveUp: (Int) -> ()
    let moveDown: (Int) -> ()
    let deleteItem: (Int) -> ()
    @ViewBuilder let editingContent: EditingContent
    @ViewBuilder let displayContent: DisplayContent

    @State private var editing = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(header.uppercased())
                    .font(.callout)
                    .opacity(0.5)

                Spacer()

                Button {
                    withAnimation {
                        moveUp(sequence)
                    }
                } label: {
                    Image(systemName: "arrow.up")
                        .foregroundStyle(Color.accentColor)
                }
                .disabled(sequence <= 0)

                Button {
                    withAnimation {
                        moveDown(sequence)
                    }
                } label: {
                    Image(systemName: "arrow.down")
                        .foregroundStyle(Color.accentColor)
                }
                .disabled(sequence > maxIndex - 1)

                Button {
                    withAnimation {
                        deleteItem(sequence)
                    }
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
            }

            if editing {
                if withEditButton {
                    VStack(alignment: .leading) {
                        editingContent

                        HStack {
                            displayContent
                            Spacer()
                            Button {
                                withAnimation {
                                    editing = false
                                }
                            } label: {
                                Text("DONE EDITING")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.accentColor)
                            }
                            .padding(.horizontal)
                        }
                    }
                } else {
                    editingContent
                }
            } else {
                if withEditButton {
                    HStack {
                        displayContent
                        Button {
                            withAnimation {
                                editing = true
                            }
                        } label: {
                            Text("EDIT")
                                .font(.subheadline)
                                .foregroundStyle(Color.accentColor)
                        }
                        .padding(.horizontal)
                    }
                } else {
                    displayContent
                }
            }
        }
        .buttonStyle(.plain)
        .task {
            withAnimation {
                editing = isEditing
            }
        }
    }
}

#Preview {
    NavigationStack {
        Form {
            EditableSection(
                sequence: 0,
                maxIndex: 0,
                header: "Section 1",
                withEditButton: true,
                isEditing: true,
                moveUp: { index in
                    // Ignore
                },
                moveDown: { index in
                    // Ignore
                },
                deleteItem: { index in
                    // Ignore
                }
            ) {
                Text("This is editing content")
            } displayContent: {
                Text("This is display content")
                    .layoutPriority(1)
            }
        }
        .navigationTitle("EditableSection")
    }
}

