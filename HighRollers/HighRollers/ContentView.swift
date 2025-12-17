//
//  ContentView.swift
//  HighRollers
//
//  Created by Deepankar Das on 16/12/25.
//
import Combine
import SwiftData
import SwiftUI


struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var showAddDice: Bool = false
    @Query(sort: \Dice.sides) var dices: [Dice]
    
    var total: Int {
        dices.compactMap { $0.lastRoll }.reduce(0, +)
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    Section {
                        Text("Total: \(total)")
                            .font(.headline)
                            .accessibilityLabel("Total rolled: \(total)")
                    }
                    Section {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(Array(dices.enumerated()), id: \.element.id) { index, dice in
                                DiceView(dice: dice, index: index) { roll in
                                    dices[index].lastRoll = roll
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }.navigationTitle("Dice Roller")
                .toolbar {
                    Button("Add", systemImage: "plus") {
                        showAddDice.toggle()
                    }
                }
                .sheet(isPresented: $showAddDice) {
                    AddDice()
                }
        }
    }
    

}

#Preview {
    ContentView().modelContainer(for: Dice.self)
}
