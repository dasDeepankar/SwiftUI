//
//  AddDice.swift
//  HighRollers
//
//  Created by Deepankar Das on 16/12/25.
//
import SwiftData
import SwiftUI

struct AddDice: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var numberOfDice = 1
    
    @State private var dices : [Dice] = [Dice(sides: Int.random(in: 2...5) * 2)]
    
    var body: some View {
        NavigationStack{
            Form{
                Section("Number of Dice"){
                    Picker(selection: $numberOfDice, label: Text("Your have selected")){
                        ForEach(1...10, id: \.self) {
                            Label("\($0) \($0 > 1 ? "Dice" : "Die")", systemImage: (numberOfDice == $0 ? "dice.fill" : "dice")).labelStyle(.automatic)
                        }
                    }
                }
                Section("Select sides for each dice"){
                    ForEach(0..<dices.count, id: \.self){ index in
                        DiceEdit(dice: dices[index]) { newSides in
                            dices[index].sides = newSides
                        }
                    }
                }
                
            }.navigationTitle("Add Dice")
                .toolbar {
                    Button("Save") {
                        // Remove all existing dice first
                        try? modelContext.delete(model: Dice.self)
                        
                        // Insert new dices - create fresh instances for SwiftData
                        for dice in dices {
                            let newDice = Dice(sides: dice.sides)
                            modelContext.insert(newDice)
                        }
                        dismiss()
                    }
                }
                .onChange(of: numberOfDice) { oldValue, newValue in
                    updateDicesCount(to: newValue)
                }
        }
    }
    
    func updateDicesCount(to count: Int) {
        if count > dices.count {
            // Add new dice
            for _ in dices.count..<count {
                dices.append(Dice(sides: Int.random(in: 2...5) * 2))
            }
        } else if count < dices.count {
            // Remove excess dice
            dices.removeLast(dices.count - count)
        }
    }
}

#Preview {
    NavigationStack{
        AddDice()
    }
}
