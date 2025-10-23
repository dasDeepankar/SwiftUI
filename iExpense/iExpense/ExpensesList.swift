//
//  ExpensesList.swift
//  iExpense
//
//  Created by Deepankar Das on 23/10/25.
//
import SwiftData
import SwiftUI

struct ExpensesList: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [Expense]
    
    var filter : String
    
    
    var body: some View {
        List{
            Section("\(filter) Expenses"){
                ForEach(expenses){ expense in
                    HStack{
                        VStack(alignment:.leading){
                            Text(expense.name)
                                .font(.headline)
                            Text("\(expense.type)")
                                .font(.subheadline)
                        }
                        Spacer()
                        Text(expense.amount , format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .font(.headline)
                        
                            .foregroundColor(currencyColor(at: expense.amount))
                    }
                }.onDelete(perform: removeItem)
            }
        }
    }
    
    init(sortOrder : [SortDescriptor<Expense>] , filter: String = "All") {
        _expenses = Query(filter: #Predicate<Expense> { expense in
            filter == "All" || expense.type == filter
        }, sort: sortOrder, animation: .bouncy)
        self.filter = filter
    }
    
    func removeItem(at offsets: IndexSet) {
        
        for offset in offsets {
            let expenseItem = expenses[offset]
            modelContext.delete(expenseItem)
        }
    }
}
#Preview {
    NavigationStack{
        ExpensesList(sortOrder : [], filter: "All")
    }
    
}


