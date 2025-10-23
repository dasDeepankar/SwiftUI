//
//  AddNew.swift
//  iExpense
//
//  Created by Deepankar Das on 14/09/25.
//

import SwiftData
import SwiftUI

struct AddNew: View {
    
    @State var name: String = "Name"
    @State var type: String = "Personal"
    @State var amount: Double = 0.0
    
    @Binding var path : NavigationPath
    @Environment(\.dismiss) private var dismiss
    
    let categories: [String] = [ExpenseType.personal.rawValue, ExpenseType.business.rawValue]
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        Form {
            Picker("Type", selection: $type) {
                ForEach(categories , id: \.self){
                    Text($0)
                }
            }
            
            TextField("Amount", value: $amount , format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
        .navigationTitle($name)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode( .inline )
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save"){
                    let item = Expense(name: name, type: type, amount: amount)
                    modelContext.insert(item)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddNew(path: .constant(NavigationPath()))
}
