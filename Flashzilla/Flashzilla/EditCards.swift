//
//  EditCards.swift
//  Flashzilla
//
//  Created by Deepankar Das on 10/12/25.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss)  var dismiss
    @State private var editCards = UserCards()
    enum FocusedField {
        case prompt, answer
    }
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        NavigationStack{
            List{
                Section("Add new card") {
                    TextField("Prompt", text: $editCards.newPrompt).focused($focusedField, equals: .prompt)
                    TextField("Answer", text: $editCards.newAnswer)
                        .focused($focusedField, equals: .answer)
                    Button("Add Card", action: addCard)
                }
                Section{
                    ForEach(editCards.cards) { card in
                        VStack(alignment: .leading) {
                            Text(card.prompt)
                                .font(.headline)
                            Text(card.answer)
                                .foregroundStyle(.secondary)
                        }
                    }.onDelete(perform: removeCards)
                    
                }
            }.navigationTitle("Edit Cards")
                .toolbar {
                    Button("Done", action: done)
                }
                .onAppear(perform: editCards.loadData)
        }
    }
    
    
    func done() {
        dismiss()
    }

    func addCard() {
        editCards.addCard()
        focusedField = nil
    }
    func removeCards(at offsets: IndexSet) {
        editCards.cards.remove(atOffsets: offsets)
        editCards.saveData()
    }
}

#Preview {
    EditCards()
}
