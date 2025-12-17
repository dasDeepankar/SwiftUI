//
//  DiceEdit.swift
//  HighRollers
//
//  Created by Deepankar Das on 17/12/25.
//

import SwiftUI

struct DiceEdit: View {
    let sides = [2,3,4,5,6,10,50].map { $0 + $0}
    var dice : Dice
    var updateDice: ((Int) -> Void)
    @State private var selectedSide = 4
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "dice")
                Text("Dice With \(selectedSide) sides").font(.headline)
                Spacer()
            }
            Picker("You have selected \(selectedSide) sides", selection: $selectedSide) {
                ForEach(sides, id: \.self){
                    Text("\($0)")
                }
            }.pickerStyle(.segmented)
                .onChange(of: selectedSide) { oldValue, newValue in
                    updateDice(newValue)
                }
        }.padding()
    }
    init(dice: Dice, updateDice: @escaping (Int) -> Void = { _ in }) {
        self.dice = dice
        _selectedSide = State(initialValue: dice.sides)
        self.updateDice = updateDice
    }
}

#Preview {

    DiceEdit(dice: Dice(sides: 4))
}
