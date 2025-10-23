//
//  ContentView.swift
//  iExpense
//
//  Created by Deepankar Das on 13/09/25.
//
import SwiftData
import SwiftUI


struct ContentView: View {
    
    @State var showAddExpenseView : Bool = false
    @State private var sortOrder = [SortDescriptor(\Expense.name)]
    @State private var path = NavigationPath()
    
    private let filters = [ExpenseType.all.rawValue,
                           ExpenseType.business.rawValue,
                           ExpenseType.personal.rawValue]
    @State private var filter = ExpenseType.all.rawValue
    
    var body: some View {
        NavigationStack(path : $path) {
            Picker("Filter", selection: $filter) {
                ForEach(filters, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.segmented)
            ExpensesList(sortOrder: sortOrder, filter: filter)
                .navigationTitle("iExpense")
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            EditButton()
                            NavigationLink {
                                AddNew(path: $path)
                            } label: {
                                Label("Add New", systemImage: "plus")
                            }
                        }
                        ToolbarItemGroup(placement: .topBarLeading) {
                            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                                Picker("Sort", selection: $sortOrder) {
                                    Text("Sort by name")
                                        .tag([SortDescriptor(\Expense.name)])
                                    Text("Sort by amount")
                                        .tag([SortDescriptor(\Expense.amount)])
                                }
                            }
                            
                        }
                        
                    }
        }
    }
    
}

func currencyColor(at amount: Double) -> Color {
    
    var color: Color = .green
    
    if (amount > 999 && amount < 99999 ){
        color =  .orange
    } else if (amount > 99999){
        color = .red
    }
    
    return color
}


#Preview {
    ContentView()
}
