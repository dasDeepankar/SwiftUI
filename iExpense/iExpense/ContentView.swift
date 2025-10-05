//
//  ContentView.swift
//  iExpense
//
//  Created by Deepankar Das on 13/09/25.
//

import SwiftUI

struct ExpenseItem : Identifiable , Codable{
    var id = UUID()
    let name : String
    let type : String
    let amount : Double
}
@Observable
class Expenses {
    
    var personalExpenses = [ExpenseItem]()
    var businessExpenses = [ExpenseItem]()
    
    var items = [ExpenseItem]() {
        didSet {
            if let encodedData = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encodedData, forKey: "items")
                filterExpenses(at: items)
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "items") {
            if let decodedData = try? JSONDecoder().decode([ExpenseItem].self, from: data) {
                items = decodedData
                filterExpenses(at: decodedData)
                return
            }
        } else{
            items = []
        }
    }
    
    
    
    private func filterExpenses(at item: [ExpenseItem]) {
        personalExpenses = items.filter { $0.type == "Personal" }
        businessExpenses = items.filter { $0.type == "Business" }
    }
    
    
    
}

struct ContentView: View {
    @State var expenses = Expenses()
    @State var showAddExpenseView : Bool = false
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path : $path) {
            List{
                if(expenses.personalExpenses.count > 0){
                    Section("Personal Expenses"){
                        ForEach(expenses.personalExpenses){ item in
                            HStack{
                                VStack(alignment:.leading){
                                    Text(item.name)
                                        .font(.headline)
                                    Text("\(item.type)")
                                        .font(.subheadline)
                                }
                                Spacer()
                                Text(item.amount , format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.headline)
                                
                                    .foregroundColor(currencyColor(at: item.amount))
                            }
                        }.onDelete(perform: removeItem)
                    }
                }
                if(expenses.businessExpenses.count > 0){
                    Section("Business Expenses"){
                        ForEach(expenses.businessExpenses){ item in
                            HStack{
                                VStack(alignment:.leading){
                                    Text(item.name)
                                        .font(.headline)
                                    Text("\(item.type)")
                                        .font(.subheadline)
                                }
                                Spacer()
                                Text(item.amount , format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.headline)
                                
                                    .foregroundColor(currencyColor(at: item.amount))
                            }
                        }.onDelete(perform: removeItem)
                    }
                }
            }.navigationTitle("iExpense")
                .toolbar {
                    ToolbarItemGroup(placement: .automatic) {
                        EditButton()
                        NavigationLink {
                            AddNew(path: $path, expenses: expenses)
                        } label: {
                            Label("Add New", systemImage: "plus")
                        }
                    }
                   
                }
            
            
        }
        
    }
    
    func removeItem(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
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
    
}




#Preview {
    ContentView()
}
