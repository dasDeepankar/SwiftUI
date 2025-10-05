//
//  ContentView.swift
//  UnitConverter
//
//  Created by Deepankar Das on 21/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var input: Double = 0.0
    @State private var inputUnit: String = "meters"
    @State private var outputUnit: String = "KM"
    @FocusState private var isTextFieldFocused: Bool
    
    let inputUnits: [String] = ["meters", "KM", "feet", "yard", "miles"]
    
    let unitToMeters: [String: Double] = [
        "meters": 1.0,
        "KM": 1000.0,
        "feet": 0.3048,
        "yard": 0.9144,
        "miles": 1609.34
    ]
    
    var outputValue: Double {
        let inputInMeters = input * (unitToMeters[inputUnit] ?? 1.0)
        return inputInMeters / (unitToMeters[outputUnit] ?? 1.0)
    }
    
    var body: some View {
        NavigationStack{
            Form{
                Section("Input Unit"){
                    Picker("Select Unit", selection: $inputUnit) {
                        ForEach(inputUnits, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                        .disabled(isTextFieldFocused)
                }
                Section("Output Unit"){
                    Picker("Select Unit", selection: $outputUnit) {
                        ForEach(inputUnits, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                        .disabled(isTextFieldFocused)
                }
                Section("Enter Length in \(inputUnit)"){
                    TextField("Input Unit", value: $input, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isTextFieldFocused)
                        
                }
                Section("Result in \(outputUnit)"){
                    Text(outputValue, format: .number)
                        
                }
            
            }.navigationTitle("Unit Converter")
                .toolbar {
                    Button("Done"){
                        isTextFieldFocused = false
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
