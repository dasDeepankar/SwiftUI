//
//  ContentView.swift
//  WeSplit
//
//  Created by Deepankar Das on 17/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    
    @FocusState private var checkTextField: Bool
    
    
    var totalAmount : Double {
        let tipAmount = checkAmount * Double(tipPercentage)/100
        let grandTotal = checkAmount + tipAmount
        return grandTotal
    }
    var totalPerPerson : Double {
        return totalAmount / Double(numberOfPeople)
    }
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section{
                    TextField("Check Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($checkTextField)
                    Picker("Number Of People", selection: $numberOfPeople) {
                        ForEach(2..<100, id: \.self) {
                            Text("\($0) people")
                        }
                    }
                }
                Section("HOW MUCH DO YOU WANT TO TIP?") {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(0..<101 , id: \.self) {
                            Text("\($0)%")
                        }
                    }.pickerStyle(NavigationLinkPickerStyle())
                }
                Section("Total Amount"){
                    Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundColor(tipPercentage > 0 ? .primary : .red)
                }
                Section("Amount per person"){
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }.navigationTitle("WeSplit")
                .toolbar {
                    Button("Done") {
                        checkTextField = false
                    }
                }
            
        }
    }
}

#Preview {
    ContentView()
}
